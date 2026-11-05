---
title: "IEEE-DECIMAL128-DPD"
weight: 1026
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD is a Value that represents the IEEE 754 decimal128 DPD interchange encoding."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD is a Value that represents the IEEE 754 decimal128 DPD interchange encoding. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, codec number `0x00002002`, family DECIMAL. The DPD bit pattern is preserved as is and is distinguished from BID.

## Layout {#레이아웃}

```
TAG WORD          0x09DC  13 WORD in total
Issuer            2 WORD  0x0000000D (IEEE)
Codec number      2 WORD  0x00002002
Payload           8 WORD (128 bits)  IEEE decimal128 DPD Interchange
```

## Interpretation {#해석}

- The eight Payload WORD are read as an IEEE 754 decimal128 DPD interchange bit string, concatenated from the most significant WORD first.
- The bit pattern is preserved and is not arbitrarily reinterpreted as BID or exact decimal.
- Special values and payloads are not arbitrarily normalized.

## Validity and length {#유효성과-길이}

- The total is exactly 13 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 8 WORD, and it uses the direct length `LLLL=1100`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 8 WORD, it is rejected.
- The semantic validity of the bit string follows the IEEE DPD interchange rules.

## Example {#예시}

| Structure | Verdict |
|---|---|
| `09DC 0000 000D 0000 2002` + 8 WORD DPD bit string | canonical |
| the total is not 13 WORD (`LLLL=1100`) | invalid: does not match the fixed Payload width |

## Standards basis {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): applies the decimal coefficient encoding (DPD) of the decimal128 interchange format. It does not numerically convert to the BID alternative that IEEE allows but preserves the selected 128-bit encoding, and adds only the GEUL TAG and WORD big-endian framing.
