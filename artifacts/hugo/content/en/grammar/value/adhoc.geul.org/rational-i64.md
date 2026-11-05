---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 is a Value that represents a rational number as an irreducible fraction of a big-endian int64 numerator and an int64 denominator."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 is a Value that represents a rational number as an irreducible fraction of a big-endian int64 numerator and an int64 denominator. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, codec number `0x00000702`, family NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD in total
Issuer            2 WORD  0x00000002 (ADHOC)
Codec number      2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interpretation and validity {#해석과-유효성}

- Each int64 is a fixed-width two's complement integer concatenated from the most significant WORD first, and the value is `numerator / denominator`.
- There is no ABI padding.
- The Payload is exactly 8 WORD, and the denominator must be positive.
- Only the irreducible form with `gcd(|numerator|, denominator) = 1` is allowed. Zero is written only as `0/1`.

## Formal status {#형식-지위}

- The two int64 values, the positive denominator, the greatest common divisor of 1, and the `0/1` canonicalization are a GEUL-specific format and do not adopt an external wire standard.
- This page fully defines the representation, including the two's complement interpretation of each int64, the component order, and the big-endian WORD framing.

## Length {#길이}

- The total is exactly 13 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 8 WORD, and it uses the direct length `LLLL=1100`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 8 WORD, it is rejected.

## Example {#예시}

- Numerator `1` and denominator `2` are a valid `1/2`. `2/4`, `0/2`, and denominator `-2` are invalid.
