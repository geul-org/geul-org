---
title: "IEEE-DECIMAL32-BID"
weight: 1027
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-BID is a Value that represents the IEEE 754 decimal32 BID interchange encoding."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-BID is a Value that represents the IEEE 754 decimal32 BID interchange encoding. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, codec number `0x00002003`, family DECIMAL. The BID bit pattern is preserved as is and is distinguished from DPD.

## Layout {#레이아웃}

```
TAG WORD          0x09D6  7 WORD in total
Issuer            2 WORD  0x0000000D (IEEE)
Codec number      2 WORD  0x00002003
Payload           2 WORD (32 bits)  IEEE decimal32 BID Interchange
```

## Interpretation {#해석}

- The two Payload WORD are read as an IEEE 754 decimal32 BID interchange bit string, concatenated from the most significant WORD first.
- The bit pattern is preserved and is not arbitrarily reinterpreted as DPD or SIGNED-DECIMAL.
- Special values and payloads are not arbitrarily normalized.

## Validity and length {#유효성과-길이}

- The total is exactly 7 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 2 WORD, and it uses the direct length `LLLL=0110`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 2 WORD, it is rejected.
- The semantic validity of the bit string follows the IEEE BID interchange rules.

## Example {#예시}

| Structure | Verdict |
|---|---|
| `09D6 0000 000D 0000 2003` + 2 WORD BID bit string | canonical length structure |
| `09D6 0000 000D 0000 2003` + 4 WORD | invalid: Payload width mismatch |
| the same 32 bits with codec number `0x00002000` | DPD format, not this type |

## Standards basis {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): applies the binary coefficient encoding (BID) of the decimal32 interchange format. It does not numerically convert to the DPD alternative that IEEE allows but preserves the selected 32-bit encoding, and adds only the GEUL TAG and WORD big-endian framing.
