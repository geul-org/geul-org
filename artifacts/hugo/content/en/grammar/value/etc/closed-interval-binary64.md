---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 is a fixed 11 WORD ADHOC Issuer format that holds a finite, non-empty closed interval with binary64 lower and upper bounds."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 is a Value that represents a closed interval with two IEEE 754 binary64 endpoints in the order `(lower, upper)`. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x0703`, family NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD in total
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interpretation and Validity

- The two endpoints are binary64 in big-endian WORD order, and both ends are included.
- The signed zero bit pattern of a valid endpoint is preserved as it is. There is no ABI padding.
- The Payload is exactly 8 WORDs and `lower ≤ upper` must hold.
- NaN is rejected because it cannot be compared. An infinity endpoint is also rejected because it makes an unbounded interval.
- Empty, unbounded, and open intervals and NaI cannot be expressed in this format and are rejected.

## Standards Basis and Format Status

- The endpoint numeric format follows [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), and the meaning of a closed endpoint pair refers to the interval model of [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) and its simplified flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- This format is a simple GEUL profile that allows only finite, non-empty closed intervals. It does not implement or serialize as-is the decorations, NaI, empty/unbounded intervals, or the full operation and interchange model of IEEE 1788/1788.1.

## Length

- The total is exactly 11 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 8 WORD. It uses the direct length `LLLL=1010`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 8 WORDs, reject.

## Example

- The endpoints `(1.0, 2.0)` are `[1.0, 2.0]` and valid. `(2.0, 1.0)` and `(NaN, 1.0)` are invalid.
