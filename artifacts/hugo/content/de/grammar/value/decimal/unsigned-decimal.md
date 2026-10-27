---
title: "UNSIGNED-DECIMAL"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL ist ein Value, der eine exakte Dezimalzahl C×10^E aus einem vorzeichenbehafteten 32-Bit-Exponenten E und einem vorzeichenlosen Koeffizienten C mit minimaler WORD-Zahl enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-DECIMAL ist ein Value für eine exakte Dezimalzahl (exact decimal) mit vorzeichenlosem coefficient. Direkter Value-Code `0x11`, Familie DECIMAL. Die ersten 2 WORD des Payloads sind der vorzeichenbehaftete 32-Bit-Dezimalexponent `E`, der Rest ist der vorzeichenlose coefficient `C` mit minimaler WORD-Zahl, und der Wert ist `C×10^E`.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x11
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Payload WORD 1st–2nd (32 Bit)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (ab 1 WORD)    Unsigned Coefficient C
```

## Interpretation

- `E` ist eine vorzeichenbehaftete 32-Bit-Big-Endian-Zweierkomplement-Ganzzahl, ab dem oberen WORD aufgezeichnet.
- `C` ist eine vorzeichenlose Magnitude beliebiger Genauigkeit, bei der alle übrigen WORD ab dem oberen WORD gelesen werden.
- `C` folgt derselben Regel der minimalen WORD-Zahl wie [UNSIGNED-INTEGER](/de/grammar/value/numeric/unsigned-integer/). Die 0 ist `0000`, und ein erstes WORD `0000` ist ab 2 WORD verboten.

## Länge und Gültigkeit

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](/de/grammar/record/)).
- Der Payload besteht aus Exponent 2 WORD und coefficient mindestens 1 WORD, also mindestens 3 WORD.
- Die Kanonizität der Byte-Darstellung prüft nur die minimale WORD-Darstellung des coefficient.

## Beispiel

| Wertdarstellung | Payload (`E` + `C`) | Beurteilung |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | Byte-Darstellung kanonisch |
| `10×10^-1` | `ffff ffff 000a` | Byte-Darstellung kanonisch, das kanonische Verhältnis zur obigen Darstellung ist eine offene Frage |
| `1×10^0` | `0000 0000 0000 0001` | nicht kanonisch: führendes `0000` des coefficient unnötig |
| Negativer coefficient | nicht zutreffend | invalid |

## Formatstatus

- Diese Anordnung, die einen vorzeichenbehafteten 32-Bit-Exponenten `E` und einen vorzeichenlosen coefficient `C` mit minimaler WORD-Zahl verbindet, ist weder IEEE 754 decimal interchange noch Apache Parquet `DECIMAL`, sondern ein GEUL-eigenes Format.
- Parquet `DECIMAL` verwendet einen unscaled value mit Vorzeichen, `unscaledValue × 10^(-scale)` und verpflichtende precision/scale-Metadaten, und der Byte-Array-Typ ist ein Big-Endian-Zweierkomplement mit scale mindestens 0. Dieses Format ist wegen des vorzeichenlosen `C`, des vorzeichenbehafteten `E` und des Fehlens von precision-Metadaten nicht dasselbe Format.
- Für den Austausch mit IEEE 754 decimal oder Parquet `DECIMAL` ist eine ausdrückliche Konvertierung nötig, die Vorzeichen, Bereich, precision/scale, Quantum und die Behandlung von Spezialwerten festlegt.
- Vergleichsgrundlage: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Offene Fragen

- Es gibt mehrere Exponent/coefficient-Paare, die dieselbe Zahl darstellen, wie `10×10^-1` und `1×10^0`.
- Ob dieses Format das Quantum bewahrt, wie die Wertgleichheit beurteilt wird und wie der kanonische Exponent normalisiert wird, ist noch nicht festgelegt.
- Deshalb darf eine Implementierung eine Normalisierung von Exponent/coefficient jenseits der Regel der minimalen WORD-Zahl des coefficient nicht eigenmächtig erzwingen.
