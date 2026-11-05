---
title: "SIGNED-DECIMAL (0x068L)"
weight: 104
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL is an exact decimal Value with a signed coefficient."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `SIGNED-DECIMAL` (spec document BIND `SIGNED-DECIMAL`) |
| TAG ID | `0x068L` |
| Codec ID | `0x00000680` |
| Spec document | `0x00000000/codecs/0x00000680/` (DECLARE target `0680`) |
| Section | 3 `0011` (Value), offset C within the section = 8 |
| Kind | Value · family: DECIMAL |
| TAG WORD | `0000 0110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | `C×10^E` of a signed exponent `E` and a minimum-WORD two's complement coefficient `C` |
| Hugo side | `value/decimal/signed-decimal.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | raw value, 2 WORD |  |  |
| 2 | `coefficient` | #3 | remaining raw value (`0xFFFF`) |  |  |

SIGNED-DECIMAL is an exact decimal Value with a signed coefficient. Its direct Value code is `0x068L`, family DECIMAL. The first 2 WORD of the Payload are the signed 32-bit decimal exponent `E`, and the rest is the minimum-WORD two's complement coefficient `C`; the value is `C×10^E`.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 1000 LLLL      Codec 0x068L
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st–2nd (32 bit)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD or more)  Signed Two's-complement Coefficient C
```

## Interpretation {#해석}

- `E` is a signed 32-bit big-endian two's complement integer written from the high WORD.
- `C` is an arbitrary-precision two's complement integer formed by concatenating all the remaining WORDs from the high WORD.
- `C` follows the same minimum-WORD rule as [SIGNED-INTEGER](0x061L-signed-integer.md). Leading `0000` or `FFFF` WORDs that can be removed are forbidden.

## Length and validity {#길이와-유효성}

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload. Up to 14 WORD uses the direct length, and 15 WORD or more uses the `1110`/`1111` extended length; the extension TAG is also counted in the total ([Record and TAG WORD](../record.md)).
- The Payload is the exponent 2 WORD plus the coefficient 1 WORD or more, so it is at least 3 WORD.
- The canonicality of the byte representation checks only the minimum-WORD representation of the coefficient.

## Examples {#예시}

| Value representation | Payload (`E` + `C`) | Verdict |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | byte representation canonical |
| `10×10^-1` | `FFFF FFFF 000A` | byte representation canonical; the canonical relation to the representation above is an open problem |
| `1×10^0` | `0000 0000 0000 0001` | non-canonical: leading `0000` of the coefficient is unnecessary |
| Payload 7 WORD | direct length `LLLL=0111`, total 8 WORD | canonical length structure |

## Format status {#형식-지위}

- This layout, which binds a signed 32-bit exponent `E` and a minimum-WORD coefficient `C`, is a GEUL-specific format, not IEEE 754 decimal interchange or Apache Parquet `DECIMAL`.
- Parquet `DECIMAL` uses `unscaledValue × 10^(-scale)` and required precision/scale metadata, stores the unscaled value of the byte-array physical type as a big-endian two's complement, and has a scale of 0 or greater. This format puts a signed `E` in the body and has no precision metadata, so it is not the same format.
- Exchanging values with IEEE 754 decimal or Parquet `DECIMAL` requires an explicit conversion that defines the range, precision/scale, quantum, and special-value policy.
- Comparison basis: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Open problems {#열린-문제}

- There are several exponent/coefficient pairs that represent the same number, such as `10×10^-1` and `1×10^0`.
- Whether this format preserves the quantum, how value equality is decided, and how the canonical exponent is normalized have not been decided yet.
- So an implementation must not arbitrarily enforce exponent/coefficient normalization beyond the coefficient minimum-WORD rule.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000680/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000068000000000
BODY
#1 DECLARE 0x0680
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "SIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
