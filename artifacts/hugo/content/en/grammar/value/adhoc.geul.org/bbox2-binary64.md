---
title: "BBOX2-BINARY64"
weight: 1000
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 is a 2-dimensional bounding box made of four IEEE 754 binary64 components in the order (minX, minY, maxX, maxY)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 is a 2-dimensional bounding box made of four IEEE 754 binary64 components in the order `(minX, minY, maxX, maxY)`.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x0000050C`. Family NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length ext. TAG   1 WORD  0x0016 (22 WORD in total)
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x0000050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Interpretation rules {#해석-규칙}

- Each component is a binary64 read from the most significant WORD first. The signed zero bit pattern is preserved.
- The CRS and the meaning, order, and unit of the axes are external context. There is no ABI padding.

## Validity {#유효성}

- The Payload must be exactly 16 WORD, and `minX ≤ maxX` and `minY ≤ maxY` must hold.
- NaN cannot be compared, so it is rejected in any component.

## Standards basis and formal status {#표준-근거와-형식-지위}

- The meaning of the minimum and maximum coordinates refers to the bounding envelope of the OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), and each component follows [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- The 2D array order of a GeoPackage envelope is `[minx, maxx, miny, maxy]`. The `(minX, minY, maxX, maxY)` order of this format is not that wire order but a compact tuple defined by GEUL, and it does not carry a WKB/GeoPackage header either. The CRS and the meaning and unit of the axes are external context.

## Length {#길이}

- The total is exactly 22 WORD: TAG 1 WORD, Length extension TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 16 WORD, and it uses `LLLL=1110`. There is no descriptor and no padding.
- If the Payload is not exactly 16 WORD, it is rejected.

## Example {#예시}

- If the components are `(0.0, 1.0, 2.0, 3.0)` it is valid, and `(2.0, 1.0, 0.0, 3.0)` is invalid.
