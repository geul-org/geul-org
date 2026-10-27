---
title: "IEEE-DECIMAL32-DPD"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD ist ein Value mit festen 5 WORD, der die interchange-Bitfolge von IEEE 754 decimal32 DPD unverändert enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD ist ein Value, der die IEEE-754-decimal32-DPD-Interchange-Kodierung darstellt. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, Formatnummer `0x2000`, Familie DECIMAL. Das DPD-Bitmuster wird unverändert bewahrt und von BID unterschieden.

## Layout

```
TAG WORD          0x0A7C  insgesamt 5 WORD
Issuer            1 WORD  0x0040 (IEEE)
Formatnummer      1 WORD  0x2000
Payload           2 WORD (32 Bit)  IEEE decimal32 DPD Interchange
```

## Interpretation

- Die zwei Payload-WORD werden ab dem oberen WORD aneinandergehängt und als IEEE-754-decimal32-DPD-Interchange-Bitfolge gelesen.
- Das Bitmuster wird bewahrt und nicht eigenmächtig als BID oder SIGNED-DECIMAL neu interpretiert.
- Spezialwerte oder Payloads werden nicht eigenmächtig normalisiert.

## Gültigkeit und Länge

- Insgesamt sind es genau 5 WORD aus TAG 1 WORD, Issuer 1 WORD, Formatnummer 1 WORD und Payload 2 WORD, mit der direkten Länge `LLLL=0100`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 2 WORD, wird abgelehnt.
- Die inhaltliche Gültigkeit der Bitfolge folgt den IEEE-DPD-Interchange-Regeln.

## Beispiel

| Struktur | Beurteilung |
|---|---|
| `0A7C 0040 2000` + 2 WORD DPD-Bitfolge | Längenstruktur kanonisch |
| `0A7C 0040 2000` + 4 WORD | invalid: Payload-Breite stimmt nicht |
| Dieselben 32 Bit mit Formatnummer `0x2003` | BID-Format und nicht dieser Typ |

## Normgrundlage

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): Es wird die Dezimal-Koeffizienten-Kodierung (DPD) des decimal32-Interchange-Formats angewandt. Es wird nicht numerisch in die von IEEE zugelassene BID-Alternative umgewandelt, sondern die gewählte 32-Bit-Kodierung bewahrt, und GEUL fügt nur den TAG und das WORD-Big-Endian-Framing hinzu.
