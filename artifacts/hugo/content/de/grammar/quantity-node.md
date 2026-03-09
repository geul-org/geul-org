---
title: "Quantity Node"
weight: 70
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "quantity", "SI", "currency"]
summary: "Node variabler Laenge von 4 bis 7 Woertern zur Darstellung physikalischer Groessen, Zahlenwerte, Waehrungen und Literale. 6 Bit Unit kodieren SI-Basis-/Ableitungseinheiten, Waehrungen und Sonderliterale, waehrend 4 Bit Scale die SI-Praefixe ausdruecken."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Quantity Node ist ein Node-Typ variabler Laenge zur Darstellung von **physikalischen Groessen, Zahlenwerten, Waehrungen und Literalen**.

| Eigenschaft | Beschreibung |
|-------------|--------------|
| **Variable Laenge** | 4~N Woerter (je nach Wertgroesse) |
| **Explizite Einheit** | SI Basis/Abgeleitet + Nicht-SI (Waehrungen, Zeit usw.) |
| **Skalenunterstuetzung** | Praefixe als Zehnerpotenzen |
| **Sonderliterale** | Zeitstempel, Zeichenketten (UTF-16), Farben (RGBA) |
| **TID am Ende** | Node-Eigenschaft (Konsistenz mit [Entity Node](../entity-node/)) |

**Verwendung:** Object des [Triple Edge](../triple-edge/), Teilnehmer des Verb Edge, Teilnehmer des [Event6 Edge](../event6-edge/), Name/Label von Entitaeten, Zeitausdruecke usw.

## Paketstruktur

```
1st WORD (16 Bit)
┌────────────────────┬────────────────────┐
│      Prefix        │       Unit         │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 Bit)
┌──────┬──────┬──────┬────────────────────┐
│ Sign │ Size │ Type │      Scale         │
│ 1bit │ 2bit │ 1bit │       4bit         │
├──────┴──────┴──────┴────────────────────┤
│              Reserved (8bit)            │
└─────────────────────────────────────────┘

3rd+ WORD: Value (variabel, 1/2/4 Woerter je nach Size)

Last WORD (16 Bit)
┌─────────────────────────────────────────┐
│                  TID                    │
│                 16bit                   │
└─────────────────────────────────────────┘
```

| Feld | Bits | Groesse | Beschreibung |
|------|------|---------|--------------|
| Prefix | 1-10 | 10 | `0001 000 010` (Quantity Node) |
| Unit | 11-16 | 6 | 64 Einheitencodes |
| Sign | 17 | 1 | 0=positiv, 1=negativ |
| Size | 18-19 | 2 | Anzahl der Wert-Woerter |
| Type | 20 | 1 | 0=Ganzzahl, 1=Gleitkomma |
| Scale | 21-24 | 4 | Zehnerpotenz (Offset 8) |
| Reserved | 25-32 | 8 | Reserviert (Waehrungscode bei Waehrung) |

### Paketgroesse nach Size

| Size | Wert-Woerter | Gesamtwoerter |
|------|--------------|---------------|
| 00 | 1 (16 Bit) | 4 |
| 01 | 2 (32 Bit) | 5 |
| 10 | 4 (64 Bit) | 7 |

## Unit-Codes (6 Bit = 64)

### SI-Basiseinheiten (0x00~0x06)

| Code | Einheit | Symbol | Groesse |
|------|---------|--------|---------|
| 0x00 | meter | m | Laenge |
| 0x01 | kilogram | kg | Masse |
| 0x02 | second | s | Zeit |
| 0x03 | ampere | A | Stromstaerke |
| 0x04 | kelvin | K | Temperatur |
| 0x05 | mole | mol | Stoffmenge |
| 0x06 | candela | cd | Lichtstaerke |

### Abgeleitete SI-Einheiten (0x07~0x1C)

