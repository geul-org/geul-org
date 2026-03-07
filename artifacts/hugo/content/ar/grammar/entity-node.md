---
title: "عقدة الكيان"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "entity", "SIDX", "quantification"]
summary: "عقدة بطول ثابت 4 كلمات (64 بت) لتعريف الكيانات كالأشخاص والأماكن والأشياء والمنظمات. تعبّر عن التحديد والعدد بـ 3 بتات Mode، وتصنّف 64 نوعاً علوياً بـ 6 بتات EntityType، وتشفّر السمات الدلالية بـ 48 بت Attributes."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Entity Node** هي حزمة ثابتة الطول بحجم 4 كلمات (64 بت) تُعرّف الكيانات (أشخاص، أماكن، أشياء، منظمات، مفاهيم، إلخ) في تدفق GEUL.

## جوهر SIDX

| الخاصية | الوصف |
|---------|-------|
| **Non-unique** | يمكن لعدة كيانات أن تتشارك نفس SIDX |
| **Multi-SIDX** | يمكن لكيان واحد أن يملك عدة SIDX (حسب الزمن/الدور) |
| **بت = معنى** | موضع البت ذاته يدل على السمة |
| **تدرج مجرد/ملموس** | يُحدَّد بواسطة Mode ومدى امتلاء Attributes |

**أمثلة:**
- ترامب (رجل أعمال عقاري) → SIDX_A
- ترامب (رئيس) → SIDX_B (SIDX مختلف)
- "Human + Male + Saudi" → "رجل سعودي" تجريدي
- "Human + Male + Saudi + 1946 + Business + ..." → يقترب من شخص محدد

## مبادئ التصميم

**التخلي عن تضمين Q-ID:**
- استثمار جميع البتات في المحاذاة الدلالية الصرفة
- تعظيم أداء ترشيح WMS SIMD
- يُربط Q-ID عبر [الثلاثيات](../triple-edge/) بشكل منفصل: `(Entity_SIDX, P-ExternalID, "Q12345")`

**عدم الحاجة لبتات Serial:**
- استعلام WMS يعمل على مرحلتين: تضييق النطاق بـ SIMD → فحص التفاصيل داخل النطاق
- Serial رقم بلا معنى لا يساهم في SIMD
- استثمار تلك البتات في المحاذاة الدلالية يضيّق النطاق أكثر في المرحلة الأولى

## مخطط البتات (4 كلمات = 64 بت)

```
1st WORD (16 bits)
┌─────────┬──────┬────────────┐
│ Prefix  │ Mode │ EntityType │
│  7bit   │ 3bit │   6bit     │
└─────────┴──────┴────────────┘

2nd WORD (16 bits)
┌─────────────────────────────┐
│   Attributes upper 16 bits  │
└─────────────────────────────┘

3rd WORD (16 bits)
┌─────────────────────────────┐
│   Attributes middle 16 bits │
└─────────────────────────────┘

4th WORD (16 bits)
┌─────────────────────────────┐
│   Attributes lower 16 bits  │
└─────────────────────────────┘
```

| الحقل | البتات | الحجم | الوصف |
|-------|--------|-------|-------|
| Prefix | 1-7 | 7 | `0001001` (Entity Node) |
| Mode | 8-10 | 3 | 8 أوضاع تحديد/عدد |
| EntityType | 11-16 | 6 | 64 نوعاً علوياً |
| Attributes | 17-64 | **48** | مخطط متغير حسب النوع |

## Mode (3 بتات)

يعبّر Mode عن **التحديد (Quantification) والعدد (Number)** بشكل موحد في 3 بتات.

| الرمز | ثنائي | المعنى | مثال |
|-------|-------|--------|------|
| 0 | 000 | **كيان مسجل** | الملك سلمان، أرامكو، BTS |
| 1 | 001 | معرّف مفرد | "ذلك الشخص" |
| 2 | 010 | معرّف قلة | "أولئك القلة" |
| 3 | 011 | معرّف جمع | "أولئك الأشخاص" |
| 4 | 100 | شامل | "كل ~" |
| 5 | 101 | وجودي | "بعض ~" |
| 6 | 110 | غير محدد | "أي ~" |
| 7 | 111 | عام | "~ بشكل عام" |

