---
title: "POINT2-BINARY64"
weight: 1017
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 ist ein zweidimensionaler Punkt aus zwei IEEE-754-binary64-Komponenten in der Reihenfolge (x, y)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 ist ein zweidimensionaler Punkt aus zwei IEEE-754-binary64-Komponenten in der Reihenfolge `(x, y)`.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x0000050A`. Familie NUMERIC.

```
TAG WORD          0x09DC (0000 1001 1101 1100)  insgesamt 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x0000050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## Interpretationsregeln {#해석-규칙}

- Jede Komponente wird ab dem höchstwertigen WORD gelesen; NaN-Payload und das Bitmuster von signed zero bleiben erhalten.
- CRS, Bedeutung und Reihenfolge der Achsen sowie die Einheit sind externer Kontext. Es gibt kein ABI-Padding.

## Gültigkeit {#유효성}

- Der Payload umfasst genau 8 WORD, und jeder 4-WORD-Abschnitt besteht aus binary64-Interchange-Bits.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Die Koordinatenreihenfolge `x, y` des Punkts orientiert sich an der Point/WKB-Achsenreihenfolge des OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html); jede Komponente folgt [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Dieser Payload ist ein kompaktes GEUL-Profil ohne WKB-Type-/Byte-Order-Header und ohne GeoPackage-Header und kein OGC-WKB-Wire-Format. CRS, Bedeutung der Achsen und Einheit sind externer Kontext.

## Länge {#길이}

- Die Gesamtlänge ist genau 13 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 8 WORD Payload; verwendet wird die direkte Länge `LLLL=1100`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 8 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Der Payload `3FF0 0000 0000 0000 4000 0000 0000 0000` ist `(1.0, 2.0)`.
