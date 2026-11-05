---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 ist ein Value, der eine rationale Zahl als gekürzten Bruch aus einem Big-Endian-int64-numerator und einem int64-denominator darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 ist ein Value, der eine rationale Zahl als gekürzten Bruch aus einem Big-Endian-int64-numerator und einem int64-denominator darstellt. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000702`, Familie NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  insgesamt 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Jeder int64 ist eine ab dem höchstwertigen WORD aneinandergereihte Zweierkomplement-Ganzzahl fester Breite, und der Wert ist `numerator / denominator`.
- Es gibt kein ABI-Padding.
- Der Payload umfasst genau 8 WORD, und der denominator muss positiv sein.
- Zulässig ist nur die gekürzte Form mit `gcd(|numerator|, denominator) = 1`. Null wird ausschließlich als `0/1` geschrieben.

## Formatstatus {#형식-지위}

- Die beiden int64, der positive denominator, der größte gemeinsame Teiler 1 und die Kanonisierung `0/1` übernehmen keinen externen Wire-Standard, sondern sind ein GEUL-eigenes Format.
- Diese Seite definiert die Darstellung vollständig, einschließlich der Zweierkomplement-Interpretation jedes int64, der Komponentenreihenfolge und des Big-Endian-WORD-Framings.

## Länge {#길이}

- Die Gesamtlänge ist genau 13 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 8 WORD Payload; verwendet wird die direkte Länge `LLLL=1100`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 8 WORD, wird er abgelehnt.

## Beispiel {#예시}

- numerator `1`, denominator `2` ergeben das gültige `1/2`. `2/4`, `0/2` und denominator `-2` sind invalid.
