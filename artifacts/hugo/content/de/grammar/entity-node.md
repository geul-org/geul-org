---
title: "Entity Node"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "entity", "SIDX", "quantification"]
summary: "Node mit fester Laenge von 4 Woertern (64 Bit) zur Identifikation von Entitaeten wie Personen, Orten, Objekten und Organisationen. 3 Bit Mode druecken Quantifikation und Numerus aus, 6 Bit EntityType klassifizieren 64 Obertypen, und 48 Bit Attributes kodieren typspezifische semantische Attribute."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Entity Node** ist ein **Paket mit fester Laenge von 4 Woertern (64 Bit)**, das Entitaeten (Personen, Orte, Objekte, Organisationen, Konzepte usw.) im GEUL-Stream identifiziert.

## Wesen von SIDX

| Eigenschaft | Beschreibung |
|-------------|--------------|
| **Non-unique** | Mehrere Entitaeten koennen denselben SIDX teilen |
| **Multi-SIDX** | Eine Entitaet kann mehrere SIDX haben (je nach Zeitpunkt/Rolle) |
| **Bit = Semantik** | Die Bitposition selbst repraesentiert ein Attribut |
| **Abstrakt/Konkret-Kontinuum** | Unterscheidung durch Mode und Fuellgrad der Attributes |

**Beispiele:**
- Trump (Immobilienunternehmer) → SIDX_A
- Trump (Praesident) → SIDX_B (anderer SIDX)
- "Human + Male + Korea" → abstraktes "koreanischer Mann"
- "Human + Male + Korea + 1946 + Business + ..." → nahezu eine bestimmte Person

## Designprinzipien

**Verzicht auf integrierten Q-Identifikator:**
- Vollstaendige Investition aller Bits in reine semantische Ausrichtung
- Maximierung der WMS-SIMD-Filterleistung
- Q-ID wird separat ueber [Triple Edge](../triple-edge/) verknuepft: `(Entity_SIDX, P-externalID, "Q12345")`

**Keine Serial-Bits noetig:**
- WMS-Abfragen erfolgen in 2 Schritten: Eingrenzung durch SIMD → Detailpruefung im Bereich
- Serial ist eine bedeutungslose Zahl, die nicht zum SIMD beitraegt
- Diese Bits in semantische Ausrichtung zu investieren verengt den 1. Schritt weiter

## Bit-Layout (4 Woerter = 64 Bit)

```
1st WORD (16 Bit)
┌─────────┬──────┬────────────┐
│ Prefix  │ Mode │ EntityType │
│  7bit   │ 3bit │   6bit     │
└─────────┴──────┴────────────┘

2nd WORD (16 Bit)
┌─────────────────────────────┐
│   Attributes obere 16 Bit   │
└─────────────────────────────┘

3rd WORD (16 Bit)
┌─────────────────────────────┐
│  Attributes mittlere 16 Bit │
└─────────────────────────────┘

4th WORD (16 Bit)
┌─────────────────────────────┐
│   Attributes untere 16 Bit  │
└─────────────────────────────┘
```

| Feld | Bits | Groesse | Beschreibung |
|------|------|---------|--------------|
| Prefix | 1-7 | 7 | `0001001` (Entity Node) |
| Mode | 8-10 | 3 | 8 Quantifikations-/Numerus-Modi |
| EntityType | 11-16 | 6 | 64 Obertypen |
| Attributes | 17-64 | **48** | Variables Schema pro Typ |

## Mode (3 Bit)

Der Mode integriert **Quantifikation und Numerus** der Entitaet in 3 Bit.

| Code | Binaer | Bedeutung | Beispiel |
|------|--------|-----------|----------|
| 0 | 000 | **Registrierte Entitaet** | Yi Sun-sin, Samsung, BTS |
| 1 | 001 | Spezifisch Singular | "diese Person" |
| 2 | 010 | Spezifisch wenige | "diese paar" |
| 3 | 011 | Spezifisch Plural | "diese Leute" |
| 4 | 100 | Universell | "alle ~" |
| 5 | 101 | Existenziell | "irgendein ~" |
| 6 | 110 | Unspezifisch | "ein beliebiger ~" |
| 7 | 111 | Generisch | "~ im Allgemeinen" |

### Registrierte Entitaet (Mode=0)

- Entitaeten, die mit externen IDs wie Wikidata Q-ID, WordNet Synset usw. gemappt sind
- Die Q-ID selbst wird ueber Triple verknuepft: `(Entity_SIDX, P-externalID, "Q12345")`
- **Unabhaengig vom Numerus-Konzept**: Samsung ist "eins", aber Singular zu sagen ist ungenau, BTS ist eine Gruppe, aber eine einzelne Entitaet

### Pronomen/Abstrakta (Mode=1~7)

- Der semantische Bereich wird durch EntityType + Attributes definiert
- Je mehr Bits gefuellt sind, desto spezifischer
- Beispiel: Human(Type) + Male(Attr) + Korea(Attr) = "koreanischer Mann"

## EntityType (6 Bit = 64)

64 Obertypen werden auf Basis der Haeufigkeitsstatistiken von Wikidata P31 (instance of) zugewiesen. Unterklassifikationen werden durch Unterkategorie-Bits in den Attributes behandelt.

