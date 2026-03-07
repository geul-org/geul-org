---
title: "Context Edge"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "Leichtgewichtiger 3-Woerter-Edge, der ausdrueckt, 'in welcher Weltanschauung/welchem Kontext diese Behauptung wahr ist'. 64 Typen fuer Quelle, Weltanschauung, Fiktion und Perspektive kodieren die Wahrheitsbedingungen."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge drueckt aus: **"In welcher Weltanschauung/welchem Kontext ist diese Behauptung (Claim) wahr?"**

Er entspricht dem Konzept moeglicher Welten aus der Modallogik: Fuer dasselbe Subjekt koennen je nach Weltanschauung unterschiedliche Fakten existieren.

```
Context "Realitaet":         (Erde, Alter, 4,6 Milliarden Jahre)
Context "Junge Erde":        (Erde, Alter, 6000 Jahre)
Context "Harry Potter":      (Magie, exists, true)
```

## Paketstruktur (3 Woerter, 48 Bit)

```
1st WORD (16 Bit):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10 Bit        │     6 Bit       │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16 Bit)
3rd WORD: Target TID (16 Bit)
```

| Feld | Bits | Beschreibung |
|------|------|--------------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=unbestimmt, 1~62=Typ, 63=erweitert (reserviert) |
| Context TID | 16 | Eindeutiger Identifikator dieses Context |
| Target TID | 16 | Ziel-TID ([Triple](../triple-edge/)/[Verb](../verb-edge/)/[Event6](../event6-edge/)/[Clause](../clause-edge/)) |

## Context Type (6 Bit = 64)

### Quelle (Source) — Code 1~20

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 1 | SYSTEM | Automatisch generiert | Wikidata-Synchronisation |
| 2 | USER | Benutzereingabe | Manuelle Erstellung |
| 3 | DOCUMENT | Allgemeines Dokument | PDF, Word |
| 4 | NEWS | Nachrichtenartikel | Reuters, AP |
| 5 | ACADEMIC | Wissenschaftlicher Artikel | arXiv, Nature |
| 6 | GOVERNMENT | Regierung/Oeffentliche Stelle | SEC, Statistikamt |
| 7 | WIKI | Wikipedia/Wikidata | Q42, P31 |
| 8 | API | Externe API | Finanzen, Wetter |
| 9 | ORG | Organisationsmitteilung | Unternehmens-IR |
| 10 | BOOK | Buch | ISBN-basiert |
| 11 | INTERVIEW | Interview/Aussage | Direktes Zitat |
| 12 | DATASET | Datensatz | Kaggle |
| 13 | SOCIAL | Soziale Medien | Twitter |
| 14 | LEGAL | Recht/Rechtsprechung | Gerichtsurteil |
| 15 | ARCHIVE | Archiv | archive.org |
| 16 | MULTIMEDIA | Video/Audio | YouTube |
| 17 | DATABASE | Datenbank | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | Enzyklopaedie | Britannica |
| 19 | MANUAL | Handbuch/Leitfaden | Technische Dokumentation |
| 20 | STANDARD | Normdokument | ISO, RFC |

### Abgeleitet/Inferenz — Code 21~30

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 21 | MODEL | KI-Modell-Erzeugung | GPT, Claude |
| 22 | INFERENCE | Logische Inferenz | Regelbasiert |
| 23 | AGGREGATION | Aggregation/Synthese | Multi-Quellen-Synthese |
| 24 | CALCULATION | Berechnungsergebnis | Formelanwendung |
| 25 | TRANSLATION | Uebersetzung | Original→Uebersetzung |
| 26 | EXTRACTION | Extraktion | NER, RE |
| 27 | CORRECTION | Korrektur | Fehlerberichtigung |
| 28 | HEARSAY | Hoerensagen/Geruecht | Unbestaetigt |
| 29 | ESTIMATION | Schaetzung | Naehrungswert |
| 30 | PREDICTION | Vorhersage | Zukunftsprognose |

