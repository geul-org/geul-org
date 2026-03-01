---
title: "Event6 Edge"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "Ereignis-Edge variabler Laenge, der die 5W1H (Who, What, Whom, When, Where, Why) auf einmal ausdrueckt. Die variable Struktur von 3 bis 8 Woertern wird durch eine Presence-Bitmaske realisiert."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge ist ein Ereignis-Edge-Typ, der die **5W1H** (Who, What, Whom, When, Where, Why) auf einmal ausdrueckt.

## 5W1H-Elemente

| Element | Englisch | Bit | Bedeutung | TID-Referenz |
|---------|----------|-----|-----------|--------------|
| Who | Agent | 0 | Handelnder | [Entity Node](../entity-node/) |
| What | Action | 1 | Handlung | [Verb Edge](../verb-edge/) |
| Whom | Patient | 2 | Objekt/Betroffener | [Entity Node](../entity-node/) |
| When | Time | 3 | Zeitpunkt | Quantity/Entity |
| Where | Location | 4 | Ort | [Entity Node](../entity-node/) |
| Why | Reason | 5 | Grund/Zweck | [Clause Edge](../clause-edge/)/Entity |

## Paketstruktur

```
1st WORD (16 Bit)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 Bit)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: Element-TIDs (in Presence-Reihenfolge)
```

### Presence-Bitmaske (6 Bit)

| Bit | Element | Wenn vorhanden |
|-----|---------|----------------|
| 0 | Who | Entsprechendes TID enthalten |
| 1 | What | Entsprechendes TID enthalten |
| 2 | Whom | Entsprechendes TID enthalten |
| 3 | When | Entsprechendes TID enthalten |
| 4 | Where | Entsprechendes TID enthalten |
| 5 | Why | Entsprechendes TID enthalten |

Gesamtwoerter = 2 (Header + Edge TID) + popcount(Presence). Bereich 3~8 Woerter (48~128 Bit).

## Strukturen nach Modus

### Minimalmodus (3 Woerter)

```
Beispiel: "Es hat geregnet" (nur What)

1st: [Prefix] + [000010]      - Nur What
2nd: [Edge TID]
3rd: [What TID]               - Verb Edge "rain"
```

### Kernmodus (5 Woerter)

Who + What + Whom. Die haeufigste Konfiguration.

```
Beispiel: "Hans hat Anna geschlagen"

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - Hans
4th: [What TID]               - Verb Edge "hit"
5th: [Whom TID]               - Anna
```

### Standardmodus (6 Woerter)

```
Beispiel: "Hans hat Anna gestern getroffen"

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - Hans
4th: [What TID]               - Verb Edge "meet"
5th: [Whom TID]               - Anna
6th: [When TID]               - Gestern
```

### Vollstaendiger Modus (8 Woerter)

```
Beispiel: "Aus Liebe gab Hans gestern in der Schule Anna ein Geschenk"

1st: [Prefix] + [111111]      - Alle Elemente
2nd: [Edge TID]
3rd: [Who TID]                - Hans
4th: [What TID]               - Verb Edge "give"
5th: [Whom TID]               - Anna
6th: [When TID]               - Gestern
7th: [Where TID]              - Schule
8th: [Why TID]                - Liebe (Grund)
```

## Element-Details

### What (Handlung)

What referenziert die TID eines [Verb Edge](../verb-edge/). Die Informationen zu Tempus, Aspekt und anderen Qualifikatoren sind in diesem Verb Edge enthalten.

### Why (Grund)

Einfache Gruende werden als Entity-TID ("Liebe") ausgedrueckt, komplexe Gruende als [Clause Edge](../clause-edge/)-TID ("weil es regnete").

## Vergleich Event6 vs Verb Edge

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **Fokus** | Praedikation/Aktion | Vollstaendiges Ereignis |
| **Teilnehmer** | Participant-Struktur | 5W1H-TIDs |
| **Raum-Zeit** | Separater Ausdruck | When/Where integriert |
| **Grund** | Separate Clause | Why integriert |
| **Woerter** | 2~5 | 3~8 |
| **Verwendung** | Praedikationsausdruck | Ereignisspeicherung |

**Auswahlhilfe:** Verb Edge fuer Praedikations-/Satzanalyse, Event6 Edge fuer Ereignis-/Datensatzspeicherung, [Triple Edge](../triple-edge/) fuer einfache Fakten.

## Beispiele

### "Apple hat Tesla uebernommen"

```
Who:  Apple (Q312)     → Entity TID 0x0001
What: acquire          → Verb Edge TID 0x0100
Whom: Tesla (Q478214)  → Entity TID 0x0002

Event6 Edge:
  1st: [1100 000 011] + [000111]  - Prefix + Who,What,Whom
  2nd: [TID: 0x0200]              - Edge TID
  3rd: [TID: 0x0001]              - Apple (Who)
  4th: [TID: 0x0100]              - acquire (What)
  5th: [TID: 0x0002]              - Tesla (Whom)

Gesamt: 5 Woerter
```

### "Yi Sun-sin fiel 1598 in der Schlacht von Noryang"

```
Who:   Yi Sun-sin        → Entity TID 0x0010
What:  die (fallen)      → Verb Edge TID 0x0101
When:  1598              → Entity TID 0x0011
Where: Schlacht Noryang   → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - Yi Sun-sin
  4th: [TID: 0x0101]              - die
  5th: [TID: 0x0011]              - 1598
  6th: [TID: 0x0012]              - Schlacht von Noryang

Gesamt: 6 Woerter
```

## Parsing

```python
def parse_event6(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000011, "Not Event6 Edge"

    presence = word1 & 0x3F
    edge_tid = int.from_bytes(data[2:4], 'big')

    elements = {}
    element_names = ['who', 'what', 'whom', 'when', 'where', 'why']
    offset = 4

    for i, name in enumerate(element_names):
        if presence & (1 << i):
            tid = int.from_bytes(data[offset:offset+2], 'big')
            elements[name] = tid
            offset += 2

    return {
        'presence': presence,
        'edge_tid': edge_tid,
        'elements': elements,
        'words': 2 + bin(presence).count('1')
    }
```
