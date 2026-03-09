---
title: "צומת ישות"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "entity", "SIDX", "quantification"]
summary: "צומת באורך קבוע של 4 מילים (64 סיביות) לזיהוי ישויות כגון אנשים, מקומות, חפצים וארגונים. מבטא כימות ומספר ב-3 סיביות Mode, מסווג 64 סוגים עליונים ב-6 סיביות EntityType, ומקודד תכונות סמנטיות ב-48 סיביות Attributes."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Entity Node** היא מנת אורך קבוע בגודל 4 מילים (64 סיביות) המזהה ישויות (אנשים, מקומות, חפצים, ארגונים, מושגים ועוד) בזרימת GEUL.

## מהות SIDX

| מאפיין | תיאור |
|--------|-------|
| **Non-unique** | מספר ישויות יכולות לחלוק אותו SIDX |
| **Multi-SIDX** | ישות אחת יכולה להחזיק מספר SIDX (לפי זמן/תפקיד) |
| **סיבית = משמעות** | מיקום הסיבית עצמו מייצג תכונה |
| **רצף מופשט/קונקרטי** | נקבע לפי Mode ומידת מילוי Attributes |

**דוגמאות:**
- טראמפ (יזם נדל"ן) → SIDX_A
- טראמפ (נשיא) → SIDX_B (SIDX שונה)
- "Human + Male + Israel" → "גבר ישראלי" מופשט
- "Human + Male + Israel + 1946 + Business + ..." → כמעט אדם ספציפי

## עקרונות עיצוב

**ויתור על הטמעת Q-ID:**
- השקעת כל הסיביות ביישור סמנטי טהור
- מיקסום ביצועי סינון WMS SIMD
- Q-ID מחובר בנפרד דרך [שלישיות](../triple-edge/): `(Entity_SIDX, P-ExternalID, "Q12345")`

**אין צורך בסיביות Serial:**
- שאילתת WMS פועלת בשני שלבים: צמצום טווח ב-SIMD → בדיקת פרטים בטווח
- Serial הוא מספר חסר משמעות שאינו תורם ל-SIMD
- השקעת אותן סיביות ביישור סמנטי מצמצמת יותר בשלב הראשון

## פריסת סיביות (4 מילים = 64 סיביות)

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

| שדה | סיביות | גודל | תיאור |
|-----|--------|------|-------|
| Prefix | 1-7 | 7 | `0001001` (Entity Node) |
| Mode | 8-10 | 3 | 8 מצבי כימות/מספר |
| EntityType | 11-16 | 6 | 64 סוגים עליונים |
| Attributes | 17-64 | **48** | סכמה משתנה לפי סוג |

## Mode (3 סיביות)

Mode מבטא **כימות (Quantification) ומספר (Number)** באופן מאוחד ב-3 סיביות.

| קוד | בינארי | משמעות | דוגמה |
|-----|--------|--------|-------|
| 0 | 000 | **ישות רשומה** | בן-גוריון, טבע, BTS |
| 1 | 001 | מוגדר יחיד | "האדם ההוא" |
| 2 | 010 | מוגדר מועט | "אותם מעטים" |
| 3 | 011 | מוגדר רבים | "אותם אנשים" |
| 4 | 100 | כולל | "כל ~" |
| 5 | 101 | קיומי | "איזשהו ~" |
| 6 | 110 | בלתי מוגדר | "כלשהו ~" |
| 7 | 111 | כללי | "~ באופן כללי" |

### ישות רשומה (Mode=0)

- ישות הממופה למזהה חיצוני כגון Q-ID של ויקינתונים או Synset של WordNet
- Q-ID מחובר דרך שלישיות: `(Entity_SIDX, P-ExternalID, "Q12345")`
- **ללא קשר למושג מספר**: טבע היא "אחת" אך קשה לכנותה יחיד, BTS היא קבוצה אך ישות אחת

### כינויים/הפשטה (Mode=1~7)

- טווח המשמעות נקבע באמצעות EntityType + Attributes
- ככל שמתמלאות יותר סיביות, כך גדלה הספציפיות
- דוגמה: Human(Type) + Male(Attr) + Israel(Attr) = "גבר ישראלי"

## EntityType (6 סיביות = 64 סוגים)

64 סוגים עליונים מוקצים על בסיס סטטיסטיקת תדירות P31 (instance of) מוויקינתונים. סיווג מפורט מטופל באמצעות סיביות תת-סיווג בתוך Attributes.

| טווח | קטגוריה | מספר סוגים | סוגים מייצגים |
|------|---------|------------|---------------|
| 0x00-0x07 | יצורים/אישים | 8 | Human, Taxon, Gene, Protein |
| 0x08-0x0B | כימיה/חומרים | 4 | Chemical, Compound, Mineral, Drug |
| 0x0C-0x13 | גרמי שמיים | 8 | Star, Galaxy, Asteroid, Planet |
| 0x14-0x1B | גיאוגרפיה/טבע | 8 | Mountain, River, Lake, Island |
| 0x1C-0x23 | מקומות/מנהל | 8 | Settlement, Village, Street, Park |
| 0x24-0x2B | מבנים | 8 | Building, Church, School, Bridge |
| 0x2C-0x2F | ארגונים | 4 | Organization, Business, PoliticalParty |
| 0x30-0x3B | יצירות | 12 | Painting, Document, Film, Album |
| 0x3C-0x3F | אירועים/אחר | 4 | SportsSeason, Event, Election, Other |

### טבלת קודים (64 מלאה)

| קוד | סוג | Q-ID | מספר ישויות |
|-----|-----|------|------------|
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
| 0x3F | Other | - | להרחבה |

## Attributes (48 סיביות)

סכמה משתנה לפי סוג המתפרשת במשמעויות שונות עבור כל EntityType. סיביות רבות יותר מוקצות לתכונות בתדירות גבוהה, ומשמשות ישירות לסינון WMS SIMD.

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

**הגדרת סיביות דגלים:**
- bit0: IR (מקור אינפרא-אדום)
- bit1: Radio (מקור רדיו)
- bit2: X-ray (מקור רנטגן)
- bit3: Binary (כוכב כפול)
- bit4: Variable (כוכב משתנה)
- bit5: HighPM (תנועה עצמית גבוהה)

## פעולות

### יצירת Entity

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

### פיענוח Entity

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

## דוגמאות

### ישות רשומה: בן-גוריון

```python
# בן-גוריון (Q37453)
ben_gurion = make_entity(
    mode=0,              # ישות רשומה
    entity_type=0x00,    # Human
    attrs=(
        (0x06 << 43) |   # SubType: Political
        (0x01 << 37) |   # Job: Prime Minister
        (0x52 << 29) |   # Nation: Israel
        (0x5 << 25) |    # Era: Modern
        (0x0 << 21) |    # Decade: 1880s
        (0x01 << 19) |   # Gender: Male
        (0x7 << 16)      # Fame: 1000+
    )
)
# חיבור Q-ID: Triple(ben_gurion_SIDX, P-ExternalID, "Q37453")
```

### הפשטה: "כל גבר ישראלי"

```python
all_israeli_men = make_entity(
    mode=4,              # כולל (כל)
    entity_type=0x00,    # Human
    attrs=(
        (0x52 << 29) |   # Nation: Israel
        (0x01 << 19)     # Gender: Male
    )
)
```

## מיפוי תת-סוגים

סוגים רבים בוויקינתונים הם תת-סוגים של 64 EntityType. המקודד קורא את ערך P31 ומנתב לסוג העליון המתאים.

| תת-סוג (P31) | סוג עליון | מספר ישויות |
|---------------|-----------|------------|
| Q13442814 (scholarly article) | Document (0x31) | 45.2M |
| Q67206691 (infrared source) | Star (0x0C) | 2.6M |
| Q13100073 (village of China) | Village (0x1D) | 592K |

## כיסוי

| פריט | ערך |
|------|-----|
| סך ישויות ויקינתונים | 117,419,925 |
| Wikimedia פנימי (לא נכלל) | 8,565,353 (7.3%) |
| יעד SIDX | 108,854,572 (92.7%) |
| כיסוי ישיר ב-64 סוגים | 36,295,074 (33.3%) |
| ספיגת תת-סוגים | 71,842,429 (66.0%) |
| נפילה ל-Other | 717,069 (0.7%) |
| **כיסוי סופי** | **100%** |
| **שיעור התנגשויות** | **< 0.01%** |

## חיבור Q-ID

Entity Node אינו מכיל Q-ID בתוכו, אלא מחבר אותו בנפרד דרך [קשת שלישייה](../triple-edge/).

```
Subject:  Entity_SIDX (64 bits)
Property: P-ExternalID (e.g. P-Wikidata)
Object:   "Q12345" (string or integer)
```
