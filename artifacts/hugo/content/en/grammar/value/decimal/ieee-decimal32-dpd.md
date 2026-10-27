---
title: "IEEE-DECIMAL32-DPD"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD is a fixed 5 WORD Value that holds an IEEE 754 decimal32 DPD interchange bit sequence as it is."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD is a Value that represents the IEEE 754 decimal32 DPD interchange encoding. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, format number `0x2000`, family DECIMAL. It preserves the DPD bit pattern as it is and is distinguished from BID.

## Layout

```
TAG WORD          0x0A7C  5 WORD in total
Issuer            1 WORD  0x0040 (IEEE)
Format number     1 WORD  0x2000
Payload           2 WORD (32 bits)  IEEE decimal32 DPD Interchange
```

## Interpretation

- The two Payload WORDs are read, joined from the upper WORD, as an IEEE 754 decimal32 DPD interchange bit sequence.
- The bit pattern is preserved and is not arbitrarily reinterpreted as BID or SIGNED-DECIMAL.
- Special values and payloads are not arbitrarily normalized.

## Validity and Length

- The total is exactly 5 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 2 WORD. It uses the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 2 WORDs, reject.
- The semantic validity of the bit sequence follows the IEEE DPD interchange rules.

## Examples

| Structure | Verdict |
|---|---|
| `0A7C 0040 2000` + 2 WORD DPD bit sequence | canonical length structure |
| `0A7C 0040 2000` + 4 WORD | invalid: Payload width mismatch |
| format number `0x2003` on the same 32 bits | a BID format, not this type |

## Standards Basis

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): applies the decimal coefficient encoding (DPD) of the decimal32 interchange format. It does not convert numerically to the BID alternative that IEEE allows; it preserves the chosen 32-bit encoding, and GEUL adds only the TAG and WORD big-endian framing.