| Code | Einheit | Symbol | Groesse |
|------|---------|--------|---------|
| 0x07 | hertz | Hz | Frequenz |
| 0x08 | newton | N | Kraft |
| 0x09 | pascal | Pa | Druck |
| 0x0A | joule | J | Energie |
| 0x0B | watt | W | Leistung |
| 0x0C | coulomb | C | Elektrische Ladung |
| 0x0D | volt | V | Spannung |
| 0x0E | farad | F | Elektrische Kapazitaet |
| 0x0F | ohm | Ω | Widerstand |
| 0x10 | siemens | S | Leitfaehigkeit |
| 0x11 | weber | Wb | Magnetischer Fluss |
| 0x12 | tesla | T | Magnetfeld |
| 0x13 | henry | H | Induktivitaet |
| 0x14 | celsius | °C | Temperatur |
| 0x15 | lumen | lm | Lichtstrom |
| 0x16 | lux | lx | Beleuchtungsstaerke |
| 0x17 | becquerel | Bq | Radioaktivitaet |
| 0x18 | gray | Gy | Absorbierte Dosis |
| 0x19 | sievert | Sv | Aequivalentdosis |
| 0x1A | katal | kat | Katalytische Aktivitaet |
| 0x1B | radian | rad | Ebener Winkel |
| 0x1C | steradian | sr | Raumwinkel |

### Nicht-SI-Einheiten (0x20~0x2F)

| Code | Einheit | Verwendung |
|------|---------|------------|
| 0x20 | CURRENCY | Waehrung (Waehrungscode-Erweiterung) |
| 0x21 | percent | % (Verhaeltnis) |
| 0x22 | degree | ° (Winkel) |
| 0x23~0x28 | minute~year | Zeiteinheiten |
| 0x29 | bit | Informationsmenge |
| 0x2A | byte | Informationsmenge |
| 0x2B~0x2F | COUNT~INDEX | Einheitenlose Werte |

### Sonderliterale (0x30~0x3F)

| Code | Typ | Payload | Verwendung |
|------|-----|---------|------------|
| 0x30 | TIMESTAMP_SEC | 2/4 Woerter | Unix-Zeitstempel (Sekunden) |
| 0x31 | TIMESTAMP_MS | 4 Woerter | Unix-Zeitstempel (Millisekunden) |
| 0x32 | UTF16 | 2+N Woerter | UTF-16-Zeichenkette |
| 0x33 | RGBA | 2 Woerter | Farbe (32 Bit) |

## Scale (4 Bit)

Zehnerpotenz. Offset 8 angewendet. **Berechnung:** `realer_Wert = Value x 10^(Scale - 8)`

| Code | Wert | Praefix | Code | Wert | Praefix |
|------|------|---------|------|------|---------|
| 0000 | 10⁻⁸ | - | 1000 | **10⁰ (Standard)** | - |
| 0010 | 10⁻⁶ | μ | 1001 | 10¹ | da |
| 0101 | 10⁻³ | m | 1011 | 10³ | k |
| 0110 | 10⁻² | c | 1110 | 10⁶ | M |

## Waehrungserweiterung (Unit = 0x20)

Bei Waehrung (CURRENCY) werden die 8 Reserved-Bits als Waehrungscode verwendet.

| Code | Waehrung | ISO | Code | Waehrung | ISO |
|------|----------|-----|------|----------|-----|
| 0x00 | US-Dollar | USD | 0x05 | Suedkoreanischer Won | KRW |
| 0x01 | Euro | EUR | 0x06 | Schweizer Franken | CHF |
| 0x02 | Japanischer Yen | JPY | 0x07 | Australischer Dollar | AUD |
| 0x03 | Britisches Pfund | GBP | 0x08 | Kanadischer Dollar | CAD |
| 0x04 | Chinesischer Yuan | CNY | 0x80 | Bitcoin | BTC |

## Beispiele

### "100kg" → 4 Woerter

```
1st: [Prefix] + [0x01(kg)]
2nd: +, 1 Wort, int, x1     → 0x0800
3rd: 0x0064 (100)
4th: TID
Interpretation: +100 x 10⁰ kg = 100kg
```

### "$2.500.000" → 4 Woerter (Skalennutzung)

```
1st: [Prefix] + [0x20(CURRENCY)]
2nd: +, 1 Wort, int, x10³, USD  → 0x0B00
3rd: 0x09C4 (2500)
4th: TID
Interpretation: +2500 x 10³ USD = $2.500.000
```
