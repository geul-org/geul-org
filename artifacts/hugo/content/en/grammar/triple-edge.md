---
title: "Triple Edge"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "An Edge type expressing relationships and attributes in (Subject, Property, Object) form. Optimizes Top 63 high-frequency properties with a dual structure of basic mode (4 words) and extended mode (5 words)."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge is an Edge type that expresses **relationships and attributes** in the form `(Subject, Property, Object)`.

## Dual Mode Design

- **Basic mode (4 words):** PropCode 0~62 (Top 63 properties)
- **Extended mode (5 words):** When PropCode=63, covers all P-IDs (semantic-aligned 16-bit)

## Basic Mode (4 words = 64 bits)

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

| Field | Bits | Description |
|-------|------|-------------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: Top 63 properties, 63: extended mode |
| Edge TID | 16 | TID of this Edge |
| Subject TID | 16 | Subject Entity/Node TID |
| Object TID | 16 | Object Entity/Node/Quantity TID |

## Extended Mode (5 words = 80 bits)

When PropCode is 63, a 16-bit P-ID is added in the 3rd word.

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16 bits)
3rd WORD: P-ID semantic-aligned (16 bits)
4th WORD: Subject TID (16 bits)
5th WORD: Object TID (16 bits)
```

## Top 63 Properties (PropCode 0~62)

Properties selected based on Wikidata usage frequency.

### Classification/Type (Code 0~7)

| Code | P-ID | Property | Description |
|------|------|----------|-------------|
| 0 | P31 | instance of | Instance of ~ |
| 1 | P279 | subclass of | Subclass of ~ |
| 2 | P361 | part of | Part of ~ |
| 3 | P527 | has part | Contains ~ |
| 4 | P1552 | has quality | Attribute/characteristic |
| 5 | P460 | same as | Identical |
| 6 | P1889 | different from | Different |
| 7 | P156 | followed by | Successor |

### Spatial/Location (Code 8~15)

| Code | P-ID | Property | Description |
|------|------|----------|-------------|
| 8 | P17 | country | Country |
| 9 | P131 | located in | Location (administrative) |
| 10 | P276 | location | Location (place) |
| 11 | P625 | coordinate | Coordinates |
| 12 | P30 | continent | Continent |
| 13 | P36 | capital | Capital |
| 14 | P150 | contains | Contains (region) |
| 15 | P206 | located next to | Adjacent body of water |

### Time (Code 16~23)

| Code | P-ID | Property | Description |
|------|------|----------|-------------|
| 16 | P569 | date of birth | Date of birth |
| 17 | P570 | date of death | Date of death |
| 18 | P571 | inception | Date of establishment |
| 19 | P576 | dissolved | Date of dissolution |
| 20 | P577 | publication date | Publication date |
| 21 | P580 | start time | Start time |
| 22 | P582 | end time | End time |
| 23 | P585 | point in time | Point in time |

### Person Basics (Code 24~31)

| Code | P-ID | Property | Description |
|------|------|----------|-------------|
| 24 | P19 | place of birth | Place of birth |
| 25 | P20 | place of death | Place of death |
| 26 | P21 | sex or gender | Sex or gender |
| 27 | P27 | citizenship | Citizenship |
| 28 | P735 | given name | Given name |
| 29 | P734 | family name | Family name |
| 30 | P1559 | name in native language | Name in native language |
| 31 | P742 | pseudonym | Pseudonym/stage name |

### Relationships/Affiliation (Code 32~39)

| Code | P-ID | Property | Description |
|------|------|----------|-------------|
| 32 | P22 | father | Father |
| 33 | P25 | mother | Mother |
| 34 | P26 | spouse | Spouse |
| 35 | P40 | child | Child |
| 36 | P3373 | sibling | Sibling |
| 37 | P463 | member of | Member of |
| 38 | P108 | employer | Employer |
| 39 | P1027 | conferred by | Conferring institution |

### Occupation/Activity (Code 40~47)

| Code | P-ID | Property | Description |
|------|------|----------|-------------|
| 40 | P106 | occupation | Occupation |
| 41 | P39 | position held | Position held |
| 42 | P69 | educated at | Educated at |
| 43 | P101 | field of work | Field of work |
| 44 | P1344 | participant in | Participated in (event) |
| 45 | P166 | award received | Award received |
| 46 | P800 | notable work | Notable work |
| 47 | P1412 | languages spoken | Languages spoken |

### Media/Identification (Code 48~55)

| Code | P-ID | Property | Description |
|------|------|----------|-------------|
| 48 | P18 | image | Image |
| 49 | P154 | logo | Logo |
| 50 | P41 | flag image | Flag/banner |
| 51 | P373 | Commons category | Wikimedia Commons |
| 52 | P856 | official website | Official website |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### Works/Creative (Code 56~62)

| Code | P-ID | Property | Description |
|------|------|----------|-------------|
| 56 | P50 | author | Author |
| 57 | P57 | director | Director |
| 58 | P86 | composer | Composer |
| 59 | P175 | performer | Performer/singer |
| 60 | P136 | genre | Genre |
| 61 | P364 | original language | Original language |
| 62 | P123 | publisher | Publisher |

Code 63 is reserved as the **extended mode indicator**.

## PropCode Summary

```
┌─────────────────────────────────────────────┐
│  0~7:   Classification/Type (P31, P279, ...)│
│  8~15:  Spatial/Location (P17, P131, ...)   │
│  16~23: Time (P569, P570, ...)              │
│  24~31: Person Basics (P19, P20, ...)       │
│  32~39: Relationships/Affiliation (P22, ...) │
│  40~47: Occupation/Activity (P106, P39, ...)│
│  48~55: Media/Identification (P18, P856, ...)│
│  56~62: Works/Creative (P50, P57, ...)      │
├─────────────────────────────────────────────┤
│  63: Extended mode indicator                │
└─────────────────────────────────────────────┘
```

## Examples

### Basic mode: "Apple is a company"

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - Company (Object)

Total: 4 words
```

### Extended mode: "The Eiffel Tower is 330m tall"

```
P2048 (height) → Not in Top 63 → Extended mode

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - P2048 semantic-aligned
  4th: [TID: 0x0030]              - Eiffel Tower (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

Total: 5 words
```

## Parsing

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
