---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 ist ein ADHOC-Issuer-Format mit festen 11 WORD, das eine rationale Zahl als gekürzten Bruch aus int64-Zähler und positivem int64-Nenner enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 ist ein Value, der eine rationale Zahl als gekürzten Bruch aus Big-Endian-int64-numerator und int64-denominator darstellt. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0702`, Familie NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  insgesamt 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interpretation und Gültigkeit

- Jedes int64 ist eine Zweierkomplement-Ganzzahl fester Breite, bei der die WORD ab dem oberen WORD aneinandergehängt sind, und der Wert ist `numerator / denominator`.
- Es gibt kein ABI-Padding.
- Der Payload ist genau 8 WORD, und der denominator muss positiv sein.
- Zulässig ist nur die gekürzte Form mit `gcd(|numerator|, denominator) = 1`. Die 0 wird ausschließlich als `0/1` geschrieben.

## Formatstatus

- Zwei int64, positiver denominator, größter gemeinsamer Teiler 1 und die Kanonisierung `0/1` sind kein übernommener externer Wire-Standard, sondern ein GEUL-eigenes Format.
- Diese Seite definiert die Darstellung vollständig, einschließlich der Zweierkomplement-Interpretation jedes int64, der Reihenfolge der Komponenten und des Big-Endian-WORD-Framings.

## Länge

- Insgesamt sind es genau 11 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 8 WORD Payload, mit der direkten Länge `LLLL=1010`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 8 WORD, wird abgelehnt.

## Beispiel

- numerator `1`, denominator `2` ist das gültige `1/2`. `2/4`, `0/2` und denominator `-2` sind invalid.
