---
title: "Clause Edge"
weight: 40
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "clause", "RST", "discourse"]
summary: "Fester 4-Woerter-Edge zur Darstellung logischer und diskursiver Beziehungen zwischen Praedikationen, Ereignissen und Relationen. 16 RST-basierte Beziehungstypen kodieren kausale, zeitliche, kontrastive und argumentative Beziehungen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Clause Edge ist ein Edge-Typ, der die **logischen und diskursiven Beziehungen** zwischen Praedikationen ([Verb Edge](../verb-edge/)), Ereignissen ([Event6 Edge](../event6-edge/)), Relationen ([Triple Edge](../triple-edge/)) oder anderen Clauses ausdrueckt.

Er basiert auf den Diskursrelationen der RST (Rhetorical Structure Theory).

## Paketstruktur (4 Woerter, 64 Bit)

```
1st WORD (16 Bit):
┌─────────────────────┬────────────┬────────┐
│      Prefix         │ Rel.-Typ   │ Reserv.│
│       10 Bit        │   4 Bit    │ 2 Bit  │
└─────────────────────┴────────────┴────────┘
 [1100 000 010]        [RRRR]       [xx]

2nd WORD: Edge TID (16 Bit)
3rd WORD: TID 1 (16 Bit) - erste Klausel
4th WORD: TID 2 (16 Bit) - zweite Klausel
```

| Feld | Bits | Beschreibung |
|------|------|--------------|
| Prefix | 10 | `1100 000 010` |
| Beziehungstyp | 4 | 16 RST-Beziehungen |
| Reserviert | 2 | Fuer zukuenftige Erweiterung |
| Edge TID | 16 | Eindeutiger Identifikator dieses Edge |
| TID 1 | 16 | Referenz zur ersten Klausel |
| TID 2 | 16 | Referenz zur zweiten Klausel |

## Beziehungstypen (4 Bit = 16)

### Kausale Beziehungen

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 0000 | CAUSE | Ursache→Wirkung | "Weil es regnete, blieb ich zu Hause" |
| 0001 | RESULT | Wirkung←Ursache | "Ich blieb zu Hause, denn es regnete" |
| 0010 | CONDITION | Bedingung→Folge | "Wenn es regnet, gehe ich nicht" |
| 0011 | PURPOSE | Zweck | "Man isst, um zu leben" |

### Zeitliche/Sequenzielle Beziehungen

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 0100 | SEQUENCE | Chronologisch | "Ich ass und schlief dann" |
| 0101 | PARALLEL | Gleichzeitig/Parallel | "Er sprach laechelnd" |

### Kontrast/Konzessive Beziehungen

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 0110 | CONTRAST | Kontrast | "A ist gross und B ist klein" |
| 0111 | CONCESSION | Konzession | "Obwohl es schwer war, tat er es" |

### Elaboration/Hintergrund

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 1000 | ELABORATION | Ausfuehrung | "Genauer gesagt..." |
| 1001 | BACKGROUND | Hintergrundinformation | "Zur Information: die damalige Lage war..." |

### Argumentative Beziehungen

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 1010 | EVIDENCE | Beweisfuehrung | "Weil... deswegen" |
| 1011 | EVALUATION | Bewertung | "Das ist gut/schlecht" |

### Sonstige Beziehungen

| Code | Typ | Beschreibung | Beispiel |
|------|-----|--------------|----------|
| 1100 | SOLUTIONHOOD | Problem→Loesung | "Das Problem ist X, die Loesung ist Y" |
| 1101 | ALTERNATIVE | Wahl/Alternative | "Gehen oder nicht gehen" |
| 1110 | MEANS | Mittel | "So hat er es erreicht" |
| 1111 | RESERVED | Reserviert | Fuer zukuenftige Erweiterung |

## TID-Reihenfolgeregel

Die Richtung wird durch die TID-Reihenfolge bestimmt.

| Beziehung | TID 1 | TID 2 |
|-----------|-------|-------|
| CAUSE | Ursache | Wirkung |
| RESULT | Wirkung | Ursache |
| CONDITION | Bedingung | Folge |
| PURPOSE | Handlung | Zweck |
| SEQUENCE | Vorhergehend | Nachfolgend |
| EVIDENCE | Beweis | Behauptung |
| ELABORATION | Kern | Ausfuehrung |

## Multinuclear vs Nucleus-Satellite

Gemaess RST-Unterscheidung.

### Nucleus-Satellite (asymmetrisch)

| Beziehung | TID 1 | TID 2 |
|-----------|-------|-------|
| CAUSE | Ursache (Satellite) | Wirkung (Nucleus) |
| CONDITION | Bedingung (Satellite) | Folge (Nucleus) |
| EVIDENCE | Beweis (Satellite) | Behauptung (Nucleus) |
| ELABORATION | Kern (Nucleus) | Ausfuehrung (Satellite) |

### Multinuclear (symmetrisch)

| Beziehung | TID 1 | TID 2 |
|-----------|-------|-------|
| SEQUENCE | Vorhergehend | Nachfolgend |
| PARALLEL | Erstes | Zweites |
| CONTRAST | Erstes | Zweites |
| ALTERNATIVE | Erstes | Zweites |

Bei symmetrischen Beziehungen zeigt die TID-Reihenfolge keine semantische Prioritaet an.

## Beispiele

### Einfache Kausalitaet: "Weil es regnete, blieb ich zu Hause"

```
Verb Edge E01: rain(Regen) | TID=0x0001
Verb Edge E02: stay(ich, Zuhause) | TID=0x0002

Clause Edge:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE + Reserviert
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - TID 1 (Ursache: E01)
  4th: [0x0002]                    - TID 2 (Wirkung: E02)
```

### Verschachtelte Clause: "Weil es regnete, blieb ich zu Hause, und deshalb habe ich gelernt"

```
Verb Edge E01: rain(Regen) | TID=0x0001
Verb Edge E02: stay(ich, Zuhause) | TID=0x0002
Verb Edge E03: study(ich) | TID=0x0003

Clause Edge C01:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - E01
  4th: [0x0002]                    - E02

Clause Edge C02:
  1st: [1100 000 010] [0001] [00]  - Prefix + RESULT
  2nd: [0x0101]                    - Edge TID
  3rd: [0x0100]                    - C01 (Referenz auf Clause-TID!)
  4th: [0x0003]                    - E03
```

## Designbegruendung

### Warum RST

- Ueber 30 Jahre akkumulierte Forschung
- Validierung an diversen Korpora
- Vorhandene Diskursanalyse-Werkzeuge
- Sprachunabhaengig

### Warum 4 Bit (16)

- Deckt ueber 12 wesentliche RST-Beziehungen ab
- Erweiterungsspielraum erhalten
- 3 Bit (8) waeren unzureichend

### Warum vereinfacht auf 4 Woerter

- Richtung: durch TID-Reihenfolge bestimmt (kein zusaetzliches Bit noetig)
- Sicherheit: als separate Metadaten behandelt
- 2 Bit reserviert: fuer zukuenftige Erweiterung
