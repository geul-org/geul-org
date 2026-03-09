---
title: "Quantity Node"
weight: 70
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "quantity", "SI", "currency"]
summary: "A variable-length 4-7 word Node for representing physical quantities, numbers, currencies, and literals. Encodes SI base/derived units, currencies, and special literals with 6-bit Unit codes and 4-bit Scale for SI prefixes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Quantity Node is a variable-length Node type for representing **physical quantities, numbers, currencies, and literals**.

| Property | Description |
|----------|-------------|
| **Variable length** | 4~N words (depending on value size) |
| **Explicit units** | SI base/derived + non-SI (currency, time, etc.) |
| **Scale support** | SI prefixes via powers of 10 |
| **Special literals** | Timestamp, string (UTF-16), color (RGBA) |
| **TID last** | Node characteristic (consistent with [Entity Node](../entity-node/)) |

**Usage:** Object of [Triple Edge](../triple-edge/), participant of Verb Edge, participant of [Event6 Edge](../event6-edge/), entity names/labels, time expressions, etc.

## Packet Structure

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │       Unit         │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌──────┬──────┬──────┬────────────────────┐
│ Sign │ Size │ Type │      Scale         │
│ 1bit │ 2bit │ 1bit │       4bit         │
├──────┴──────┴──────┴────────────────────┤
│              Reserved (8bit)            │
└─────────────────────────────────────────┘

3rd+ WORD: Value (variable, 1/2/4 words depending on Size)

Last WORD (16 bits)
┌─────────────────────────────────────────┐
│                  TID                    │
│                 16bit                   │
└─────────────────────────────────────────┘
```

| Field | Bits | Size | Description |
|-------|------|------|-------------|
| Prefix | 1-10 | 10 | `0001 000 010` (Quantity Node) |
| Unit | 11-16 | 6 | 64 unit codes |
| Sign | 17 | 1 | 0=positive, 1=negative |
| Size | 18-19 | 2 | Value word count |
| Type | 20 | 1 | 0=integer, 1=floating-point |
| Scale | 21-24 | 4 | Power of 10 (offset 8) |
| Reserved | 25-32 | 8 | Reserved (currency code when currency) |

### Packet Size by Size

| Size | Value words | Total words |
|------|-------------|-------------|
| 00 | 1 (16 bits) | 4 |
| 01 | 2 (32 bits) | 5 |
| 10 | 4 (64 bits) | 7 |

## Unit Codes (6 bits = 64)

### SI Base Units (0x00~0x06)

| Code | Unit | Symbol | Physical quantity |
|------|------|--------|-------------------|
| 0x00 | meter | m | Length |
| 0x01 | kilogram | kg | Mass |
| 0x02 | second | s | Time |
| 0x03 | ampere | A | Electric current |
| 0x04 | kelvin | K | Temperature |
| 0x05 | mole | mol | Amount of substance |
| 0x06 | candela | cd | Luminous intensity |

### SI Derived Units (0x07~0x1C)

| Code | Unit | Symbol | Physical quantity |
|------|------|--------|-------------------|
| 0x07 | hertz | Hz | Frequency |
| 0x08 | newton | N | Force |
| 0x09 | pascal | Pa | Pressure |
| 0x0A | joule | J | Energy |
| 0x0B | watt | W | Power |
| 0x0C | coulomb | C | Electric charge |
| 0x0D | volt | V | Voltage |
| 0x0E | farad | F | Capacitance |
| 0x0F | ohm | Ω | Resistance |
| 0x10 | siemens | S | Conductance |
| 0x11 | weber | Wb | Magnetic flux |
| 0x12 | tesla | T | Magnetic field |
| 0x13 | henry | H | Inductance |
| 0x14 | celsius | °C | Temperature |
| 0x15 | lumen | lm | Luminous flux |
| 0x16 | lux | lx | Illuminance |
| 0x17 | becquerel | Bq | Radioactivity |
| 0x18 | gray | Gy | Absorbed dose |
| 0x19 | sievert | Sv | Dose equivalent |
| 0x1A | katal | kat | Catalytic activity |
| 0x1B | radian | rad | Plane angle |
| 0x1C | steradian | sr | Solid angle |

### Non-SI Units (0x20~0x2F)

| Code | Unit | Usage |
|------|------|-------|
| 0x20 | CURRENCY | Currency (extended currency code) |
| 0x21 | percent | % (ratio) |
| 0x22 | degree | ° (angle) |
| 0x23~0x28 | minute~year | Time units |
| 0x29 | bit | Information |
| 0x2A | byte | Information |
| 0x2B~0x2F | COUNT~INDEX | Dimensionless numbers |

### Special Literals (0x30~0x3F)

| Code | Type | Payload | Usage |
|------|------|---------|-------|
| 0x30 | TIMESTAMP_SEC | 2/4 words | Unix timestamp (seconds) |
| 0x31 | TIMESTAMP_MS | 4 words | Unix timestamp (milliseconds) |
| 0x32 | UTF16 | 2+N words | UTF-16 string |
| 0x33 | RGBA | 2 words | Color (32 bits) |

## Scale (4 bits)

Power of 10. Offset 8 applied. **Calculation:** `actual_value = Value x 10^(Scale - 8)`

| Code | Value | Prefix | Code | Value | Prefix |
|------|-------|--------|------|-------|--------|
| 0000 | 10⁻⁸ | - | 1000 | **10⁰ (default)** | - |
| 0010 | 10⁻⁶ | μ | 1001 | 10¹ | da |
| 0101 | 10⁻³ | m | 1011 | 10³ | k |
| 0110 | 10⁻² | c | 1110 | 10⁶ | M |

## Currency Extension (Unit = 0x20)

When the unit is CURRENCY, the Reserved 8 bits are used as a currency code.

| Code | Currency | ISO | Code | Currency | ISO |
|------|----------|-----|------|----------|-----|
| 0x00 | US Dollar | USD | 0x05 | Korean Won | KRW |
| 0x01 | Euro | EUR | 0x06 | Swiss Franc | CHF |
| 0x02 | Japanese Yen | JPY | 0x07 | Australian Dollar | AUD |
| 0x03 | British Pound | GBP | 0x08 | Canadian Dollar | CAD |
| 0x04 | Chinese Yuan | CNY | 0x80 | Bitcoin | BTC |

## Examples

### "100kg" → 4 words

```
1st: [Prefix] + [0x01(kg)]
2nd: +, 1 word, int, ×1     → 0x0800
3rd: 0x0064 (100)
4th: TID
Interpretation: +100 × 10⁰ kg = 100kg
```

### "$2,500,000" → 4 words (using scale)

```
1st: [Prefix] + [0x20(CURRENCY)]
2nd: +, 1 word, int, ×10³, USD  → 0x0B00
3rd: 0x09C4 (2500)
4th: TID
Interpretation: +2500 × 10³ USD = $2,500,000
```
