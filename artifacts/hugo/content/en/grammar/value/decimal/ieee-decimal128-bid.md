---
title: "IEEE-DECIMAL128-BID"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-BID is a fixed 11 WORD Value that holds an IEEE 754 decimal128 BID interchange bit sequence as it is."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-BID is a Value that represents the IEEE 754 decimal128 BID interchange encoding. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, format number `0x2005`, family DECIMAL. It preserves the BID bit pattern as it is and is distinguished from DPD.

## Layout

```
TAG WORD          0x0D7C  11 WORD in total
Issuer            1 WORD  0x0040 (IEEE)
Format number     1 WORD  0x2005
Payload           8 WORD (128 bits)  IEEE decimal128 BID Interchange
```

## Interpretation

- The eight Payload WORDs are read, joined from the upper WORD, as an IEEE 754 decimal128 BID interchange bit sequence.
- The bit pattern is preserved and is not arbitrarily reinterpreted as DPD or an exact decimal format.
- Special values and payloads are not arbitrarily normalized.

## Validity and Length

- The total is exactly 11 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 8 WORD. It uses the direct length `LLLL=1010`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 8 WORDs, reject.
- The semantic validity of the bit sequence follows the IEEE BID interchange rules.

## Examples

| Structure | Verdict |
|---|---|
| `0D7C 0040 2005` + 8 WORD BID bit sequence | canonical |
| the total is not 11 WORD (`LLLL=1010`) | invalid: does not match the fixed Payload width |

## Standards Basis

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): applies the binary coefficient encoding (BID) of the decimal128 interchange format. It does not convert numerically to the DPD alternative that IEEE allows; it preserves the chosen 128-bit encoding, and GEUL adds only the TAG and WORD big-endian framing.
