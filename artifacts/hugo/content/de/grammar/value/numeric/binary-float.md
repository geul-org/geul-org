---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT ist ein Value, der die interchange-Bitfolge von IEEE 754 binary16/32/64/128 unverändert enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT ist ein Value, der einen IEEE-754-Binary-Interchange-Skalar darstellt. Direkter Value-Code `0x03`, Familie NUMERIC. Bei einem Payload von 1/2/4/8 WORD ist es binary16/32/64/128. Die interchange-Bitfolge wird unverändert bewahrt, andere Payload-Größen sind nicht zulässig.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Payload WORD 1st  (oberes WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (unteres WORD)   IEEE Binary Interchange Nth
```

## Interpretation

- Die Payload-WORD werden in Big-Endian-Reihenfolge aneinandergehängt und als IEEE-754-Binary-Interchange-Bitfolge der entsprechenden Breite gelesen.
- Interchange-Bitmuster einschließlich NaN-Payload und signed zero werden bewahrt.
- Ein Decoder darf NaN nicht durch ein beliebiges kanonisches NaN ersetzen und das Vorzeichen von signed zero nicht löschen.
- Rundungsverfahren und Arithmetik legt dieses Serialisierungsformat nicht fest.

## Länge

Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden) und Payload ([Record und TAG WORD](/de/grammar/record/)).

| Format | Payload | Length-Code | Length-Erweiterungs-TAG | Gesamte Length |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | keiner | 2 WORD |
| binary32 | 2 WORD | `0010` | keiner | 3 WORD |
| binary64 | 4 WORD | `0100` | keiner | 5 WORD |
| binary128 | 8 WORD | `1000` | keiner | 9 WORD |

Auch binary128 liegt im direkten Bereich von 1~14 WORD, daher wird kein Length-Erweiterungs-TAG verwendet.

## Gültigkeit

- Der Payload ist genau einer von 1, 2, 4 oder 8 WORD.
- Jede Payload-Größe muss genau zur Length-Darstellung der obigen Tabelle passen.
- Eine Neukodierung mit anderer Breite oder Padding-WORD vor oder nach dem Payload sind nicht zulässig.

## Beispiel

| Format | TAG | Length-Erweiterungs-TAG | Payload-Beispiel | Beurteilung |
|---|---|---|---|---|
| binary16 | `0883` | keiner | `0000` | kanonisch |
| binary32 | `0903` | keiner | `0000 0000` | kanonisch |
| binary64 | `0A03` | keiner | `0000 0000 0000 0000` | kanonisch |
| binary128 | `0C03` | keiner | Bitfolge aus 8 WORD | kanonisch |
| beliebig | Weicht von der durch die Length angegebenen Größe ab | beliebig | beliebig | invalid |

## Normgrundlage

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): Es wird die Interchange-Kodierung von binary16, binary32, binary64 und binary128 angewandt. GEUL fügt dieser Bitfolge nur den TAG und das 16-Bit-WORD-Big-Endian-Framing hinzu.
