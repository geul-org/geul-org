---
title: "IEEE-DECIMAL64-BID"
weight: 1029
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-BID is a Value that represents the IEEE 754 decimal64 BID interchange encoding."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-BID is a Value that represents the IEEE 754 decimal64 BID interchange encoding. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, codec number `0x00002004`, family DECIMAL. The BID bit pattern is preserved as is and is distinguished from DPD.

## Layout {#레이아웃}

```
TAG WORD          0x09D8  9 WORD in total
Issuer            2 WORD  0x0000000D (IEEE)
Codec number      2 WORD  0x00002004
Payload           4 WORD (64 bits)  IEEE decimal64 BID Interchange
```

## Interpretation {#해석}

- The four Payload WORD are read as an IEEE 754 decimal64 BID interchange bit string, concatenated from the most significant WORD first.
- The bit pattern is preserved and is not arbitrarily reinterpreted as DPD or exact decimal.
- Special values and payloads are not arbitrarily normalized.

## Validity and length {#유효성과-길이}

- The total is exactly 9 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 4 WORD, and it uses the direct length `LLLL=1000`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 4 WORD, it is rejected.
- The semantic validity of the bit string follows the IEEE BID interchange rules.

## Example {#예시}

| Structure | Verdict |
|---|---|
| `09D8 0000 000D 0000 2004` + 4 WORD BID bit string | canonical length structure |
| `09D8 0000 000D 0000 2004` + 2 WORD | invalid: Payload width mismatch |
| the same 64 bits with codec number `0x00002001` | DPD format, not this type |

## Standards basis {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): applies the binary coefficient encoding (BID) of the decimal64 interchange format. It does not numerically convert to the DPD alternative that IEEE allows but preserves the selected 64-bit encoding, and adds only the GEUL TAG and WORD big-endian framing.
