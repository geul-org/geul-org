---
title: "IEEE-DECIMAL64-DPD"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-DPD ist ein Value mit festen 7 WORD, der die interchange-Bitfolge von IEEE 754 decimal64 DPD unverändert enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-DPD ist ein Value, der die IEEE-754-decimal64-DPD-Interchange-Kodierung darstellt. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, Formatnummer `0x2001`, Familie DECIMAL. Das DPD-Bitmuster wird unverändert bewahrt und von BID unterschieden.

## Layout

```
TAG WORD          0x0B7C  insgesamt 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
Formatnummer      1 WORD  0x2001
Payload           4 WORD (64 Bit)  IEEE decimal64 DPD Interchange
```

## Interpretation

- Die vier Payload-WORD werden ab dem oberen WORD aneinandergehängt und als IEEE-754-decimal64-DPD-Interchange-Bitfolge gelesen.
- Das Bitmuster wird bewahrt und nicht eigenmächtig als BID oder ein exaktes Dezimalformat neu interpretiert.
- Spezialwerte oder Payloads werden nicht eigenmächtig normalisiert.

## Gültigkeit und Länge

- Insgesamt sind es genau 7 WORD aus TAG 1 WORD, Issuer 1 WORD, Formatnummer 1 WORD und Payload 4 WORD, mit der direkten Länge `LLLL=0110`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.
- Die inhaltliche Gültigkeit der Bitfolge folgt den IEEE-DPD-Interchange-Regeln.

## Beispiel

| Struktur | Beurteilung |
|---|---|
| `0B7C 0040 2001` + 4 WORD DPD-Bitfolge | Längenstruktur kanonisch |
| `0B7C 0040 2001` + 2 WORD | invalid: Payload-Breite stimmt nicht |
| Dieselben 64 Bit mit Formatnummer `0x2004` | BID-Format und nicht dieser Typ |

## Normgrundlage

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): Es wird die Dezimal-Koeffizienten-Kodierung (DPD) des decimal64-Interchange-Formats angewandt. Es wird nicht numerisch in die von IEEE zugelassene BID-Alternative umgewandelt, sondern die gewählte 64-Bit-Kodierung bewahrt, und GEUL fügt nur den TAG und das WORD-Big-Endian-Framing hinzu.
