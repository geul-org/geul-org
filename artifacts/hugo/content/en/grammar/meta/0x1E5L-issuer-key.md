---
title: "ISSUER-KEY (0x1E5L)"
weight: 485
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Declares the public key of a self-issued (16 WORD) Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `ISSUER-KEY` (spec document BIND `ISSUER-KEY`) |
| TAG ID | `0x1E5L` |
| Codec ID | `0x00001E50` |
| Spec document | `0x00000000/codecs/0x00001E50/` (DECLARE target `1E50`) |
| Section | 15 `1111` (Meta), offset within section C = 5 |
| Kind | Meta · class: verification |
| TAG WORD | `0001 1110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Declaration of the signature algorithm ID and public key of a self-issued Issuer |
| Hugo side | `meta/verification/issuer-key.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | raw value 1 WORD |  | `0x0001` ed25519 |
| 2 | `key` | #3 | remaining raw value (`0xFFFF`) |  |  |

Declares the public key of a self-issued (16 WORD) Issuer. Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ algorithm ID ‖ public key) ([16 WORD Issuer](../issuer.md#16-word-issuer)).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0101 LLLL      Codec 0x1E5L
[Length extension TAG]
Algorithm ID      1 WORD (0x0001 = Ed25519)
Public key        Width set by the algorithm (Ed25519 16 WORD)
```

- Codec: Meta `0x1E5L`, verification class
- Payload: raw value (algorithm ID + public key)
- Count: several allowed (key rotation)

## Interpretation and validity {#해석과-유효성}

- Being verification class, it is excluded from the content hash.
- 2 and 4 WORD Issuers use keys registered with geul.org, so it is not needed.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001E50/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E5000000000
BODY
#1 DECLARE 0x1E50
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 ENUM #2 0x0001
#5 BIND #1 "ISSUER-KEY"
#6 BIND #2 "algorithm"
#7 BIND #3 "key"
#8 BIND #4 "ed25519"
```