### كيان مسجل (Mode=0)

- كيان مربوط بمعرّف خارجي مثل Q-ID في ويكي بيانات أو Synset في WordNet
- يُربط Q-ID عبر الثلاثيات: `(Entity_SIDX, P-ExternalID, "Q12345")`
- **لا علاقة بمفهوم العدد**: أرامكو "واحدة" لكن يصعب وصفها بالمفرد، BTS مجموعة لكنها كيان واحد

### ضمائر/تجريد (Mode=1~7)

- يُحدَّد نطاق المعنى بواسطة EntityType + Attributes
- كلما امتلأت البتات أكثر، ازدادت الخصوصية
- مثال: Human(Type) + Male(Attr) + SaudiArabia(Attr) = "رجل سعودي"

## EntityType (6 بتات = 64 نوعاً)

يُخصَّص 64 نوعاً علوياً استناداً إلى إحصائيات تكرار P31 (instance of) في ويكي بيانات. التصنيف التفصيلي يُعالَج عبر بتات التصنيف الفرعي داخل Attributes.

| النطاق | الفئة | عدد الأنواع | أنواع تمثيلية |
|--------|-------|-------------|---------------|
| 0x00-0x07 | كائنات/أشخاص | 8 | Human, Taxon, Gene, Protein |
| 0x08-0x0B | كيمياء/مواد | 4 | Chemical, Compound, Mineral, Drug |
| 0x0C-0x13 | أجرام سماوية | 8 | Star, Galaxy, Asteroid, Planet |
| 0x14-0x1B | تضاريس/طبيعة | 8 | Mountain, River, Lake, Island |
| 0x1C-0x23 | أماكن/إدارية | 8 | Settlement, Village, Street, Park |
| 0x24-0x2B | مبانٍ | 8 | Building, Church, School, Bridge |
| 0x2C-0x2F | منظمات | 4 | Organization, Business, PoliticalParty |
| 0x30-0x3B | أعمال إبداعية | 12 | Painting, Document, Film, Album |
| 0x3C-0x3F | أحداث/أخرى | 4 | SportsSeason, Event, Election, Other |

### جدول الرموز (64 كاملة)

