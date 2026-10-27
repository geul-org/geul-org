---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER ist ein Value, der eine vorzeichenlose Ganzzahl als Big-Endian-Magnitude mit minimaler WORD-Zahl enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER ist ein Value, der einen vorzeichenlosen ganzzahligen Wert darstellt. Direkter Value-Code `0x02`, Familie NUMERIC. Der gesamte Payload wird als vorzeichenlose Magnitude beliebiger Genauigkeit in Big-Endian-WORD-Reihenfolge gelesen. Der Payload hat mindestens 1 WORD, und nur die kanonische Darstellung mit minimaler WORD-Zahl ist zulässig.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Payload WORD 1st  (oberes WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (unteres WORD)   Unsigned Magnitude Nth
```

## Interpretation

- Das erste Payload-WORD ist die höchste Stelle, das letzte die niedrigste.
- Hat der Payload N WORD, wird er als eine vorzeichenlose Magnitude von `16N` Bit gelesen.
- Diese Breite ist keine deklarierte Speicherbreite, und es gibt keinen Bit-Width-Descriptor.

## Kanonische Darstellung

- Die 0 ist der Payload 1 WORD `0000`.
- Ist bei einem Payload ab 2 WORD das erste WORD `0000`, ist das nicht kanonisch, da der Wert auch ohne es gleich bliebe.
- Ein Decoder muss Darstellungen mit unnötigen führenden Null-WORD ablehnen.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](/de/grammar/record/)).
- Deklarierte Breiten wie UINT8, UINT16 und UINT32 werden nicht bewahrt, nur der Zahlenwert.

## Beispiel

| Wert | Payload-WORD | Beurteilung |
|---:|---|---|
| 0 | `0000` | kanonisch |
| 1 | `0001` | kanonisch |
| 65535 | `ffff` | kanonisch |
| 65536 | `0001 0000` | kanonisch |
| 1 | `0000 0001` | nicht kanonisch: unnötiges führendes `0000` |
| Payload 7 WORD | 7 WORD nach TAG `0b82` (direkte Länge `LLLL=0111`, insgesamt 8 WORD) | kanonisch |
| Payload 7 WORD | 7 WORD nach einem Erweiterungs-TAG für die Länge und dem Erweiterungswert `0009` | nicht kanonisch: Bis 14 WORD wird die direkte Länge verwendet |

## Formatstatus

- Diese Darstellung, die eine vorzeichenlose Magnitude beliebiger Genauigkeit auf eine Folge minimaler 16-Bit-WORD normalisiert und mit dem GEUL-TAG verbindet, ist ein GEUL-eigenes Skalarprofil.
- Beim Austausch mit externen Typen fester Breite wie UINT8/16/32/64 sind eine Bereichsprüfung und eine ausdrückliche Breitenkonvertierung nötig.
