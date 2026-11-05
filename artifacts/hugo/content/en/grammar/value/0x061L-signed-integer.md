---
title: "SIGNED-INTEGER (0x061L)"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER is a Value that represents a signed integer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `SIGNED-INTEGER` (spec document BIND `SIGNED-INTEGER`) |
| TAG ID | `0x061L` |
| Codec ID | `0x00000610` |
| Spec document | `0x00000000/codecs/0x00000610/` (DECLARE target `0610`) |
| Section | 3 `0011` (Value), offset C within the section = 1 |
| Kind | Value · family: NUMERIC |
| TAG WORD | `0000 0110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Minimum-WORD two's complement signed integer |
| Hugo side | `value/numeric/signed-integer.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `integer` | #2 | remaining raw value (`0xFFFF`) |  |  |

SIGNED-INTEGER is a Value that represents a signed integer. Its direct Value code is `0x061L`, family NUMERIC. The whole Payload is read as an arbitrary-precision two's complement integer in big-endian WORD order. The Payload is at least 1 WORD, and only the minimum-WORD canonical representation is allowed.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0001 LLLL      Codec 0x061L
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st  (high WORD)   Integer 1st
...
Payload WORD Nth  (low WORD)    Integer Nth
```

## Interpretation {#해석}

- The most significant bit of the first Payload WORD is the sign bit of the whole integer.
- All Payload WORDs are read as one continuous two's complement bit string. The first WORD is the highest place and the last WORD is the lowest.
- If the Payload is N WORD, the interpretation width is `16N` bit. This width is not a declared storage width but the representation width of the value determined by the canonical form.
- There is no Byte Count or bit width descriptor.

## Canonical form {#정규-표현}

- 0 is the 1 WORD Payload `0000`.
- Leading sign-extension WORDs that do not change the value are forbidden.
- When the Payload is 2 WORD or more, the following are non-canonical.
  - The first WORD is `0000` and the most significant bit of the next WORD is 0
  - The first WORD is `FFFF` and the most significant bit of the next WORD is 1
- A leading `0000` that preserves the sign of a positive number is allowed when the most significant bit of the next WORD is 1.
- A leading `FFFF` that preserves the sign of a negative number is allowed when the most significant bit of the next WORD is 0.
- A decoder must reject a non-canonical representation.

## Length {#길이}

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload. Up to 14 WORD uses the direct length, and 15 WORD or more uses the `1110`/`1111` extended length; the extension TAG is also counted in the total ([Record and TAG WORD](../record.md)).
- A declared width such as INT8, INT16, or INT32 is not preserved; only the numeric value is. `-32768` to `32767` is 1 WORD, and outside that range as many WORDs as needed are added. There is no separate SIGNED-INT8 format.

## Examples {#예시}

| Value | Payload WORD | Verdict |
|---:|---|---|
| 0 | `0000` | canonical |
| 1 | `0001` | canonical |
| 32767 | `7FFF` | canonical |
| 32768 | `0000 8000` | canonical: `0000` is needed to preserve the positive sign |
| -1 | `FFFF` | canonical |
| -32768 | `8000` | canonical |
| -32769 | `FFFF 7FFF` | canonical: `FFFF` is needed to preserve the negative sign |
| 1 | `0000 0001` | non-canonical: unnecessary leading `0000` |
| -1 | `FFFF FFFF` | non-canonical: unnecessary leading `FFFF` |

## Format status {#형식-지위}

- Two's complement is a widely used convention, but this representation, which normalizes an arbitrary-precision value into a sequence of minimum 16-bit WORDs and binds it to a GEUL TAG, is a GEUL-specific scalar profile.
- Exchanging values with fixed-width external types such as INT8/16/32/64 requires a range check and an explicit width conversion.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000610/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000061000000000
BODY
#1 DECLARE 0x0610
#2 FIELD #1 rest
#3 BIND #1 "SIGNED-INTEGER"
#4 BIND #2 "integer"
```
