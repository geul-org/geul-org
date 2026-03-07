---
title: "Entity Node"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "entity", "SIDX", "quantification"]
summary: "A fixed-length 4-word (64-bit) Node that identifies entities such as people, places, objects, and organizations. Uses 3-bit Mode for quantification/number, 6-bit EntityType for 64 top-level types, and 48-bit Attributes for type-specific semantic encoding."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Entity Node** is a **fixed-length 4-word (64-bit) packet** in the GEUL stream that identifies entities (people, places, objects, organizations, concepts, etc.).

## SIDX Essence

| Property | Description |
|----------|-------------|
| **Non-unique** | Multiple entities can share the same SIDX |
| **Multi-SIDX** | A single entity can have multiple SIDXs (by time period/role) |
| **Bits = Meaning** | Bit positions themselves represent attributes |
| **Abstract/Concrete continuum** | Distinguished by Mode and Attributes fill level |

**Examples:**
- Trump (real estate businessman) → SIDX_A
- Trump (president) → SIDX_B (different SIDX)
- "Human + Male + Korea" → abstract "Korean man"
- "Human + Male + Korea + 1946 + Business + ..." → nearly a specific individual

## Design Principles

**Abandoning embedded Q-ID:**
- Invest all bits in pure semantic alignment
- Maximize WMS SIMD filtering performance
- Q-IDs are linked separately via [Triple Edge](../triple-edge/): `(Entity_SIDX, P-externalID, "Q12345")`

**No Serial bits needed:**
- WMS queries use a two-stage process: SIMD range narrowing → detail check within range
- Serial numbers are meaningless digits that contribute nothing to SIMD
- Investing those bits in semantic alignment narrows results further in stage 1

## Bit Layout (4 words = 64 bits)

```
1st WORD (16 bits)
┌─────────┬──────┬────────────┐
│ Prefix  │ Mode │ EntityType │
│  7bit   │ 3bit │   6bit     │
└─────────┴──────┴────────────┘

2nd WORD (16 bits)
┌─────────────────────────────┐
│    Attributes upper 16 bits │
└─────────────────────────────┘

3rd WORD (16 bits)
┌─────────────────────────────┐
│   Attributes middle 16 bits │
└─────────────────────────────┘

4th WORD (16 bits)
┌─────────────────────────────┐
│    Attributes lower 16 bits │
└─────────────────────────────┘
```

| Field | Bits | Size | Description |
|-------|------|------|-------------|
| Prefix | 1-7 | 7 | `0001001` (Entity Node) |
| Mode | 8-10 | 3 | 8 quantification/number modes |
| EntityType | 11-16 | 6 | 64 top-level types |
| Attributes | 17-64 | **48** | Type-specific variable schema |

## Mode (3 bits)

Mode unifies **quantification and number** of an entity into 3 bits.

| Code | Binary | Meaning | Example |
|------|--------|---------|---------|
| 0 | 000 | **Registered entity** | Yi Sun-sin, Samsung, BTS |
| 1 | 001 | Definite singular | "that person" |
| 2 | 010 | Definite few | "those few" |
| 3 | 011 | Definite plural | "those people" |
| 4 | 100 | Universal | "every ~" |
| 5 | 101 | Existential | "some ~" |
| 6 | 110 | Indefinite | "any ~" |
| 7 | 111 | Generic | "~ in general" |

### Registered Entity (Mode=0)

- Entities mapped to external IDs such as Wikidata Q-IDs or WordNet Synsets
- Q-IDs are linked via triples: `(Entity_SIDX, P-externalID, "Q12345")`
- **Unrelated to grammatical number**: Samsung is "one entity" but awkward to call singular; BTS is a group but a single entity

### Pronoun/Abstract (Mode=1~7)

- Semantic range is specified by EntityType + Attributes
- More bits filled → more specific
- Example: Human(Type) + Male(Attr) + Korea(Attr) = "Korean man"

## EntityType (6 bits = 64 types)

64 top-level types are assigned based on Wikidata P31 (instance of) frequency statistics. Detailed subclassification is handled by subtype bits within Attributes.

| Range | Category | Type count | Representative types |
|-------|----------|------------|----------------------|
| 0x00-0x07 | Living/Person | 8 | Human, Taxon, Gene, Protein |
| 0x08-0x0B | Chemistry/Material | 4 | Chemical, Compound, Mineral, Drug |
| 0x0C-0x13 | Celestial | 8 | Star, Galaxy, Asteroid, Planet |
| 0x14-0x1B | Terrain/Nature | 8 | Mountain, River, Lake, Island |
| 0x1C-0x23 | Place/Admin | 8 | Settlement, Village, Street, Park |
| 0x24-0x2B | Architecture | 8 | Building, Church, School, Bridge |
| 0x2C-0x2F | Organization | 4 | Organization, Business, PoliticalParty |
| 0x30-0x3B | Creative work | 12 | Painting, Document, Film, Album |
| 0x3C-0x3F | Event/Other | 4 | SportsSeason, Event, Election, Other |

