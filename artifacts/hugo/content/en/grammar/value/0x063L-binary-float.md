---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT is a Value that represents an IEEE 754 binary interchange scalar."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `BINARY-FLOAT` (spec document BIND `BINARY-FLOAT`) |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| Spec document | `0x00000000/codecs/0x00000630/` (DECLARE target `0630`) |
| Section | 3 `0011` (Value), offset C within the section = 3 |
| Kind | Value · family: NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | IEEE 754 binary16/32/64/128 scalar with a Payload of 1/2/4/8 WORD |
| Hugo side | `value/numeric/binary-float.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | remaining raw value (`0xFFFF`) |  |  |

BINARY-FLOAT is a Value that represents an IEEE 754 binary interchange scalar. Its direct Value code is `0x063L`, family NUMERIC. A Payload of 1/2/4/8 WORD is binary16/32/64/128 respectively. The interchange bit string is preserved as is, and no other Payload size is allowed.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st  (high WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (low WORD)    IEEE Binary Interchange Nth
```

## Interpretation {#해석}

- The Payload WORDs are concatenated in big-endian order and read as an IEEE 754 binary interchange bit string of the corresponding width.
- The interchange bit pattern is preserved, including the NaN payload and signed zero.
- A decoder must not replace a NaN with an arbitrary canonical NaN or drop the sign of a signed zero.
- Rounding mode and arithmetic behavior are not defined by this serialization format.

## Length {#길이}

The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload ([Record and TAG WORD](../record.md)).

| Format | Payload | Length code | Length extension TAG | Total Length |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | none | 2 WORD |
| binary32 | 2 WORD | `0010` | none | 3 WORD |
| binary64 | 4 WORD | `0100` | none | 5 WORD |
| binary128 | 8 WORD | `1000` | none | 9 WORD |

binary128 is also within the direct range of 1 to 14 WORD, so no Length extension TAG is used.

## Validity {#유효성}

- The Payload is exactly one of 1, 2, 4, or 8 WORD.
- Each Payload size must match the Length representation in the table above exactly.
- Re-encoding that changes the width, and padding WORDs before or after the Payload, are not allowed.

## Examples {#예시}

| Format | TAG | Length extension TAG | Payload example | Verdict |
|---|---|---|---|---|
| binary16 | `0631` | none | `0000` | canonical |
| binary32 | `0632` | none | `0000 0000` | canonical |
| binary64 | `0634` | none | `0000 0000 0000 0000` | canonical |
| binary128 | `0638` | none | 8 WORD bit string | canonical |
| any | size does not match the Length | any | any | invalid |

## Standards basis {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): applies the binary16, binary32, binary64, and binary128 interchange encodings. GEUL adds only the TAG and 16-bit WORD big-endian framing to that bit string.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000630/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
