---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST is a fixed-width Value that holds the entire SHA-1 result."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `SHA1-DIGEST` (spec document BIND `SHA1-DIGEST`) |
| TAG ID | `0x07DL` |
| Codec ID | `0x000007D0` |
| Spec document | `0x00000000/codecs/0x000007D0/` (DECLARE target `07D0`) |
| Section | 3 `0011` (Value), offset within section C = 29 |
| Kind | Value · family: BINARY |
| TAG WORD | `0000 0111 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | SHA-1 result in a fixed Payload of 10 WORDs. For identification only, such as git object IDs |
| Hugo path | `value/binary/sha1-digest.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | raw 10 WORDs |  |  |

SHA1-DIGEST is a fixed-width Value that holds the entire SHA-1 result. It is the Value direct code `0x07DL`, family BINARY. The Payload is exactly 10 WORDs (160 bits), and truncation is not allowed.

**Use it for identification only.** SHA-1 has lost its collision resistance (2017 SHAttered). For integrity and signatures, use [SHA-256-DIGEST](0x07CL-sha-256-digest.md). This format exists to hold, as is, identifiers already fixed by SHA-1, typically the object IDs (commit IDs) of SHA-1 git repositories. For example, it holds the Version (commit ID) of [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md) in 11 WORDs instead of hex text (22 WORDs).

## Layout {#레이아웃}

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORDs  SHA-1 Digest
```

## Interpretation and validity {#해석과-유효성}

- Read the 20 Payload octets in the SHA-1 output order as is. Within each WORD, the upper octet comes first (the same framing as SHA-256-DIGEST).
- A Payload that is not 10 WORDs, or a representation in which the result is arbitrarily cut (such as an abbreviated git ID), is rejected. There is no descriptor or padding.
- A git object ID is the value as git computed it. The SHA-1 of git is a variant with collision detection (SHA-1DC), but for inputs that are not collision attacks the result is the same as SHA-1.

## Standards basis {#표준-근거}

- The SHA-1 algorithm and its 160-bit result follow NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- The GEUL TAG and 16-bit WORD framing are rules this format adds.

## Length {#길이}

- The total is exactly 11 WORDs, the TAG 1 WORD plus the Payload 10 WORDs, and uses `LLLL=1010`. There is no Length extension.

## Example {#예시}

git commit `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Related pages {#관련-페이지}

- [Value](_index.md), [SHA-256-DIGEST](0x07CL-sha-256-digest.md), [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000007D0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
