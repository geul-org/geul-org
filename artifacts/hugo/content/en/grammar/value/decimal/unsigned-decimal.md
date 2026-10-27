---
title: "UNSIGNED-DECIMAL"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL is a Value that holds the exact decimal C×10^E with a signed 32-bit exponent E and an unsigned coefficient C in minimal WORDs."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-DECIMAL is an exact decimal Value with an unsigned coefficient. It is Value direct code `0x11`, family DECIMAL. The first 2 WORDs of the Payload are the signed 32-bit decimal exponent `E`, and the rest is the unsigned coefficient `C` in minimal WORDs; the value is `C×10^E`.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x11
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st–2nd (32 bits)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD or more)  Unsigned Coefficient C
```

## Interpretation

- `E` is a signed 32-bit big-endian two's complement integer written from the upper WORD.
- `C` is an arbitrary-precision unsigned magnitude read from all the remaining WORDs, from the upper WORD.
- `C` follows the same minimal-WORD rule as [UNSIGNED-INTEGER](/grammar/value/numeric/unsigned-integer/). 0 is `0000`, and a first WORD `0000` in 2 WORDs or more is forbidden.

## Length and Validity

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Records and the TAG WORD](/grammar/record/)).
- The Payload is exponent 2 WORD and coefficient 1 WORD or more, so at least 3 WORD.
- Canonicality of the byte representation checks only the minimal-WORD representation of the coefficient.

## Examples

| Value representation | Payload (`E` + `C`) | Verdict |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | byte representation canonical |
| `10×10^-1` | `ffff ffff 000a` | byte representation canonical; the canonical relation to the representation above is an open question |
| `1×10^0` | `0000 0000 0000 0001` | non-canonical: leading `0000` of the coefficient is unnecessary |
| negative coefficient | not applicable | invalid |

## Format Status

- This layout, which combines a signed 32-bit exponent `E` and an unsigned minimal-WORD coefficient `C`, is a GEUL-specific format, not IEEE 754 decimal interchange or Apache Parquet `DECIMAL`.
- Parquet `DECIMAL` uses a signed unscaled value, `unscaledValue × 10^(-scale)`, and required precision/scale metadata, and the byte-array physical type is big-endian two's complement with a scale of 0 or more. This format is not the same because of its unsigned `C`, signed `E`, and lack of precision metadata.
- To exchange with IEEE 754 decimal or Parquet `DECIMAL`, an explicit conversion that sets the sign, range, precision/scale, quantum, and special-value policy is needed.
- Comparison basis: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Open Questions

- There are several exponent/coefficient pairs that represent the same number, such as `10×10^-1` and `1×10^0`.
- Whether this format preserves quantum, how value equality is decided, and how the canonical exponent is normalized are not yet decided.
- So an implementation must not arbitrarily force exponent/coefficient normalization beyond the coefficient minimal-WORD rule.
