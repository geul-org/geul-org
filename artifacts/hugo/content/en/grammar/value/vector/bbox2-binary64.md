---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 is a 2-dimensional bounding box Value with four IEEE 754 binary64 components in the order (minX, minY, maxX, maxY) (ADHOC Issuer format 0x050C)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 is a 2-dimensional bounding box with four IEEE 754 binary64 components in the order `(minX, minY, maxX, maxY)`.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x050C`. Family NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0014 (20 WORD in total)
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Interpretation Rules

- Each component is binary64 and is read from the upper WORD. The signed zero bit pattern is preserved.
- The CRS, the meaning and order of the axes, and the unit are external context. There is no ABI padding.

## Validity

- The Payload must be exactly 16 WORDs, and `minX ≤ maxX` and `minY ≤ maxY` must hold.
- NaN cannot be compared, so if it appears in any component, reject.

## Standards Basis and Format Status

- The meaning of the minimum and maximum coordinates refers to the bounding envelope of the OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), and each component follows [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- The 2D array order of a GeoPackage envelope is `[minx, maxx, miny, maxy]`. The order `(minX, minY, maxX, maxY)` of this format is a compact tuple set by GEUL, not that wire order, and it does not hold a WKB/GeoPackage header either. The CRS, the meaning of the axes, and the unit are external context.

## Length

- The total is exactly 20 WORDs: the TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 16 WORD, using `LLLL=1110`. There is no descriptor or padding.
- If the Payload is not exactly 16 WORDs, reject.

## Example

- If the components are `(0.0, 1.0, 2.0, 3.0)` it is valid, and if `(2.0, 1.0, 0.0, 3.0)` it is invalid.
