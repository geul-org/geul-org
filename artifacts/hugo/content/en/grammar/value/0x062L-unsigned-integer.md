---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER is a Value that represents an unsigned integer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `UNSIGNED-INTEGER` (spec document BIND `UNSIGNED-INTEGER`) |
| TAG ID | `0x062L` |
| Codec ID | `0x00000620` |
| Spec document | `0x00000000/codecs/0x00000620/` (DECLARE target `0620`) |
| Section | 3 `0011` (Value), offset C within the section = 2 |
| Kind | Value · family: NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Minimum-WORD big-endian unsigned magnitude integer |
| Hugo side | `value/numeric/unsigned-integer.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | remaining raw value (`0xFFFF`) |  |  |

UNSIGNED-INTEGER is a Value that represents an unsigned integer. Its direct Value code is `0x062L`, family NUMERIC. The whole Payload is read as an arbitrary-precision unsigned magnitude in big-endian WORD order. The Payload is at least 1 WORD, and only the minimum-WORD canonical representation is allowed.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st  (high WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (low WORD)    Unsigned Magnitude Nth
```

## Interpretation {#해석}

- The first Payload WORD is the highest place and the last WORD is the lowest.
- If the Payload is N WORD, it is read as a single `16N` bit unsigned magnitude.
- This width is not a declared storage width, and there is no bit width descriptor.

## Canonical form {#정규-표현}

- 0 is the 1 WORD Payload `0000`.
- When the Payload is 2 WORD or more and the first WORD is `0000`, the representation is non-canonical because removing it leaves the value unchanged.
- A decoder must reject a representation with an unnecessary leading zero WORD.

## Length {#길이}

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload. Up to 14 WORD uses the direct length, and 15 WORD or more uses the `1110`/`1111` extended length; the extension TAG is also counted in the total ([Record and TAG WORD](../record.md)).
- A declared width such as UINT8, UINT16, or UINT32 is not preserved; only the numeric value is.

## Examples {#예시}

| Value | Payload WORD | Verdict |
|---:|---|---|
| 0 | `0000` | canonical |
| 1 | `0001` | canonical |
| 65535 | `FFFF` | canonical |
| 65536 | `0001 0000` | canonical |
| 1 | `0000 0001` | non-canonical: unnecessary leading `0000` |
| 7 WORD Payload | 7 WORD after TAG `0627` (direct length `LLLL=0111`, total 8 WORD) | canonical |
| 7 WORD Payload | 7 WORD after a Length extension TAG with extension value `0009` | non-canonical: up to 14 WORD must use the direct length |

## Format status {#형식-지위}

- This representation, which normalizes an arbitrary-precision unsigned magnitude into a sequence of minimum 16-bit WORDs and binds it to a GEUL TAG, is a GEUL-specific scalar profile.
- Exchanging values with fixed-width external types such as UINT8/16/32/64 requires a range check and an explicit width conversion.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000620/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
