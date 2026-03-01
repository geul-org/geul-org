---
title: "Triple Edge"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "Edge-Typ zur Darstellung von Beziehungen und Eigenschaften in der Form (Subject, Property, Object). Duale Struktur mit 4-Woerter-Basismodus und 5-Woerter-Erweiterungsmodus, optimiert fuer die Top 63 hochfrequenten Eigenschaften."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge ist ein Edge-Typ, der **Beziehungen und Eigenschaften** in der Form `(Subject, Property, Object)` ausdrueckt.

## Dualer Modus

- **Basismodus (4 Woerter):** PropCode 0~62 (Top 63 Eigenschaften)
- **Erweiterungsmodus (5 Woerter):** Wenn PropCode=63, wird die gesamte P-ID abgedeckt (16 Bit semantisch ausgerichtet)

## Basismodus (4 Woerter = 64 Bit)

```
1st WORD (16 Bit)
┌────────────────────┬────────────────────┐
│      Prefix        │     PropCode       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD: Edge TID (16 Bit)
3rd WORD: Subject TID (16 Bit)
4th WORD: Object TID (16 Bit)
```

| Feld | Bits | Beschreibung |
|------|------|--------------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: Top 63 Eigenschaften, 63: Erweiterungsmodus |
| Edge TID | 16 | TID dieses Edge |
| Subject TID | 16 | TID des Subjekt-Entity/Node |
| Object TID | 16 | TID des Objekt-Entity/Node/Quantity |

## Erweiterungsmodus (5 Woerter = 80 Bit)

