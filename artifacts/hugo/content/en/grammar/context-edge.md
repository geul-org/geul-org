---
title: "Context Edge"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "A lightweight 3-word Edge expressing 'in which worldview/context is this claim true.' Encodes truth conditions across 64 types including source, worldview, fiction, and perspective."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge expresses **"in which worldview/context is this Claim true."**

It corresponds to the concept of possible worlds in Modal Logic, where different facts can exist about the same Subject depending on the worldview.

```
Context "Reality":         (Earth, age, 4.6 billion years)
Context "Young Earth":     (Earth, age, 6000 years)
Context "Harry Potter":    (magic, exists, true)
```

## Packet Structure (3 words, 48 bits)

```
1st WORD (16 bits):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10 bits       │     6 bits      │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16 bits)
3rd WORD: Target TID (16 bits)
```

| Field | Bits | Description |
|-------|------|-------------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=unspecified, 1~62=type, 63=extended (reserved) |
| Context TID | 16 | Unique identifier for this Context |
| Target TID | 16 | Target Claim ([Triple](../triple-edge/)/[Verb](../verb-edge/)/[Event6](../event6-edge/)/[Clause](../clause-edge/) TID) |

## Context Type (6 bits = 64)

### Source -- Code 1~20

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 1 | SYSTEM | System-generated | Wikidata sync |
| 2 | USER | User-entered | Manual creation |
| 3 | DOCUMENT | General document | PDF, Word |
| 4 | NEWS | News article | Reuters, AP |
| 5 | ACADEMIC | Academic paper | arXiv, Nature |
| 6 | GOVERNMENT | Government/public agency | SEC, census bureau |
| 7 | WIKI | Wikipedia/Wikidata | Q42, P31 |
| 8 | API | External API | Finance, weather |
| 9 | ORG | Organization announcement | Corporate IR |
| 10 | BOOK | Book | ISBN-based |
| 11 | INTERVIEW | Interview/testimony | Direct quote |
| 12 | DATASET | Dataset | Kaggle |
| 13 | SOCIAL | Social media | Twitter |
| 14 | LEGAL | Law/case law | Court ruling |
| 15 | ARCHIVE | Archive | archive.org |
| 16 | MULTIMEDIA | Video/audio | YouTube |
| 17 | DATABASE | Database | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | Encyclopedia | Britannica |
| 19 | MANUAL | Manual/guide | Technical docs |
| 20 | STANDARD | Standard document | ISO, RFC |

### Derived/Inference -- Code 21~30

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 21 | MODEL | AI model generation | GPT, Claude |
| 22 | INFERENCE | Logical inference | Rule-based |
| 23 | AGGREGATION | Aggregation/integration | Multi-source synthesis |
| 24 | CALCULATION | Calculation result | Formula application |
| 25 | TRANSLATION | Translation | Source → translation |
| 26 | EXTRACTION | Extraction | NER, RE |
| 27 | CORRECTION | Correction/amendment | Error correction |
| 28 | HEARSAY | Hearsay/rumor | Unverified |
| 29 | ESTIMATION | Estimation | Approximate value |
| 30 | PREDICTION | Prediction | Future forecast |

### Worldview/Belief -- Code 31~45

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 31 | RELIGION | Religious worldview | Protestantism, Buddhism |
| 32 | PHILOSOPHY | Philosophical perspective | Existentialism |
| 33 | SCIENCE | Scientific consensus | Modern physics |
| 34 | POLITICS | Political perspective | Conservative, progressive |
| 35 | CULTURE | Cultural perspective | Eastern, Western |
| 36 | MYTHOLOGY | Mythological system | Greek mythology |
| 37 | FOLKLORE | Folklore/tradition | Local tales |
| 38 | IDEOLOGY | Ideological system | Capitalism |
| 39 | THEORY | Theory | Theory of relativity |
| 40 | HYPOTHESIS | Hypothesis | Pre-verification |
| 41 | TRADITION | Tradition/custom | Confucian tradition |
| 42 | CONSENSUS | Consensus/accepted view | Academic consensus |
| 43 | MAINSTREAM | Mainstream view | Majority opinion |
| 44 | ALTERNATIVE | Alternative view | Minority opinion |
| 45 | FRINGE | Fringe/heterodox | Pseudoscience |

### Fiction/Creative -- Code 46~55

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 46 | NOVEL | Novel universe | Lord of the Rings |
| 47 | FILM | Film universe | MCU |
| 48 | GAME | Game universe | Zelda |
| 49 | COMICS | Comics universe | DC Universe |
| 50 | ANIMATION | Animation universe | Studio Ghibli |
| 51 | DRAMA | Drama universe | Game of Thrones |
| 52 | THEATER | Theater universe | Hamlet |
| 53 | FANFIC | Fan creation | Fan fiction |
| 54 | LEGEND | Legend | King Arthur |
| 55 | FAIRYTALE | Fairy tale | Cinderella |

### Perspective/Speaker -- Code 56~62

| Code | Type | Description | Example |
|------|------|-------------|---------|
| 56 | NARRATOR | Narrator perspective | Omniscient narrator |
| 57 | PROTAGONIST | Protagonist perspective | Hero's viewpoint |
| 58 | ANTAGONIST | Antagonist perspective | Villain's viewpoint |
| 59 | AUTHOR | Author intent | Author's commentary |
| 60 | EXPERT | Expert opinion | Scholar's opinion |
| 61 | LAYMAN | Layperson perception | Public perception |
| 62 | SATIRICAL | Satire/irony | Ironic expression |

Code 0 is UNSPECIFIED, and Code 63 is EXTENDED (reserved).

## Metadata Extension

Additional information about the Context itself (source, confidence, worldview name) is expressed via [Triple Edge](../triple-edge/).

```
(Context TID, P:source_entity, Reuters_Entity)  - Source organization
(Context TID, P:confidence, 0.95)               - Confidence
(Context TID, P:universe_name, "Harry Potter")   - Universe name
(Context TID, P:perspective_holder, Villain_Entity)  - Perspective holder
```

## Examples

### Source: "Reuters report"

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple acquired Tesla"

Additional Triples:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### Fiction: "Harry Potter universe"

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "Hogwarts is_a school"

Additional Triples:
  (0x0302, P:universe_name, "Harry Potter")
  (0x0302, P:author, J.K. Rowling)
```

### AI Inference: "Claude's inference"

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X causes Y"

Additional Triples:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## Design Rationale

- **Context Edge as a separate type**: Worldviews are a meta-layer distinct from Triple/Clause. Corresponds to the G (Graph) in RDF Quads.
- **6-bit Context Type**: Enables immediate classification without separate Triples. 62 types cover most use cases.
- **3-word lightweight structure**: Context links occur in large volumes, so minimal size ensures storage efficiency.