| الرمز | النوع | Q-ID | عدد الكيانات |
|-------|-------|------|-------------|
| 0x00 | Human | Q5 | 12.5M |
| 0x01 | Taxon | Q16521 | 3.8M |
| 0x02 | Gene | Q7187 | 1.2M |
| 0x03 | Protein | Q8054 | 1.0M |
| 0x04 | CellLine | Q21014462 | 154K |
| 0x05 | FamilyName | Q101352 | 662K |
| 0x06 | GivenName | Q202444 | 128K |
| 0x07 | FictionalCharacter | Q15632617 | 98K |
| 0x08 | Chemical | Q113145171 | 1.3M |
| 0x09 | Compound | Q11173 | 1.1M |
| 0x0A | Mineral | Q7946 | 62K |
| 0x0B | Drug | Q12140 | 45K |
| 0x0C | Star | Q523 | 3.6M |
| 0x0D | Galaxy | Q318 | 2.1M |
| 0x0E | Asteroid | Q3863 | 249K |
| 0x0F | Quasar | Q83373 | 178K |
| 0x10 | Planet | Q634 | 15K |
| 0x11 | Nebula | Q12057 | 8K |
| 0x12 | StarCluster | Q168845 | 5K |
| 0x13 | Moon | Q2537 | 3K |
| 0x14 | Mountain | Q8502 | 518K |
| 0x15 | Hill | Q54050 | 321K |
| 0x16 | River | Q4022 | 427K |
| 0x17 | Lake | Q23397 | 292K |
| 0x18 | Stream | Q47521 | 194K |
| 0x19 | Island | Q23442 | 153K |
| 0x1A | Bay | Q39594 | 25K |
| 0x1B | Cave | Q35509 | 20K |
| 0x1C | Settlement | Q486972 | 580K |
| 0x1D | Village | Q532 | 245K |
| 0x1E | Hamlet | Q5084 | 148K |
| 0x1F | Street | Q79007 | 711K |
| 0x20 | Cemetery | Q39614 | 298K |
| 0x21 | AdminRegion | Q15284 | 100K |
| 0x22 | Park | Q22698 | 45K |
| 0x23 | ProtectedArea | Q473972 | 35K |
| 0x24 | Building | Q41176 | 292K |
| 0x25 | Church | Q16970 | 286K |
| 0x26 | School | Q9842 | 242K |
| 0x27 | House | Q3947 | 235K |
| 0x28 | Structure | Q811979 | 216K |
| 0x29 | SportsVenue | Q1076486 | 145K |
| 0x2A | Castle | Q23413 | 42K |
| 0x2B | Bridge | Q12280 | 38K |
| 0x2C | Organization | Q43229 | 531K |
| 0x2D | Business | Q4830453 | 242K |
| 0x2E | PoliticalParty | Q7278 | 35K |
| 0x2F | SportsTeam | Q847017 | 95K |
| 0x30 | Painting | Q3305213 | 1.1M |
| 0x31 | Document | Q49848 | 45M |
| 0x32 | LiteraryWork | Q7725634 | 395K |
| 0x33 | Film | Q11424 | 335K |
| 0x34 | Album | Q482994 | 303K |
| 0x35 | MusicalWork | Q105543609 | 195K |
| 0x36 | TVEpisode | Q21191270 | 177K |
| 0x37 | VideoGame | Q7889 | 172K |
| 0x38 | TVSeries | Q5398426 | 85K |
| 0x39 | Patent | Q43305660 | 289K |
| 0x3A | Software | Q7397 | 13K |
| 0x3B | Website | Q35127 | 12K |
| 0x3C | SportsSeason | Q27020041 | 183K |
| 0x3D | Event | Q1656682 | 10K |
| 0x3E | Election | Q40231 | 11K |
| 0x3F | Other | - | للتوسيع |

## Attributes (48 بت)

مخطط متغير حسب النوع يُفسَّر بمعانٍ مختلفة لكل EntityType. تُخصَّص بتات أكثر للسمات عالية التكرار، وتُستخدم مباشرة في ترشيح WMS SIMD.

### Human (0x00) Attributes

```
┌──────────┬────────┬────────┬──────┬────────┬────────┬─────────┬──────────┬────────────┬──────────┐
│ SubType  │  Job   │ Nation │  Era │ Decade │ Gender │  Fame   │ Language │ BirthArea  │  Field   │
│  5bit    │  6bit  │  8bit  │ 4bit │  4bit  │  2bit  │  3bit   │  6bit    │   6bit     │   4bit   │
└──────────┴────────┴────────┴──────┴────────┴────────┴─────────┴──────────┴────────────┴──────────┘
offset:  0        5       11      19     23      27      29        32         38          44
```

### Star (0x0C) Attributes

```
┌────────────┬────────────┬──────────┬──────────┬────────┬────────┬──────────┬──────────┬────────┬────────┐
│ Constell.  │  Spectral  │ LumClass │ AppMag   │   RA   │  Dec   │  Flags   │ RadVel   │Redshift│Parallax│
│   7bit     │    4bit    │   3bit   │  4bit    │  4bit  │  4bit  │   6bit   │   5bit   │  5bit  │  4bit  │
└────────────┴────────────┴──────────┴──────────┴────────┴────────┴──────────┴──────────┴────────┴────────┘
```

**تعريف بتات الأعلام:**
- bit0: IR (مصدر أشعة تحت حمراء)
- bit1: Radio (مصدر موجات راديو)
- bit2: X-ray (مصدر أشعة سينية)
- bit3: Binary (نجم ثنائي)
- bit4: Variable (نجم متغير)
- bit5: HighPM (حركة ذاتية عالية)

