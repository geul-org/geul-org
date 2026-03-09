---
title: "حافة الثلاثية"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "نوع Edge يعبّر عن العلاقات والخصائص بصيغة (Subject, Property, Object). بنية مزدوجة من الوضع الأساسي 4 كلمات والوضع الموسع 5 كلمات لتحسين أعلى 63 خاصية تكراراً."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge هو نوع Edge يعبّر عن **العلاقات/الخصائص** بصيغة `(Subject, Property, Object)`.

## تصميم الوضع المزدوج

- **الوضع الأساسي (4 كلمات):** PropCode 0~62 (أعلى 63 خاصية)
- **الوضع الموسع (5 كلمات):** PropCode=63 يغطي كل P-ID (محاذاة دلالية 16 بت)

## الوضع الأساسي (4 كلمات = 64 بت)

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │     PropCode       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD: Edge TID (16 bits)
3rd WORD: Subject TID (16 bits)
4th WORD: Object TID (16 bits)
```

| الحقل | البتات | الوصف |
|-------|--------|-------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: أعلى 63 خاصية، 63: وضع موسع |
| Edge TID | 16 | TID لهذا Edge |
| Subject TID | 16 | TID الفاعل Entity/Node |
| Object TID | 16 | TID المفعول Entity/Node/Quantity |

## الوضع الموسع (5 كلمات = 80 بت)

عندما يكون PropCode = 63 يُضاف P-ID بـ 16 بت في الكلمة الثالثة.

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16 bits)
3rd WORD: P-ID semantic-aligned (16 bits)
4th WORD: Subject TID (16 bits)
5th WORD: Object TID (16 bits)
```

## أعلى 63 خاصية (PropCode 0~62)

خصائص مختارة بناءً على تكرار الاستخدام في ويكي بيانات.

### التصنيف/النوع (Code 0~7)

| Code | P-ID | الخاصية | الوصف |
|------|------|---------|-------|
| 0 | P31 | instance of | نسخة من ~ |
| 1 | P279 | subclass of | فئة فرعية من ~ |
| 2 | P361 | part of | جزء من ~ |
| 3 | P527 | has part | يحتوي على ~ |
| 4 | P1552 | has quality | خاصية/سمة |
| 5 | P460 | same as | مطابق |
| 6 | P1889 | different from | مختلف عن |
| 7 | P156 | followed by | متبوع بـ |

### المكان/الموقع (Code 8~15)

| Code | P-ID | الخاصية | الوصف |
|------|------|---------|-------|
| 8 | P17 | country | الدولة |
| 9 | P131 | located in | الموقع (منطقة إدارية) |
| 10 | P276 | location | الموقع (مكان) |
| 11 | P625 | coordinate | الإحداثيات |
| 12 | P30 | continent | القارة |
| 13 | P36 | capital | العاصمة |
| 14 | P150 | contains | يحتوي (منطقة) |
| 15 | P206 | located next to | مسطح مائي مجاور |

### الزمن (Code 16~23)

| Code | P-ID | الخاصية | الوصف |
|------|------|---------|-------|
| 16 | P569 | date of birth | تاريخ الميلاد |
| 17 | P570 | date of death | تاريخ الوفاة |
| 18 | P571 | inception | تاريخ التأسيس |
| 19 | P576 | dissolved | تاريخ الحل |
| 20 | P577 | publication date | تاريخ النشر |
| 21 | P580 | start time | وقت البداية |
| 22 | P582 | end time | وقت النهاية |
| 23 | P585 | point in time | نقطة زمنية |

### بيانات الشخص الأساسية (Code 24~31)

| Code | P-ID | الخاصية | الوصف |
|------|------|---------|-------|
| 24 | P19 | place of birth | مكان الميلاد |
| 25 | P20 | place of death | مكان الوفاة |
| 26 | P21 | sex or gender | الجنس |
| 27 | P27 | citizenship | الجنسية |
| 28 | P735 | given name | الاسم الأول |
| 29 | P734 | family name | اسم العائلة |
| 30 | P1559 | name in native language | الاسم الأصلي |
| 31 | P742 | pseudonym | اسم مستعار |

