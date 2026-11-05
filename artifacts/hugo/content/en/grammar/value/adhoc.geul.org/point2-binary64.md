---
title: "POINT2-BINARY64"
weight: 1017
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 is a 2-dimensional point made of two IEEE 754 binary64 components in the order (x, y)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 is a 2-dimensional point made of two IEEE 754 binary64 components in the order `(x, y)`.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x0000050A`. Family NUMERIC.

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD in total
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x0000050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## Interpretation rules {#해석-규칙}

- Each component is read from the most significant WORD first, and the NaN payload and signed zero bit pattern are preserved.
- The CRS and the meaning, order, and unit of the axes are external context. There is no ABI padding.

## Validity {#유효성}

- The Payload is exactly 8 WORD, and each 4 WORD span is binary64 interchange bits.

## Standards basis and formal status {#표준-근거와-형식-지위}

- The `x, y` coordinate order of the point refers to the Point/WKB axis order of the OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), and each component follows [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- This Payload is a GEUL compact profile that carries no WKB type/byte-order header or GeoPackage header, and it is not the OGC WKB wire format. The CRS and the meaning and unit of the axes are external context.

## Length {#길이}

- The total is exactly 13 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 8 WORD, and it uses the direct length `LLLL=1100`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 8 WORD, it is rejected.

## Example {#예시}

- The Payload `3FF0 0000 0000 0000 4000 0000 0000 0000` is `(1.0, 2.0)`.
