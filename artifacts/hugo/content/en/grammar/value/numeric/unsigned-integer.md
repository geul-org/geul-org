---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER is a Value that holds an unsigned integer as a big-endian magnitude in minimal WORDs."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER is a Value that represents an unsigned integer value. It is Value direct code `0x02`, family NUMERIC. The whole Payload is read as an arbitrary-precision unsigned magnitude in big-endian WORD order. The Payload is at least 1 WORD, and only the minimal-WORD canonical representation is allowed.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st  (upper WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (lower WORD)   Unsigned Magnitude Nth
```

## Interpretation

- The first Payload WORD is the highest place and the last WORD the lowest.
- If the Payload is N WORDs, it is read as one `16N`-bit unsigned magnitude.
- This width is not a declared storage width, and there is no bit width descriptor.

## Canonical Form

- 0 is the Payload 1 WORD `0000`.
- When the Payload is 2 WORDs or more and the first WORD is `0000`, it is non-canonical because removing it leaves the value the same.
- A decoder must reject a representation with an unnecessary leading zero WORD.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Records and the TAG WORD](/grammar/record/)).
- Declared widths such as UINT8, UINT16, and UINT32 are not preserved; only the numeric value is.

## Examples

| Value | Payload WORDs | Verdict |
|---:|---|---|
| 0 | `0000` | canonical |
| 1 | `0001` | canonical |
| 65535 | `ffff` | canonical |
| 65536 | `0001 0000` | canonical |
| 1 | `0000 0001` | non-canonical: unnecessary leading `0000` |
| 7 WORD Payload | the 7 WORDs after TAG `0b82` (direct length `LLLL=0111`, 8 WORDs in total) | canonical |
| 7 WORD Payload | the 7 WORDs after an extended length TAG and extension value `0009` | non-canonical: 14 WORDs or fewer use a direct length |

## Format Status

- This representation, which normalizes an arbitrary-precision unsigned magnitude into a minimal sequence of 16-bit WORDs and combines it with a GEUL TAG, is a GEUL-specific scalar profile.
- When exchanging with fixed-width external types such as UINT8/16/32/64, a range check and an explicit width conversion are needed.