| Bereich | Kategorie | Anzahl Typen | Repraesentative Typen |
|---------|-----------|--------------|----------------------|
| 0x00-0x07 | Lebewesen/Personen | 8 | Human, Taxon, Gene, Protein |
| 0x08-0x0B | Chemie/Materie | 4 | Chemical, Compound, Mineral, Drug |
| 0x0C-0x13 | Himmelskoerper | 8 | Star, Galaxy, Asteroid, Planet |
| 0x14-0x1B | Gelaende/Natur | 8 | Mountain, River, Lake, Island |
| 0x1C-0x23 | Orte/Verwaltung | 8 | Settlement, Village, Street, Park |
| 0x24-0x2B | Gebaeude | 8 | Building, Church, School, Bridge |
| 0x2C-0x2F | Organisationen | 4 | Organization, Business, PoliticalParty |
| 0x30-0x3B | Werke | 12 | Painting, Document, Film, Album |
| 0x3C-0x3F | Ereignisse/Sonstiges | 4 | SportsSeason, Event, Election, Other |

### Codetabelle (alle 64 Eintraege)

| Code | Typ | Q-ID | Entitaeten |
|------|-----|------|------------|
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
| 0x3F | Other | - | Fuer Erweiterung |

## Attributes (48 Bit)

Ein **variables Schema pro Typ**, bei dem jeder EntityType mit unterschiedlicher Semantik interpretiert wird. Hochfrequente Attribute erhalten mehr Bits und werden direkt fuer WMS-SIMD-Filterung genutzt.

### Attributes Human (0x00)

```
┌──────────┬────────┬────────┬──────┬────────┬────────┬─────────┬──────────┬────────────┬──────────┐
│ Unterkat.│ Beruf  │ Nation.│ Aera │ Dekade │ Geschl.│ Bekannt.│ Sprache  │ Geburtsreg.│ Taetigk. │
│  5bit    │  6bit  │  8bit  │ 4bit │  4bit  │  2bit  │  3bit   │  6bit    │   6bit     │   4bit   │
└──────────┴────────┴────────┴──────┴────────┴────────┴─────────┴──────────┴────────────┴──────────┘
offset:  0        5       11      19     23      27      29        32         38          44
```

### Attributes Star (0x0C)

```
┌────────────┬────────────┬──────────┬──────────┬────────┬────────┬──────────┬──────────┬────────┬────────┐
│ Sternbild  │ Spekt.typ  │ Leuchtk. │ Scheinb. │ Rekt.  │ Deklin.│ Flags    │ Rad.ges. │ Rotver.│ Parall.│
│   7bit     │    4bit    │   3bit   │  4bit    │  4bit  │  4bit  │   6bit   │   5bit   │  5bit  │  4bit  │
└────────────┴────────────┴──────────┴──────────┴────────┴────────┴──────────┴──────────┴────────┴────────┘
```

**Flag-Bit-Definitionen:**
- bit0: IR (Infrarotquelle)
- bit1: Radio (Radioquelle)
- bit2: X-ray (Roentgenquelle)
- bit3: Binary (Doppelstern)
- bit4: Variable (veraenderlicher Stern)
- bit5: HighPM (hohe Eigenbewegung)

## Operationen

### Entitaet erstellen

```python
def make_entity(
    mode: int,           # 3 Bit
    entity_type: int,    # 6 Bit
    attrs: int           # 48 Bit
) -> bytes:
    PREFIX = 0b0001001   # 7 Bit (Entity Node)

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

### Entitaet parsen

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

## Beispiele

### Registrierte Entitaet: Yi Sun-sin

```python
# Yi Sun-sin (Q211789)
yi_sun_sin = make_entity(
    mode=0,              # Registrierte Entitaet
    entity_type=0x00,    # Human
    attrs=(
        (0x06 << 43) |   # Unterkat.: Military
        (0x01 << 37) |   # Beruf: Admiral
        (0x52 << 29) |   # Nationalitaet: Korea
        (0x5 << 25) |    # Aera: Early Modern
        (0x0 << 21) |    # Dekade: 1540s
        (0x01 << 19) |   # Geschlecht: Male
        (0x7 << 16)      # Bekanntheit: 1000+
    )
)
# Q-ID-Verknuepfung: Triple(yi_sun_sin_SIDX, P-externalID, "Q211789")
```

### Abstrakt: "Alle koreanischen Maenner"

```python
all_korean_men = make_entity(
    mode=4,              # Universell (alle)
    entity_type=0x00,    # Human
    attrs=(
        (0x52 << 29) |   # Nationalitaet: Korea
        (0x01 << 19)     # Geschlecht: Male
    )
)
```

## Untertyp-Mapping

Viele Wikidata-Typen sind Untertypen der 64 EntityType. Der Encoder prueft den P31-Wert und routet zum passenden Obertyp.

| Untertyp (P31) | Obertyp | Entitaeten |
|----------------|---------|------------|
| Q13442814 (scholarly article) | Document (0x31) | 45.2M |
| Q67206691 (infrared source) | Star (0x0C) | 2.6M |
| Q13100073 (village of China) | Village (0x1D) | 592K |

## Abdeckung

| Element | Wert |
|---------|------|
| Wikidata-Entitaeten gesamt | 117,419,925 |
| Wikimedia-intern (ausgenommen) | 8,565,353 (7.3%) |
| SIDX-Ziel | 108,854,572 (92.7%) |
| Direkte Abdeckung 64 Typen | 36,295,074 (33.3%) |
| Untertypabsorption | 71,842,429 (66.0%) |
| Other-Fallback | 717,069 (0.7%) |
| **Endabdeckung** | **100%** |
| **Kollisionsrate** | **< 0.01%** |

## Q-ID-Verknuepfung

Entity Node integriert die Q-ID nicht, sondern verknuepft sie separat ueber [Triple Edge](../triple-edge/).

```
Subject:  Entity_SIDX (64 Bit)
Property: P-externalID (z.B.: P-Wikidata)
Object:   "Q12345" (String oder Integer)
```
