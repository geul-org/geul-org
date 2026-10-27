---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT is a Value that holds an IEEE 754 binary16/32/64/128 interchange bit sequence as it is."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT is a Value that represents an IEEE 754 binary interchange scalar. It is Value direct code `0x03`, family NUMERIC. If the Payload is 1/2/4/8 WORD, it is binary16/32/64/128 respectively. It preserves the interchange bit sequence as it is, and other Payload sizes are not allowed.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st  (upper WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (lower WORD)   IEEE Binary Interchange Nth
```

## Interpretation

- Join the Payload WORDs in big-endian order and read them as an IEEE 754 binary interchange bit sequence of that width.
- Interchange bit patterns, including NaN payloads and signed zero, are preserved.
- A decoder must not replace a NaN with an arbitrary canonical NaN or erase the sign of a signed zero.
- Rounding modes and arithmetic behavior are not set by this serialization format.

## Length

The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload ([Records and the TAG WORD](/grammar/record/)).

| Format | Payload | Length code | Length extension TAG | Total Length |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | none | 2 WORD |
| binary32 | 2 WORD | `0010` | none | 3 WORD |
| binary64 | 4 WORD | `0100` | none | 5 WORD |
| binary128 | 8 WORD | `1000` | none | 9 WORD |

binary128 is also within the direct range of 1 to 14 WORDs, so no Length extension TAG is used.

## Validity

- The Payload is exactly one of 1, 2, 4, or 8 WORDs.
- Each Payload size must match the Length representation in the table above exactly.
- Re-encoding that changes the width, or padding WORDs before or after the Payload, is not allowed.

## Examples

| Format | TAG | Length extension TAG | Payload example | Verdict |
|---|---|---|---|---|
| binary16 | `0883` | none | `0000` | canonical |
| binary32 | `0903` | none | `0000 0000` | canonical |
| binary64 | `0A03` | none | `0000 0000 0000 0000` | canonical |
| binary128 | `0C03` | none | 8 WORD bit sequence | canonical |
| any | does not match the size the Length indicates | any | any | invalid |

## Standards Basis

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): the binary16, binary32, binary64, and binary128 interchange encodings apply. GEUL adds only the TAG and 16-bit WORD big-endian framing to that bit sequence.