### Code Table (all 64)

| Code | Type | Q-ID | Entity count |
|------|------|------|--------------|
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
| 0x3F | Other | - | For extension |

## Attributes (48 bits)

A **type-specific variable schema** interpreted differently for each EntityType. More bits are allocated to high-frequency attributes, and it is directly used for WMS SIMD filtering.

### Human (0x00) Attributes

```
┌──────────┬────────┬────────┬──────┬────────┬────────┬─────────┬──────────┬────────────┬──────────┐
│ Subtype  │ Occup. │ Nation │ Era  │ Decade │ Gender │ Notab.  │ Language │ BirthArea  │  Field   │
│  5bit    │  6bit  │  8bit  │ 4bit │  4bit  │  2bit  │  3bit   │  6bit    │   6bit     │   4bit   │
└──────────┴────────┴────────┴──────┴────────┴────────┴─────────┴──────────┴────────────┴──────────┘
offset:  0        5       11      19     23      27      29        32         38          44
```

### Star (0x0C) Attributes

```
┌────────────┬────────────┬──────────┬──────────┬────────┬────────┬──────────┬──────────┬────────┬────────┐
│ Constell.  │ SpectType  │ LumClass │ AppMag   │  RA    │  Dec   │  Flags   │ RadVel   │Redshift│Parallax│
│   7bit     │    4bit    │   3bit   │  4bit    │  4bit  │  4bit  │   6bit   │   5bit   │  5bit  │  4bit  │
└────────────┴────────────┴──────────┴──────────┴────────┴────────┴──────────┴──────────┴────────┴────────┘
```

**Flag bit definitions:**
- bit0: IR (infrared source)
- bit1: Radio (radio source)
- bit2: X-ray (X-ray source)
- bit3: Binary (binary star)
- bit4: Variable (variable star)
- bit5: HighPM (high proper motion)

## Operations

### Entity Creation

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

### Entity Parsing

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

## Examples

### Registered Entity: Yi Sun-sin

```python
# Yi Sun-sin (Q211789)
yi_sun_sin = make_entity(
    mode=0,              # Registered entity
    entity_type=0x00,    # Human
    attrs=(
        (0x06 << 43) |   # Subtype: Military
        (0x01 << 37) |   # Occupation: Admiral
        (0x52 << 29) |   # Nationality: Korea
        (0x5 << 25) |    # Era: Early Modern
        (0x0 << 21) |    # Decade: 1540s
        (0x01 << 19) |   # Gender: Male
        (0x7 << 16)      # Notability: 1000+
    )
)
# Q-ID link: Triple(yi_sun_sin_SIDX, P-externalID, "Q211789")
```

### Abstract: "every Korean man"

```python
all_korean_men = make_entity(
    mode=4,              # Universal (every)
    entity_type=0x00,    # Human
    attrs=(
        (0x52 << 29) |   # Nationality: Korea
        (0x01 << 19)     # Gender: Male
    )
)
```

## Subtype Mapping

Many Wikidata types are subtypes of the 64 EntityTypes. The encoder inspects the P31 value and routes to the appropriate parent type.

| Subtype (P31) | Parent type | Entity count |
|---------------|-------------|--------------|
| Q13442814 (scholarly article) | Document (0x31) | 45.2M |
| Q67206691 (infrared source) | Star (0x0C) | 2.6M |
| Q13100073 (village of China) | Village (0x1D) | 592K |

## Coverage

| Item | Value |
|------|-------|
| Total Wikidata entities | 117,419,925 |
| Wikimedia internal (excluded) | 8,565,353 (7.3%) |
| SIDX target | 108,854,572 (92.7%) |
| Direct coverage by 64 types | 36,295,074 (33.3%) |
| Subtype absorption | 71,842,429 (66.0%) |
| Other fallback | 717,069 (0.7%) |
| **Final coverage** | **100%** |
| **Collision rate** | **< 0.01%** |

## Q-ID Linking

Entity Node does not embed Q-IDs internally. Instead, they are linked separately via [Triple Edge](../triple-edge/).

```
Subject:  Entity_SIDX (64 bits)
Property: P-externalID (e.g., P-Wikidata)
Object:   "Q12345" (string or integer)
```
