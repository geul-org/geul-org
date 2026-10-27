---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR is a GEUL Issuer format that holds N bits MSB-first after a 32-bit bit count N."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR is a raw bit sequence whose length is stated. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, format number `0xC002`, family BINARY. The first 2 Payload WORDs are the unsigned 32-bit bit count `N`, followed by `ceil(N/16)` WORDs.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] when the total is 15 WORD or more
Issuer            1 WORD  0x0000 (GEUL)
Format number     1 WORD  0xC002
Payload WORD 1st–2nd       Bit Count N (upper 16bit │ lower 16bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Interpretation and Validity

- `N` is the value of the first 2 Payload WORDs read as a big-endian unsigned 32-bit integer.
- Payload bits are filled in order from the most significant bit of each WORD.
- The payload WORD count is exactly `ceil(N/16)`, and the unused lower bits of the last WORD must all be 0.
- If `N=0`, there are no payload WORDs. The two count WORDs already make up the Payload, so this does not conflict with the rule that the Payload is at least 1 WORD.

## Format Status

- The unsigned 32-bit bit count, the MSB-first placement, and the zero padding of the last WORD are not cited from an external industry standard but are GEUL-specific framing.
- This page defines the representation, including the GEUL TAG, Length, and 16-bit WORD rules.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), Issuer 1 WORD, format number 1 WORD, and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Records and the TAG WORD](/grammar/record/)).

## Examples

- An empty bit vector is count `0000 0000`, no payload, 5 WORD in total, `LLLL=0100`.
- The bit sequence `101` is count `0000 0003`, payload `a000`, 6 WORD in total, `LLLL=0101`.
