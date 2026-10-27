---
title: "SIGNED-DECIMAL"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL ist ein Value, der eine exakte Dezimalzahl C×10^E aus einem vorzeichenbehafteten 32-Bit-Exponenten E und einem Zweierkomplement-Koeffizienten C mit minimaler WORD-Zahl enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-DECIMAL ist ein Value für eine exakte Dezimalzahl (exact decimal) mit vorzeichenbehaftetem coefficient. Direkter Value-Code `0x10`, Familie DECIMAL. Die ersten 2 WORD des Payloads sind der vorzeichenbehaftete 32-Bit-Dezimalexponent `E`, der Rest ist der Zweierkomplement-coefficient `C` mit minimaler WORD-Zahl, und der Wert ist `C×10^E`.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x10
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Payload WORD 1st–2nd (32 Bit)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (ab 1 WORD)    Signed Two's-complement Coefficient C
```

## Interpretation

- `E` ist eine vorzeichenbehaftete 32-Bit-Big-Endian-Zweierkomplement-Ganzzahl, ab dem oberen WORD aufgezeichnet.
- `C` ist eine Zweierkomplement-Ganzzahl beliebiger Genauigkeit, bei der alle übrigen WORD ab dem oberen WORD aneinandergehängt sind.
- `C` folgt derselben Regel der minimalen WORD-Zahl wie [SIGNED-INTEGER](/de/grammar/value/numeric/signed-integer/). Führende `0000`- oder `ffff`-WORD, die gelöscht werden könnten, sind verboten.

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
| Payload 7 WORD | direkte Länge `LLLL=0111`, insgesamt 8 WORD | kanonische Längenstruktur |

## Formatstatus

- Diese Anordnung, die einen vorzeichenbehafteten 32-Bit-Exponenten `E` und einen coefficient `C` mit minimaler WORD-Zahl verbindet, ist weder IEEE 754 decimal interchange noch Apache Parquet `DECIMAL`, sondern ein GEUL-eigenes Format.
- Parquet `DECIMAL` verwendet `unscaledValue × 10^(-scale)` und verpflichtende precision/scale-Metadaten, speichert den unscaled value des Byte-Array-Typs als Big-Endian-Zweierkomplement, und scale ist mindestens 0. Dieses Format trägt ein vorzeichenbehaftetes `E` im Text und hat keine precision-Metadaten, ist also nicht dasselbe Format.
- Für den Austausch mit IEEE 754 decimal oder Parquet `DECIMAL` ist eine ausdrückliche Konvertierung nötig, die Bereich, precision/scale, Quantum und die Behandlung von Spezialwerten festlegt.
- Vergleichsgrundlage: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Offene Fragen

- Es gibt mehrere Exponent/coefficient-Paare, die dieselbe Zahl darstellen, wie `10×10^-1` und `1×10^0`.
- Ob dieses Format das Quantum bewahrt, wie die Wertgleichheit beurteilt wird und wie der kanonische Exponent normalisiert wird, ist noch nicht festgelegt.
- Deshalb darf eine Implementierung eine Normalisierung von Exponent/coefficient jenseits der Regel der minimalen WORD-Zahl des coefficient nicht eigenmächtig erzwingen.