Wenn PropCode 63 ist, wird im 3. Wort eine 16-Bit-P-ID eingefuegt.

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16 Bit)
3rd WORD: P-ID semantisch ausgerichtet (16 Bit)
4th WORD: Subject TID (16 Bit)
5th WORD: Object TID (16 Bit)
```

## Top 63 Eigenschaften (PropCode 0~62)

Eigenschaften ausgewaehlt auf Basis der Nutzungshaeufigkeit in Wikidata.

### Klassifikation/Typ (Code 0~7)

| Code | P-ID | Eigenschaftsname | Beschreibung |
|------|------|------------------|--------------|
| 0 | P31 | instance of | Instanz von ~ |
| 1 | P279 | subclass of | Unterklasse von ~ |
| 2 | P361 | part of | Teil von ~ |
| 3 | P527 | has part | Enthaelt ~ |
| 4 | P1552 | has quality | Eigenschaft/Merkmal |
| 5 | P460 | same as | Identisch |
| 6 | P1889 | different from | Verschieden |
| 7 | P156 | followed by | Gefolgt von |

### Raum/Lage (Code 8~15)

| Code | P-ID | Eigenschaftsname | Beschreibung |
|------|------|------------------|--------------|
| 8 | P17 | country | Land |
| 9 | P131 | located in | Lage (Verwaltungseinheit) |
| 10 | P276 | location | Lage (Ort) |
| 11 | P625 | coordinate | Koordinaten |
| 12 | P30 | continent | Kontinent |
| 13 | P36 | capital | Hauptstadt |
| 14 | P150 | contains | Enthaelt (Region) |
| 15 | P206 | located next to | Angrenzendes Gewaesser |

### Zeit (Code 16~23)

| Code | P-ID | Eigenschaftsname | Beschreibung |
|------|------|------------------|--------------|
| 16 | P569 | date of birth | Geburtsdatum |
| 17 | P570 | date of death | Sterbedatum |
| 18 | P571 | inception | Gruendungsdatum |
| 19 | P576 | dissolved | Aufloesungsdatum |
| 20 | P577 | publication date | Veroeffentlichungsdatum |
| 21 | P580 | start time | Startzeit |
| 22 | P582 | end time | Endzeit |
| 23 | P585 | point in time | Zeitpunkt |

### Persoenliche Grunddaten (Code 24~31)

| Code | P-ID | Eigenschaftsname | Beschreibung |
|------|------|------------------|--------------|
| 24 | P19 | place of birth | Geburtsort |
| 25 | P20 | place of death | Sterbeort |
| 26 | P21 | sex or gender | Geschlecht |
| 27 | P27 | citizenship | Staatsangehoerigkeit |
| 28 | P735 | given name | Vorname |
| 29 | P734 | family name | Nachname |
| 30 | P1559 | name in native language | Name in Muttersprache |
| 31 | P742 | pseudonym | Pseudonym |

### Beziehungen/Zugehoerigkeiten (Code 32~39)

| Code | P-ID | Eigenschaftsname | Beschreibung |
|------|------|------------------|--------------|
| 32 | P22 | father | Vater |
| 33 | P25 | mother | Mutter |
| 34 | P26 | spouse | Ehepartner |
| 35 | P40 | child | Kind |
| 36 | P3373 | sibling | Geschwister |
| 37 | P463 | member of | Mitglied von |
| 38 | P108 | employer | Arbeitgeber |
| 39 | P1027 | conferred by | Verliehen von |

### Beruf/Taetigkeit (Code 40~47)

| Code | P-ID | Eigenschaftsname | Beschreibung |
|------|------|------------------|--------------|
| 40 | P106 | occupation | Beruf |
| 41 | P39 | position held | Bekleidete Position |
| 42 | P69 | educated at | Ausbildung |
| 43 | P101 | field of work | Fachgebiet |
| 44 | P1344 | participant in | Teilnahme (Ereignis) |
| 45 | P166 | award received | Auszeichnung |
| 46 | P800 | notable work | Bekanntes Werk |
| 47 | P1412 | languages spoken | Gesprochene Sprachen |

### Medien/Identifikation (Code 48~55)

| Code | P-ID | Eigenschaftsname | Beschreibung |
|------|------|------------------|--------------|
| 48 | P18 | image | Bild |
| 49 | P154 | logo | Logo |
| 50 | P41 | flag image | Flagge |
| 51 | P373 | Commons category | Wikimedia |
| 52 | P856 | official website | Offizielle Webseite |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### Werke/Kreation (Code 56~62)

| Code | P-ID | Eigenschaftsname | Beschreibung |
|------|------|------------------|--------------|
| 56 | P50 | author | Autor |
| 57 | P57 | director | Regisseur |
| 58 | P86 | composer | Komponist |
| 59 | P175 | performer | Interpret |
| 60 | P136 | genre | Genre |
| 61 | P364 | original language | Originalsprache |
| 62 | P123 | publisher | Verlag |

Code 63 ist als **Erweiterungsmodus-Indikator** reserviert.

## PropCode-Zusammenfassung

```
┌─────────────────────────────────────────────┐
│  0~7:   Klassifikation/Typ (P31, P279, ...) │
│  8~15:  Raum/Lage (P17, P131, ...)          │
│  16~23: Zeit (P569, P570, ...)              │
│  24~31: Pers. Grunddaten (P19, P20, ...)    │
│  32~39: Bezieh./Zugehoerigk. (P22, P25, ...)│
│  40~47: Beruf/Taetigkeit (P106, P39, ...)   │
│  48~55: Medien/Identifik. (P18, P856, ...)  │
│  56~62: Werke/Kreation (P50, P57, ...)      │
├─────────────────────────────────────────────┤
│  63: Erweiterungsmodus-Indikator            │
└─────────────────────────────────────────────┘
```

## Beispiele

### Basismodus: "Apple ist ein Unternehmen"

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - Unternehmen (Object)

Gesamt: 4 Woerter
```

### Erweiterungsmodus: "Die Hoehe des Eiffelturms betraegt 330m"

```
P2048 (height) → Ausserhalb Top 63 → Erweiterungsmodus

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - P2048 semantisch ausgerichtet
  4th: [TID: 0x0030]              - Eiffelturm (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

Gesamt: 5 Woerter
```

## Parsing

```python
def parse_triple_edge(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000001, "Not Triple Edge"

    prop_code = word1 & 0x3F

    if prop_code < 63:
        # Basismodus (4 Woerter)
        return {
            'mode': 'basic',
            'prop_code': prop_code,
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[4:6], 'big'),
            'object_tid': int.from_bytes(data[6:8], 'big'),
            'words': 4
        }
    else:
        # Erweiterungsmodus (5 Woerter)
        return {
            'mode': 'extended',
            'p_id': int.from_bytes(data[4:6], 'big'),
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[6:8], 'big'),
            'object_tid': int.from_bytes(data[8:10], 'big'),
            'words': 5
        }
```
