---
title: "POINT3-BINARY64"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 ist ein Value für einen dreidimensionalen Punkt aus drei IEEE-754-binary64-Komponenten in der Reihenfolge (x, y, z) (ADHOC-Issuer-Format 0x050B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 ist ein dreidimensionaler Punkt aus drei IEEE-754-binary64-Komponenten in der Reihenfolge `(x, y, z)`.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x050B`. Familie NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0010 (insgesamt 16 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Interpretationsregeln

- Jede Komponente wird ab dem oberen WORD gelesen, und das Bitmuster von NaN-Payload und signed zero bleibt erhalten.
- CRS, Bedeutung und Reihenfolge der Achsen sowie Einheit sind äußerer Kontext. Es gibt kein ABI-Padding.

## Gültigkeit

- Der Payload ist genau 12 WORD, und jeder Abschnitt von 4 WORD sind binary64-Interchange-Bits.

## Normgrundlage und Formatstatus

- Die Koordinatenreihenfolge `x, y, z` des Punktes orientiert sich an der Point/WKB-Achsenreihenfolge des OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), und jede Komponente folgt [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Dieser Payload ist ein kompaktes GEUL-Profil, das weder einen WKB-type/byte-order-Header noch einen GeoPackage-Header enthält, und kein OGC-WKB-Wire-Format. CRS, Bedeutung der Achsen und Einheit sind äußerer Kontext.

## Länge

- Insgesamt sind es genau 16 WORD aus 1 WORD TAG, 1 WORD Length-Erweiterungs-TAG, 1 WORD Issuer, 1 WORD Formatnummer und 12 WORD Payload, mit `LLLL=1110`. Es gibt weder Descriptor noch Padding.
- Ist der Payload nicht genau 12 WORD, wird abgelehnt.

## Beispiel

- Sind die drei binary64 des Payloads `1.0, 2.0, 3.0`, ist es der Punkt `(1.0, 2.0, 3.0)`.
