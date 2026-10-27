---
title: "IEEE-DECIMAL128-DPD"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD ist ein Value mit festen 11 WORD, der die interchange-Bitfolge von IEEE 754 decimal128 DPD unverändert enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD ist ein Value, der die IEEE-754-decimal128-DPD-Interchange-Kodierung darstellt. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, Formatnummer `0x2002`, Familie DECIMAL. Das DPD-Bitmuster wird unverändert bewahrt und von BID unterschieden.

## Layout

```
TAG WORD          0x0D7C  insgesamt 11 WORD
Issuer            1 WORD  0x0040 (IEEE)
Formatnummer      1 WORD  0x2002
Payload           8 WORD (128 Bit)  IEEE decimal128 DPD Interchange
```

## Interpretation

- Die acht Payload-WORD werden ab dem oberen WORD aneinandergehängt und als IEEE-754-decimal128-DPD-Interchange-Bitfolge gelesen.
- Das Bitmuster wird bewahrt und nicht eigenmächtig als BID oder ein exaktes Dezimalformat neu interpretiert.
- Spezialwerte oder Payloads werden nicht eigenmächtig normalisiert.

## Gültigkeit und Länge

- Insgesamt sind es genau 11 WORD aus TAG 1 WORD, Issuer 1 WORD, Formatnummer 1 WORD und Payload 8 WORD, mit der direkten Länge `LLLL=1010`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 8 WORD, wird abgelehnt.
- Die inhaltliche Gültigkeit der Bitfolge folgt den IEEE-DPD-Interchange-Regeln.

## Beispiel

| Struktur | Beurteilung |
|---|---|
| `0D7C 0040 2002` + 8 WORD DPD-Bitfolge | kanonisch |
| Gesamtlänge ist nicht 11 WORD (`LLLL=1010`) | invalid: Stimmt nicht mit der festen Payload-Breite überein |

## Normgrundlage

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): Es wird die Dezimal-Koeffizienten-Kodierung (DPD) des decimal128-Interchange-Formats angewandt. Es wird nicht numerisch in die von IEEE zugelassene BID-Alternative umgewandelt, sondern die gewählte 128-Bit-Kodierung bewahrt, und GEUL fügt nur den TAG und das WORD-Big-Endian-Framing hinzu.
