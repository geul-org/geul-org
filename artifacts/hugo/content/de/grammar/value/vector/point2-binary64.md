---
title: "POINT2-BINARY64"
weight: 1011
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 ist ein Value für einen zweidimensionalen Punkt aus zwei IEEE-754-binary64-Komponenten in der Reihenfolge (x, y) (ADHOC-Issuer-Format 0x050A)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 ist ein zweidimensionaler Punkt aus zwei IEEE-754-binary64-Komponenten in der Reihenfolge `(x, y)`.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x050A`. Familie NUMERIC.

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  insgesamt 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## Interpretationsregeln

- Jede Komponente wird ab dem oberen WORD gelesen, und das Bitmuster von NaN-Payload und signed zero bleibt erhalten.
- CRS, Bedeutung und Reihenfolge der Achsen sowie Einheit sind äußerer Kontext. Es gibt kein ABI-Padding.

## Gültigkeit

- Der Payload ist genau 8 WORD, und jeder Abschnitt von 4 WORD sind binary64-Interchange-Bits.

## Normgrundlage und Formatstatus

- Die Koordinatenreihenfolge `x, y` des Punktes orientiert sich an der Point/WKB-Achsenreihenfolge des OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), und jede Komponente folgt [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Dieser Payload ist ein kompaktes GEUL-Profil, das weder einen WKB-type/byte-order-Header noch einen GeoPackage-Header enthält, und kein OGC-WKB-Wire-Format. CRS, Bedeutung der Achsen und Einheit sind äußerer Kontext.

## Länge

- Insgesamt sind es genau 11 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 8 WORD Payload, mit der direkten Länge `LLLL=1010`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 8 WORD, wird abgelehnt.

## Beispiel

- Der Payload `3ff0 0000 0000 0000 4000 0000 0000 0000` ist `(1.0, 2.0)`.
