---
title: "SIGNED-INTEGER"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER is a Value that holds a signed integer in minimal WORDs, two's complement."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-INTEGER is a Value that represents a signed integer value. It is Value direct code `0x01`, family NUMERIC. The whole Payload is read as an arbitrary-precision two's complement integer in big-endian WORD order. The Payload is at least 1 WORD, and only the minimal-WORD canonical representation is allowed.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x01
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st  (upper WORD)   Integer 1st
...
Payload WORD Nth  (lower WORD)   Integer Nth
```

## Interpretation

- The most significant bit of the first Payload WORD is the sign bit of the whole integer.
- All Payload WORDs are read as one continuous two's complement bit sequence. The first WORD is the highest place and the last WORD the lowest.
- If the Payload is N WORDs, the interpretation width is `16N` bits. This width is not a declared storage width but the representation width of the value as fixed by the canonical form.
- There is no Byte Count or bit width descriptor.

## Canonical Form

- 0 is the Payload 1 WORD `0000`.
- Leading sign-extension WORDs that do not change the value are forbidden.
- When the Payload is 2 WORDs or more, the following are non-canonical.
  - The first WORD is `0000` and the most significant bit of the next WORD is 0
  - The first WORD is `ffff` and the most significant bit of the next WORD is 1
- A leading `0000` that preserves a positive sign is allowed when the most significant bit of the next WORD is 1.
- A leading `ffff` that preserves a negative sign is allowed when the most significant bit of the next WORD is 0.
- A decoder must reject a non-canonical representation.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Records and the TAG WORD](/grammar/record/)).
- Declared widths such as INT8, INT16, and INT32 are not preserved; only the numeric value is. `-32768` to `32767` is 1 WORD, and outside that range as many WORDs as needed are added. There is no separate SIGNED-INT8 format.

## Examples

| Value | Payload WORDs | Verdict |
|---:|---|---|
| 0 | `0000` | canonical |
| 1 | `0001` | canonical |
| 32767 | `7fff` | canonical |
| 32768 | `0000 8000` | canonical: `0000` is needed to preserve the positive sign |
| -1 | `ffff` | canonical |
| -32768 | `8000` | canonical |
| -32769 | `ffff 7fff` | canonical: `ffff` is needed to preserve the negative sign |
| 1 | `0000 0001` | non-canonical: unnecessary leading `0000` |
| -1 | `ffff ffff` | non-canonical: unnecessary leading `ffff` |

## Format Status

- Two's complement is a widely used convention, but this representation, which normalizes an arbitrary-precision value into a minimal sequence of 16-bit WORDs and combines it with a GEUL TAG, is a GEUL-specific scalar profile.
- When exchanging with fixed-width external types such as INT8/16/32/64, a range check and an explicit width conversion are needed.
