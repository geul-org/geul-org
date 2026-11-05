---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST is a fixed-width Value that holds the entire result of SHA-256 of the SHA-2 family."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `SHA-256-DIGEST` (spec document BIND `SHA-256-DIGEST`) |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| Spec document | `0x00000000/codecs/0x000007C0/` (DECLARE target `07C0`) |
| Section | 3 `0011` (Value), offset within section C = 28 |
| Kind | Value · family: BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | SHA-256 result in a fixed Payload of 16 WORDs |
| Hugo path | `value/binary/sha-256-digest.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | raw 16 WORDs |  |  |

SHA-256-DIGEST is a fixed-width Value that holds the entire result of SHA-256 of the SHA-2 family. It is the Value direct code `0x07CL`, family BINARY. The Payload is exactly 16 WORDs (256 bits), and truncation is not allowed.

## Layout {#레이아웃}

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
Length ext. TAG   1 WORD  0x0012 (18 WORDs in total)
Payload           16 WORDs  SHA-256 Digest
```

## Interpretation and validity {#해석과-유효성}

- Read the 32 Payload octets in the SHA-256 output order as is. Within each WORD, the upper octet comes first.
- No separate GEUL endian conversion is applied to the digest bit string. The output octet sequence is simply grouped two octets at a time in order and framed as 16-bit big-endian WORDs.
- A Payload that is not 16 WORDs, or a representation in which the result is arbitrarily cut, is rejected. There is no descriptor or padding.

## Standards basis {#표준-근거}

- The SHA-256 algorithm and its 256-bit result follow NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- The GEUL TAG, Length, and 16-bit WORD framing are rules this format adds and are not part of the SHA-2 algorithm.

## Length {#길이}

- The total is exactly 18 WORDs, the TAG 1 WORD, the Length extension TAG 1 WORD, and the Payload 16 WORDs added together, and uses `LLLL=1110`. There is no descriptor or padding.
- If the Payload is not exactly 16 WORDs, it is rejected.

## Example {#예시}

- The digest octets `d[0]` through `d[31]` are placed in order as Payload WORDs `(d[0]<<8)|d[1]` through `(d[30]<<8)|d[31]`. The total Length is always 18 WORDs.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000007C0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