## العمليات

### إنشاء Entity

```python
def make_entity(
    mode: int,           # 3 bits
    entity_type: int,    # 6 bits
    attrs: int           # 48 bits
) -> bytes:
    PREFIX = 0b0001001   # 7 bits (Entity Node)

    word1 = (PREFIX << 9) | (mode << 6) | entity_type
    word2 = (attrs >> 32) & 0xFFFF
    word3 = (attrs >> 16) & 0xFFFF
    word4 = attrs & 0xFFFF

    return (
        word1.to_bytes(2, 'big') +
        word2.to_bytes(2, 'big') +
        word3.to_bytes(2, 'big') +
        word4.to_bytes(2, 'big')
    )
```

### تحليل Entity

```python
def parse_entity(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')
    word2 = int.from_bytes(data[2:4], 'big')
    word3 = int.from_bytes(data[4:6], 'big')
    word4 = int.from_bytes(data[6:8], 'big')

    prefix = (word1 >> 9) & 0x7F
    mode = (word1 >> 6) & 0x7
    entity_type = word1 & 0x3F
    attrs = (word2 << 32) | (word3 << 16) | word4

    return {
        'prefix': prefix,
        'mode': mode,
        'entity_type': entity_type,
        'attrs': attrs
    }
```

## أمثلة

### كيان مسجل: صلاح الدين

```python
# صلاح الدين (Q188589)
saladin = make_entity(
    mode=0,              # كيان مسجل
    entity_type=0x00,    # Human
    attrs=(
        (0x06 << 43) |   # SubType: Military
        (0x01 << 37) |   # Job: Commander
        (0x52 << 29) |   # Nation: Egypt/Syria
        (0x5 << 25) |    # Era: Medieval
        (0x0 << 21) |    # Decade: 1130s
        (0x01 << 19) |   # Gender: Male
        (0x7 << 16)      # Fame: 1000+
    )
)
# ربط Q-ID: Triple(saladin_SIDX, P-ExternalID, "Q188589")
```

### تجريد: "كل رجل سعودي"

```python
all_saudi_men = make_entity(
    mode=4,              # شامل (كل)
    entity_type=0x00,    # Human
    attrs=(
        (0x52 << 29) |   # Nation: Saudi Arabia
        (0x01 << 19)     # Gender: Male
    )
)
```

## ربط الأنواع الفرعية

كثير من أنواع ويكي بيانات هي أنواع فرعية لـ 64 EntityType. يقوم المشفّر بقراءة قيمة P31 وتوجيهها للنوع العلوي المناسب.

| النوع الفرعي (P31) | النوع العلوي | عدد الكيانات |
|---------------------|-------------|-------------|
| Q13442814 (scholarly article) | Document (0x31) | 45.2M |
| Q67206691 (infrared source) | Star (0x0C) | 2.6M |
| Q13100073 (village of China) | Village (0x1D) | 592K |

## التغطية

| العنصر | القيمة |
|--------|--------|
| إجمالي كيانات ويكي بيانات | 117,419,925 |
| Wikimedia داخلية (مستبعدة) | 8,565,353 (7.3%) |
| هدف SIDX | 108,854,572 (92.7%) |
| تغطية مباشرة بـ 64 نوعاً | 36,295,074 (33.3%) |
| استيعاب الأنواع الفرعية | 71,842,429 (66.0%) |
| الرجوع إلى Other | 717,069 (0.7%) |
| **التغطية النهائية** | **100%** |
| **نسبة التصادم** | **< 0.01%** |

## ربط Q-ID

لا تتضمن Entity Node معرّف Q-ID بشكل مباشر، بل يُربط عبر [حافة الثلاثية](../triple-edge/) بشكل منفصل.

```
Subject:  Entity_SIDX (64 bits)
Property: P-ExternalID (e.g. P-Wikidata)
Object:   "Q12345" (string or integer)
```
