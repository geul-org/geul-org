---
title: "POINT3-BINARY64"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 is a 3-dimensional point Value with three IEEE 754 binary64 components in the order (x, y, z) (ADHOC Issuer format 0x050B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 is a 3-dimensional point with three IEEE 754 binary64 components in the order `(x, y, z)`.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x050B`. Family NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0010 (16 WORD in total)
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Interpretation Rules

- Each component is read from the upper WORD, and the NaN payload and signed zero bit patterns are preserved.
- The CRS, the meaning and order of the axes, and the unit are external context. There is no ABI padding.

## Validity

- The Payload is exactly 12 WORDs, and each 4 WORD section is binary64 interchange bits.

## Standards Basis and Format Status

- The `x, y, z` coordinate order of a point refers to the Point/WKB axis order of the OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), and each component follows [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- This Payload is a GEUL compact profile that holds no WKB type/byte-order header or GeoPackage header, and is not the OGC WKB wire format. The CRS, the meaning of the axes, and the unit are external context.

## Length

- The total is exactly 16 WORDs: the TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 12 WORD, using `LLLL=1110`. There is no descriptor or padding.
- If the Payload is not exactly 12 WORDs, reject.

## Example

- If the three binary64 values in the Payload are `1.0, 2.0, 3.0`, the point is `(1.0, 2.0, 3.0)`.