### العلاقات/الانتماء (Code 32~39)

| Code | P-ID | الخاصية | الوصف |
|------|------|---------|-------|
| 32 | P22 | father | الأب |
| 33 | P25 | mother | الأم |
| 34 | P26 | spouse | الزوج/الزوجة |
| 35 | P40 | child | الابن/الابنة |
| 36 | P3373 | sibling | الأخ/الأخت |
| 37 | P463 | member of | عضو في |
| 38 | P108 | employer | جهة العمل |
| 39 | P1027 | conferred by | جهة المنح |

### المهنة/النشاط (Code 40~47)

| Code | P-ID | الخاصية | الوصف |
|------|------|---------|-------|
| 40 | P106 | occupation | المهنة |
| 41 | P39 | position held | المنصب |
| 42 | P69 | educated at | المؤهل التعليمي |
| 43 | P101 | field of work | مجال العمل |
| 44 | P1344 | participant in | المشاركة (حدث) |
| 45 | P166 | award received | الجوائز |
| 46 | P800 | notable work | أبرز الأعمال |
| 47 | P1412 | languages spoken | اللغات |

### الوسائط/التعريف (Code 48~55)

| Code | P-ID | الخاصية | الوصف |
|------|------|---------|-------|
| 48 | P18 | image | صورة |
| 49 | P154 | logo | شعار |
| 50 | P41 | flag image | علم |
| 51 | P373 | Commons category | ويكيميديا |
| 52 | P856 | official website | الموقع الرسمي |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### الأعمال/الإبداع (Code 56~62)

| Code | P-ID | الخاصية | الوصف |
|------|------|---------|-------|
| 56 | P50 | author | المؤلف |
| 57 | P57 | director | المخرج |
| 58 | P86 | composer | المؤلف الموسيقي |
| 59 | P175 | performer | المؤدي/المغني |
| 60 | P136 | genre | النوع |
| 61 | P364 | original language | اللغة الأصلية |
| 62 | P123 | publisher | الناشر |

Code 63 محجوز كـ **مؤشر الوضع الموسع**.

## ملخص PropCode

```
┌─────────────────────────────────────────────┐
│  0~7:   التصنيف/النوع (P31, P279, ...)      │
│  8~15:  المكان/الموقع (P17, P131, ...)      │
│  16~23: الزمن (P569, P570, ...)             │
│  24~31: بيانات الشخص (P19, P20, ...)        │
│  32~39: العلاقات/الانتماء (P22, P25, ...)   │
│  40~47: المهنة/النشاط (P106, P39, ...)      │
│  48~55: الوسائط/التعريف (P18, P856, ...)    │
│  56~62: الأعمال/الإبداع (P50, P57, ...)     │
├─────────────────────────────────────────────┤
│  63: مؤشر الوضع الموسع                      │
└─────────────────────────────────────────────┘
```

## أمثلة

### الوضع الأساسي: "Apple شركة"

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - Company (Object)

Total: 4 words
```

### الوضع الموسع: "ارتفاع برج إيفل 330 متراً"

```
P2048 (height) → outside Top 63 → Extended mode

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - P2048 semantic-aligned
  4th: [TID: 0x0030]              - Eiffel Tower (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

Total: 5 words
```

## التحليل

```python
def parse_triple_edge(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000001, "Not Triple Edge"

    prop_code = word1 & 0x3F

    if prop_code < 63:
        # Basic mode (4 words)
        return {
            'mode': 'basic',
            'prop_code': prop_code,
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[4:6], 'big'),
            'object_tid': int.from_bytes(data[6:8], 'big'),
            'words': 4
        }
    else:
        # Extended mode (5 words)
        return {
            'mode': 'extended',
            'p_id': int.from_bytes(data[4:6], 'big'),
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[6:8], 'big'),
            'object_tid': int.from_bytes(data[8:10], 'big'),
            'words': 5
        }
```
