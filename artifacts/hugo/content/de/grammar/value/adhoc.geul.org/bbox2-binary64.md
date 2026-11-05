---
title: "BBOX2-BINARY64"
weight: 1000
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 ist ein zweidimensionaler Begrenzungsrahmen aus vier IEEE-754-binary64-Komponenten in der Reihenfolge (minX, minY, maxX, maxY)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 ist ein zweidimensionaler Begrenzungsrahmen aus vier IEEE-754-binary64-Komponenten in der Reihenfolge `(minX, minY, maxX, maxY)`.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x0000050C`. Familie NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0016 (insgesamt 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x0000050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Interpretationsregeln {#해석-규칙}

- Jede Komponente ist binary64 und wird ab dem höchstwertigen WORD gelesen. Das Bitmuster von signed zero bleibt erhalten.
- CRS, Bedeutung und Reihenfolge der Achsen sowie die Einheit sind externer Kontext. Es gibt kein ABI-Padding.

## Gültigkeit {#유효성}

- Der Payload muss genau 16 WORD umfassen, und es muss `minX ≤ maxX` und `minY ≤ maxY` gelten.
- NaN ist nicht vergleichbar und wird daher abgelehnt, wenn es in irgendeiner Komponente vorkommt.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Die Bedeutung von Minimal- und Maximalkoordinaten orientiert sich am Bounding Envelope des OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html); jede Komponente folgt [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Die Reihenfolge des 2D-Arrays im GeoPackage-Envelope ist `[minx, maxx, miny, maxy]`. Die Reihenfolge `(minX, minY, maxX, maxY)` dieses Formats ist nicht deren Wire Order, sondern ein von GEUL festgelegtes kompaktes Tupel; WKB-/GeoPackage-Header enthält es ebenfalls nicht. CRS, Bedeutung der Achsen und Einheit sind externer Kontext.

## Länge {#길이}

- Die Gesamtlänge ist genau 22 WORD: 1 WORD TAG, 1 WORD Length-Erweiterungs-TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 16 WORD Payload; verwendet wird `LLLL=1110`. Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 16 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Sind die Komponenten `(0.0, 1.0, 2.0, 3.0)`, ist der Wert gültig; bei `(2.0, 1.0, 0.0, 3.0)` ist er invalid.
