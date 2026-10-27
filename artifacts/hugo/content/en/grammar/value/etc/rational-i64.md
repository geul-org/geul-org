---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 is a fixed 11 WORD ADHOC Issuer format that holds a rational number as an irreducible fraction of an int64 numerator and a positive int64 denominator."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 is a Value that represents a rational number as an irreducible fraction of a big-endian int64 numerator and an int64 denominator. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, format number `0x0702`, family NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD in total
Issuer            1 WORD  0x0001 (ADHOC)
Format number     1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interpretation and Validity

- Each int64 is a fixed-width two's complement integer joined from the upper WORD, and the value is `numerator / denominator`.
- There is no ABI padding.
- The Payload is exactly 8 WORDs and the denominator must be positive.
- Only the irreducible form with `gcd(|numerator|, denominator) = 1` is allowed. 0 is written only as `0/1`.

## Format Status

- Two int64s, a positive denominator, a greatest common divisor of 1, and the `0/1` canonicalization are a GEUL-specific format, not the adoption of an external wire standard.
- This page fully defines the representation, including the two's complement interpretation of each int64, the component order, and the big-endian WORD framing.

## Length

- The total is exactly 11 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 8 WORD. It uses the direct length `LLLL=1010`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 8 WORDs, reject.

## Example

- Numerator `1` and denominator `2` are a valid `1/2`. `2/4`, `0/2`, and denominator `-2` are invalid.