### Weltanschauung/Glaube — Code 31~45

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 31 | RELIGION | Religioese Weltanschauung | Protestantismus, Buddhismus |
| 32 | PHILOSOPHY | Philosophische Perspektive | Existenzialismus |
| 33 | SCIENCE | Wissenschaftlicher Konsens | Moderne Physik |
| 34 | POLITICS | Politische Perspektive | Konservativ, Progressiv |
| 35 | CULTURE | Kulturelle Perspektive | Osten, Westen |
| 36 | MYTHOLOGY | Mythologisches System | Griechische Mythologie |
| 37 | FOLKLORE | Volksmaerchen/Ueberlieferung | Lokale Sagen |
| 38 | IDEOLOGY | Ideologisches System | Kapitalismus |
| 39 | THEORY | Theorie | Relativitaetstheorie |
| 40 | HYPOTHESIS | Hypothese | Vor Verifizierung |
| 41 | TRADITION | Tradition/Brauch | Konfuzianische Tradition |
| 42 | CONSENSUS | Konsens/Anerkannte These | Etablierte These |
| 43 | MAINSTREAM | Vorherrschende Meinung | Mehrheitsmeinung |
| 44 | ALTERNATIVE | Alternative Ansicht | Minderheitsmeinung |
| 45 | FRINGE | Randstaendig/Heterodox | Pseudowissenschaft |

### Fiktion/Kreation — Code 46~55

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 46 | NOVEL | Romanuniversum | Der Herr der Ringe |
| 47 | FILM | Filmuniversum | MCU |
| 48 | GAME | Spieluniversum | Zelda |
| 49 | COMICS | Comicuniversum | DC-Universum |
| 50 | ANIMATION | Animationsuniversum | Studio Ghibli |
| 51 | DRAMA | Serienuniversum | Game of Thrones |
| 52 | THEATER | Theateruniversum | Hamlet |
| 53 | FANFIC | Fankreation | Fanfiction |
| 54 | LEGEND | Legende | Koenig Artus |
| 55 | FAIRYTALE | Maerchen | Aschenputtel |

### Perspektive/Erzaehler — Code 56~62

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 56 | NARRATOR | Erzaehlerperspektive | Allwissender Erzaehler |
| 57 | PROTAGONIST | Protagonistenperspektive | Heldensicht |
| 58 | ANTAGONIST | Antagonistenperspektive | Schurkensicht |
| 59 | AUTHOR | Autorenabsicht | Autorenkommentar |
| 60 | EXPERT | Expertenmeinung | Gelehrtenmeinung |
| 61 | LAYMAN | Laienwahrnehmung | Oeffentliche Wahrnehmung |
| 62 | SATIRICAL | Satire/Ironie | Ironischer Ausdruck |

Code 0 ist UNSPECIFIED (unbestimmt), Code 63 ist EXTENDED (erweitert, reserviert).

## Metadatenerweiterung

Zusaetzliche Informationen ueber den Context (Quelle, Vertrauenswuerdigkeit, Universumname) werden ueber [Triple Edge](../triple-edge/) ausgedrueckt.

```
(Context TID, P:source_entity, Reuters_Entity)  - Quellorganisation
(Context TID, P:confidence, 0.95)               - Vertrauenswuerdigkeit
(Context TID, P:universe_name, "Harry Potter")  - Universumname
(Context TID, P:perspective_holder, Schurke_Entity) - Perspektiventraeger
```

## Beispiele

### Quelle: "Reuters-Bericht"

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple hat Tesla uebernommen"

Zusaetzliche Triple:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### Fiktion: "Harry-Potter-Universum"

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "Hogwarts ist_eine Schule"

Zusaetzliche Triple:
  (0x0302, P:universe_name, "Harry Potter")
  (0x0302, P:author, J.K. Rowling)
```

### KI-Inferenz: "Claude hat geschlossen"

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X verursacht Y"

Zusaetzliche Triple:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## Designbegruendung

- **Context Edge als separater Typ**: Die Weltanschauung ist eine Meta-Ebene, die sich von Triple/Clause unterscheidet. Entspricht dem G (Graph) des RDF Quad.
- **6 Bit fuer Context Type**: Sofortige Klassifizierung ohne zusaetzliche Triple. 62 Typen decken die meisten Faelle ab.
- **Leichtgewichtige 3-Woerter-Struktur**: Context-Verbindungen treten massenhaft auf, daher sichert die minimale Groesse die Speichereffizienz.
