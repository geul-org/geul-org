---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 is a Value that represents a closed interval by two IEEE 754 binary64 endpoints in the order (lower, upper)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 is a Value that represents a closed interval by two IEEE 754 binary64 endpoints in the order `(lower, upper)`. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x00000703`, family NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD in total
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interpretation and validity {#해석과-유효성}

- The two endpoints are binary64 in big-endian WORD order, and both ends are included.
- The signed zero bit pattern of a valid endpoint is preserved as is. There is no ABI padding.
- The Payload is exactly 8 WORD, and `lower ≤ upper` must hold.
- NaN cannot be compared, so it is rejected. An infinity endpoint makes the interval unbounded, so it is also rejected.
- Empty, unbounded, and open intervals and NaI cannot be represented by this format and are rejected.

## Standards basis and formal status {#표준-근거와-형식-지위}

- The endpoint numeric format follows [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), and the meaning of a closed endpoint pair refers to the interval model of [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) and its simplified flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- This format is a simple GEUL profile that allows only finite, non-empty closed intervals. It does not implement or serialize as is decorations, NaI, empty/unbounded intervals, or the full operation and interchange model of IEEE 1788/1788.1.

## Length {#길이}

- The total is exactly 13 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 8 WORD, and it uses the direct length `LLLL=1100`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 8 WORD, it is rejected.

## Example {#예시}

- The endpoints `(1.0, 2.0)` give `[1.0, 2.0]` and are valid. `(2.0, 1.0)` and `(NaN, 1.0)` are invalid.
