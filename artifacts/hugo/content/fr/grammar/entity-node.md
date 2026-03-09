---
title: "Entity Node"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "entity", "SIDX", "quantification"]
summary: "Node a longueur fixe de 4 mots (64 bits) identifiant des entites telles que personnes, lieux, objets et organisations. 3 bits de Mode expriment la quantification et le nombre, 6 bits d'EntityType classifient 64 types superieurs, et 48 bits d'Attributes encodent les attributs semantiques par type."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Entity Node** est un **paquet a longueur fixe de 4 mots (64 bits)** qui identifie les entites (personnes, lieux, objets, organisations, concepts, etc.) dans le flux GEUL.

## Essence de SIDX

| Caracteristique | Description |
|-----------------|-------------|
| **Non-unique** | Plusieurs entites peuvent partager le meme SIDX |
| **Multi-SIDX** | Une entite peut avoir plusieurs SIDX (selon le moment/role) |
| **Bit = Semantique** | La position du bit elle-meme represente un attribut |
| **Continuum abstrait/concret** | Distingue par le Mode et le degre de remplissage des Attributes |

**Exemples :**
- Trump (homme d'affaires immobilier) → SIDX_A
- Trump (president) → SIDX_B (SIDX different)
- "Human + Male + Korea" → abstrait : "homme coreen"
- "Human + Male + Korea + 1946 + Business + ..." → presque un individu specifique

## Principes de conception

**Abandon de l'identifiant Q integre :**
- Investissement total des bits dans l'alignement semantique pur
- Maximisation des performances de filtrage SIMD du WMS
- L'identifiant Q est relie separement via [Triple Edge](../triple-edge/) : `(Entity_SIDX, P-externalID, "Q12345")`

**Bits Serial non necessaires :**
- Les requetes WMS se font en 2 etapes : reduction de portee par SIMD → verification des details dans la portee
- Serial est un nombre sans signification qui ne contribue pas au SIMD
- Investir ces bits dans l'alignement semantique resserre davantage la 1re etape

## Disposition des bits (4 mots = 64 bits)

```
1st WORD (16 bits)
┌─────────┬──────┬────────────┐
│ Prefix  │ Mode │ EntityType │
│  7bit   │ 3bit │   6bit     │
└─────────┴──────┴────────────┘

2nd WORD (16 bits)
┌─────────────────────────────┐
│   Attributes bits sup. 16   │
└─────────────────────────────┘

3rd WORD (16 bits)
┌─────────────────────────────┐
│   Attributes bits moy. 16   │
└─────────────────────────────┘

4th WORD (16 bits)
┌─────────────────────────────┐
│   Attributes bits inf. 16   │
└─────────────────────────────┘
```

| Champ | Bits | Taille | Description |
|-------|------|--------|-------------|
| Prefix | 1-7 | 7 | `0001001` (Entity Node) |
| Mode | 8-10 | 3 | 8 modes de quantification/nombre |
| EntityType | 11-16 | 6 | 64 types superieurs |
| Attributes | 17-64 | **48** | Schema variable par type |

## Mode (3 bits)

Le Mode integre la **quantification et le nombre** de l'entite en 3 bits.

| Code | Binaire | Signification | Exemple |
|------|---------|---------------|---------|
| 0 | 000 | **Entite enregistree** | Yi Sun-sin, Samsung, BTS |
| 1 | 001 | Specifique singulier | "cette personne" |
| 2 | 010 | Specifique petit nombre | "ces quelques-uns" |
| 3 | 011 | Specifique pluriel | "ces personnes" |
| 4 | 100 | Universel | "tous les ~" |
| 5 | 101 | Existentiel | "un certain ~" |
| 6 | 110 | Non specifique | "n'importe quel ~" |
| 7 | 111 | Generique | "~ en general" |

### Entite enregistree (Mode=0)

- Entites mappees avec des identifiants externes tels que Wikidata Q-ID, WordNet Synset, etc.
- Le Q-ID lui-meme est relie via Triple : `(Entity_SIDX, P-externalID, "Q12345")`
- **Independant du concept de nombre** : Samsung est "un" mais dire singulier est ambigu, BTS est un groupe mais une seule entite

### Pronoms/Abstraits (Mode=1~7)

- La portee semantique est definie par EntityType + Attributes
- Plus les bits sont remplis, plus c'est specifique
- Exemple : Human(Type) + Male(Attr) + Korea(Attr) = "homme coreen"

## EntityType (6 bits = 64)

64 types superieurs sont attribues sur la base de statistiques de frequence de Wikidata P31 (instance of). Les sous-classifications sont gerees par des bits de sous-categorie dans les Attributes.

| Plage | Categorie | Nb types | Types representatifs |
|-------|-----------|----------|----------------------|
| 0x00-0x07 | Etres vivants/Personnes | 8 | Human, Taxon, Gene, Protein |
| 0x08-0x0B | Chimie/Matiere | 4 | Chemical, Compound, Mineral, Drug |
| 0x0C-0x13 | Objets celestes | 8 | Star, Galaxy, Asteroid, Planet |
| 0x14-0x1B | Relief/Nature | 8 | Mountain, River, Lake, Island |
| 0x1C-0x23 | Lieux/Administration | 8 | Settlement, Village, Street, Park |
| 0x24-0x2B | Batiments | 8 | Building, Church, School, Bridge |
| 0x2C-0x2F | Organisations | 4 | Organization, Business, PoliticalParty |
| 0x30-0x3B | Oeuvres | 12 | Painting, Document, Film, Album |
| 0x3C-0x3F | Evenements/Divers | 4 | SportsSeason, Event, Election, Other |

### Table de codes (64 entrees completes)

| Code | Type | Q-ID | Nb entites |
|------|------|------|------------|
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
| 0x3F | Other | - | Pour extension |

## Attributes (48 bits)

Un **schema variable par type** ou chaque EntityType est interprete avec une semantique differente. Les attributs a haute frequence recoivent davantage de bits et sont directement utilises pour le filtrage SIMD du WMS.

### Attributes Human (0x00)

```
┌──────────┬────────┬────────┬──────┬────────┬────────┬─────────┬──────────┬────────────┬──────────┐
│ Sous-cat │ Metier │ Nation.│ Ere  │ Decen. │ Genre  │ Notori. │ Langue   │ Region     │ Domaine  │
│  5bit    │  6bit  │  8bit  │ 4bit │  4bit  │  2bit  │  3bit   │  6bit    │   6bit     │   4bit   │
└──────────┴────────┴────────┴──────┴────────┴────────┴─────────┴──────────┴────────────┴──────────┘
offset:  0        5       11      19     23      27      29        32         38          44
```

### Attributes Star (0x0C)

```
┌────────────┬────────────┬──────────┬──────────┬────────┬────────┬──────────┬──────────┬────────┬────────┐
│ Constell.  │ Sp. type   │ Cl. lum. │ Mag. app.│ Asc. dr│ Declin.│ Drapeaux │ Vit. rad.│ Redsh. │ Parall.│
│   7bit     │    4bit    │   3bit   │  4bit    │  4bit  │  4bit  │   6bit   │   5bit   │  5bit  │  4bit  │
└────────────┴────────────┴──────────┴──────────┴────────┴────────┴──────────┴──────────┴────────┴────────┘
```

**Definition des bits de drapeaux :**
- bit0 : IR (source infrarouge)
- bit1 : Radio (source radio)
- bit2 : X-ray (source de rayons X)
- bit3 : Binary (etoile binaire)
- bit4 : Variable (etoile variable)
- bit5 : HighPM (mouvement propre eleve)

## Operations

### Creation d'entite

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

### Analyse d'entite

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

## Exemples

### Entite enregistree : Yi Sun-sin

```python
# Yi Sun-sin (Q211789)
yi_sun_sin = make_entity(
    mode=0,              # Entite enregistree
    entity_type=0x00,    # Human
    attrs=(
        (0x06 << 43) |   # Sous-cat : Military
        (0x01 << 37) |   # Metier : Admiral
        (0x52 << 29) |   # Nationalite : Korea
        (0x5 << 25) |    # Ere : Early Modern
        (0x0 << 21) |    # Decennie : 1540s
        (0x01 << 19) |   # Genre : Male
        (0x7 << 16)      # Notoriete : 1000+
    )
)
# Liaison Q-ID : Triple(yi_sun_sin_SIDX, P-externalID, "Q211789")
```

### Abstrait : "Tous les hommes coreens"

```python
all_korean_men = make_entity(
    mode=4,              # Universel (tous)
    entity_type=0x00,    # Human
    attrs=(
        (0x52 << 29) |   # Nationalite : Korea
        (0x01 << 19)     # Genre : Male
    )
)
```

## Mappage des sous-types

De nombreux types de Wikidata sont des sous-types des 64 EntityType. L'encodeur examine la valeur P31 et route vers le type superieur approprie.

| Sous-type (P31) | Type superieur | Nb entites |
|-----------------|----------------|------------|
| Q13442814 (scholarly article) | Document (0x31) | 45.2M |
| Q67206691 (infrared source) | Star (0x0C) | 2.6M |
| Q13100073 (village of China) | Village (0x1D) | 592K |

## Couverture

| Element | Valeur |
|---------|--------|
| Total entites Wikidata | 117,419,925 |
| Interne Wikimedia (exclu) | 8,565,353 (7.3%) |
| Cible SIDX | 108,854,572 (92.7%) |
| Couverture directe 64 types | 36,295,074 (33.3%) |
| Absorption sous-types | 71,842,429 (66.0%) |
| Repli Other | 717,069 (0.7%) |
| **Couverture finale** | **100%** |
| **Taux de collision** | **< 0.01%** |

## Liaison Q-ID

Entity Node n'integre pas le Q-ID ; il est relie separement via [Triple Edge](../triple-edge/).

```
Subject:  Entity_SIDX (64 bits)
Property: P-externalID (ex: P-Wikidata)
Object:   "Q12345" (chaine ou entier)
```
