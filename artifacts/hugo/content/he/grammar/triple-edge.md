---
title: "קשת שלישייה"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "סוג Edge המבטא יחסים ומאפיינים בצורת (Subject, Property, Object). מבנה כפול של מצב בסיסי 4 מילים ומצב מורחב 5 מילים לאופטימיזציה של 63 המאפיינים השכיחים ביותר."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge הוא סוג Edge המבטא **יחסים/מאפיינים** בצורת `(Subject, Property, Object)`.

## עיצוב מצב כפול

- **מצב בסיסי (4 מילים):** PropCode 0~62 (Top 63 מאפיינים)
- **מצב מורחב (5 מילים):** PropCode=63 מכסה כל P-ID (יישור סמנטי 16 סיביות)

## מצב בסיסי (4 מילים = 64 סיביות)

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

| שדה | סיביות | תיאור |
|-----|--------|-------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: Top 63 מאפיינים, 63: מצב מורחב |
| Edge TID | 16 | TID של Edge זה |
| Subject TID | 16 | TID נושא Entity/Node |
| Object TID | 16 | TID מושא Entity/Node/Quantity |

## מצב מורחב (5 מילים = 80 סיביות)

כאשר PropCode = 63, נוסף P-ID של 16 סיביות במילה השלישית.

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16 bits)
3rd WORD: P-ID semantic-aligned (16 bits)
4th WORD: Subject TID (16 bits)
5th WORD: Object TID (16 bits)
```

## Top 63 מאפיינים (PropCode 0~62)

מאפיינים שנבחרו על בסיס תדירות שימוש בוויקינתונים.

### סיווג/סוג (Code 0~7)

| Code | P-ID | מאפיין | תיאור |
|------|------|--------|-------|
| 0 | P31 | instance of | מופע של ~ |
| 1 | P279 | subclass of | תת-מחלקה של ~ |
| 2 | P361 | part of | חלק מ~ |
| 3 | P527 | has part | מכיל ~ |
| 4 | P1552 | has quality | תכונה/מאפיין |
| 5 | P460 | same as | זהה |
| 6 | P1889 | different from | שונה מ~ |
| 7 | P156 | followed by | ואחריו |

### מרחב/מיקום (Code 8~15)

| Code | P-ID | מאפיין | תיאור |
|------|------|--------|-------|
| 8 | P17 | country | מדינה |
| 9 | P131 | located in | מיקום (אזור מנהלי) |
| 10 | P276 | location | מיקום (מקום) |
| 11 | P625 | coordinate | קואורדינטות |
| 12 | P30 | continent | יבשת |
| 13 | P36 | capital | בירה |
| 14 | P150 | contains | מכיל (אזור) |
| 15 | P206 | located next to | גוף מים סמוך |

### זמן (Code 16~23)

| Code | P-ID | מאפיין | תיאור |
|------|------|--------|-------|
| 16 | P569 | date of birth | תאריך לידה |
| 17 | P570 | date of death | תאריך פטירה |
| 18 | P571 | inception | תאריך ייסוד |
| 19 | P576 | dissolved | תאריך פירוק |
| 20 | P577 | publication date | תאריך פרסום |
| 21 | P580 | start time | זמן התחלה |
| 22 | P582 | end time | זמן סיום |
| 23 | P585 | point in time | נקודת זמן |

### נתוני אדם בסיסיים (Code 24~31)

| Code | P-ID | מאפיין | תיאור |
|------|------|--------|-------|
| 24 | P19 | place of birth | מקום לידה |
| 25 | P20 | place of death | מקום פטירה |
| 26 | P21 | sex or gender | מין |
| 27 | P27 | citizenship | אזרחות |
| 28 | P735 | given name | שם פרטי |
| 29 | P734 | family name | שם משפחה |
| 30 | P1559 | name in native language | שם מקורי |
| 31 | P742 | pseudonym | שם עט/בדוי |

### יחסים/שייכות (Code 32~39)

| Code | P-ID | מאפיין | תיאור |
|------|------|--------|-------|
| 32 | P22 | father | אב |
| 33 | P25 | mother | אם |
| 34 | P26 | spouse | בן/בת זוג |
| 35 | P40 | child | ילד/ילדה |
| 36 | P3373 | sibling | אח/אחות |
| 37 | P463 | member of | חבר ב~ |
| 38 | P108 | employer | מעסיק |
| 39 | P1027 | conferred by | מוענק על ידי |

### מקצוע/פעילות (Code 40~47)

| Code | P-ID | מאפיין | תיאור |
|------|------|--------|-------|
| 40 | P106 | occupation | מקצוע |
| 41 | P39 | position held | תפקיד |
| 42 | P69 | educated at | השכלה |
| 43 | P101 | field of work | תחום עבודה |
| 44 | P1344 | participant in | השתתפות (אירוע) |
| 45 | P166 | award received | פרסים |
| 46 | P800 | notable work | יצירה מרכזית |
| 47 | P1412 | languages spoken | שפות |

### מדיה/זיהוי (Code 48~55)

| Code | P-ID | מאפיין | תיאור |
|------|------|--------|-------|
| 48 | P18 | image | תמונה |
| 49 | P154 | logo | לוגו |
| 50 | P41 | flag image | דגל |
| 51 | P373 | Commons category | ויקימדיה |
| 52 | P856 | official website | אתר רשמי |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### יצירות/אומנות (Code 56~62)

| Code | P-ID | מאפיין | תיאור |
|------|------|--------|-------|
| 56 | P50 | author | מחבר |
| 57 | P57 | director | במאי |
| 58 | P86 | composer | מלחין |
| 59 | P175 | performer | מבצע/זמר |
| 60 | P136 | genre | ז'אנר |
| 61 | P364 | original language | שפת מקור |
| 62 | P123 | publisher | מוציא לאור |

Code 63 שמור כ**מציין מצב מורחב**.

## סיכום PropCode

```
┌─────────────────────────────────────────────┐
│  0~7:   סיווג/סוג (P31, P279, ...)         │
│  8~15:  מרחב/מיקום (P17, P131, ...)        │
│  16~23: זמן (P569, P570, ...)              │
│  24~31: נתוני אדם (P19, P20, ...)          │
│  32~39: יחסים/שייכות (P22, P25, ...)       │
│  40~47: מקצוע/פעילות (P106, P39, ...)      │
│  48~55: מדיה/זיהוי (P18, P856, ...)        │
│  56~62: יצירות/אומנות (P50, P57, ...)      │
├─────────────────────────────────────────────┤
│  63: מציין מצב מורחב                        │
└─────────────────────────────────────────────┘
```

## דוגמאות

### מצב בסיסי: "Apple היא חברה"

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - Company (Object)

Total: 4 words
```

### מצב מורחב: "גובה מגדל אייפל 330 מטר"

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

## פיענוח

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
