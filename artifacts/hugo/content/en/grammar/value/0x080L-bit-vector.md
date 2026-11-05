---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR is a raw bit sequence with a stated length."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR is a raw bit sequence with a stated length. It is the Value direct code `0x080L`, family BINARY. The first 2 Payload WORDs are the unsigned 32-bit bit count `N`, followed by `ceil(N/16)` WORDs.

| Item | Value |
|---|---|
| Name | `BIT-VECTOR` (spec document BIND `BIT-VECTOR`) |
| TAG ID | `0x080L` |
| Codec ID | `0x00000800` |
| Spec document | `0x00000000/codecs/0x00000800/` (DECLARE target `0800`) |
| Section | 4 `0100` (Value), offset within section C = 0 |
| Kind | Value · family: BINARY |
| TAG WORD | `0000 1000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | N bits stored MSB-first after the bit count |
| Hugo path | `value/binary/bit-vector.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | raw 2 WORDs |  |  |
| 2 | `bits` | #3 | remaining raw bytes (`0xFFFF`) |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[Length extension TAG] when the total is 15 WORDs or more
Payload WORD 1st–2nd       Bit Count N (upper 16 bits │ lower 16 bits)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Interpretation and validity {#해석과-유효성}

- `N` is the value of the first 2 Payload WORDs read as a big-endian unsigned 32-bit integer.
- Payload bits are filled in order starting from the most significant bit of each WORD.
- The payload WORD count is exactly `ceil(N/16)`, and the unused lower bits of the last WORD must all be 0.
- If `N=0`, there are no payload WORDs. The two count WORDs already make up the Payload, so this does not conflict with the rule of a minimum of 1 Payload WORD.

## Format status {#형식-지위}

- The unsigned 32-bit bit count, the MSB-first arrangement, and the zero padding of the last WORD do not cite an external industry standard; they are GEUL's own framing.
- This page defines the representation, including the GEUL TAG, Length, and 16-bit WORD rules.

## Length {#길이}

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if present), and the Payload added together. 14 WORDs or fewer use a direct length; 15 WORDs or more use the `1110`·`1111` extended length, and the extension TAG is also included in the total ([Record and TAG WORD](../record.md)).

## Examples {#예시}

- The empty bit vector has count `0000 0000`, no payload, 3 WORDs in total, `LLLL=0010`. The whole is `0802 0000 0000`.
- The bit sequence `101` has count `0000 0003`, payload `A000`, 4 WORDs in total, `LLLL=0011`. The whole is `0803 0000 0003 A000`.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000800/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
