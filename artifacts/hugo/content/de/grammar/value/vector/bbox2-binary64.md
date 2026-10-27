---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 ist ein Value für eine zweidimensionale Bounding Box aus vier IEEE-754-binary64-Komponenten in der Reihenfolge (minX, minY, maxX, maxY) (ADHOC-Issuer-Format 0x050C)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 ist eine zweidimensionale Bounding Box aus vier IEEE-754-binary64-Komponenten in der Reihenfolge `(minX, minY, maxX, maxY)`.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x050C`. Familie NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0014 (insgesamt 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Interpretationsregeln

- Jede Komponente ist binary64 und wird ab dem oberen WORD gelesen. Das Bitmuster von signed zero bleibt erhalten.
- CRS, Bedeutung und Reihenfolge der Achsen sowie Einheit sind äußerer Kontext. Es gibt kein ABI-Padding.

## Gültigkeit

- Der Payload muss genau 16 WORD haben, und es muss `minX ≤ maxX` und `minY ≤ maxY` gelten.
- NaN ist nicht vergleichbar und wird daher abgelehnt, wenn es in irgendeiner Komponente vorkommt.

## Normgrundlage und Formatstatus

- Die Bedeutung von Minimal- und Maximalkoordinaten orientiert sich am bounding envelope des OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), und jede Komponente folgt [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Die Reihenfolge des 2D-Arrays des GeoPackage-envelope ist `[minx, maxx, miny, maxy]`. Die Reihenfolge `(minX, minY, maxX, maxY)` dieses Formats ist nicht jene Wire-Reihenfolge, sondern ein von GEUL festgelegtes kompaktes Tupel und enthält auch keinen WKB-/GeoPackage-Header. CRS, Bedeutung der Achsen und Einheit sind äußerer Kontext.

## Länge

- Insgesamt sind es genau 20 WORD aus 1 WORD TAG, 1 WORD Length-Erweiterungs-TAG, 1 WORD Issuer, 1 WORD Formatnummer und 16 WORD Payload, mit `LLLL=1110`. Es gibt weder Descriptor noch Padding.
- Ist der Payload nicht genau 16 WORD, wird abgelehnt.

## Beispiel

- Sind die Komponenten `(0.0, 1.0, 2.0, 3.0)`, ist es gültig, bei `(2.0, 1.0, 0.0, 3.0)` ist es invalid.
