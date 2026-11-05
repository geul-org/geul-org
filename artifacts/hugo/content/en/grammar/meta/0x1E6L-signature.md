---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "A signature over the content hash of the document (git signed commits and tags)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `SIGNATURE` (spec document BIND `SIGNATURE`) |
| TAG ID | `0x1E6L` |
| Codec ID | `0x00001E60` |
| Spec document | `0x00000000/codecs/0x00001E60/` (DECLARE target `1E60`) |
| Section | 15 `1111` (Meta), offset within section C = 6 |
| Kind | Meta · class: verification |
| TAG WORD | `0001 1110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | A signature over a target. A signature over a document signs its content hash (git signed commits and tags) |
| Hugo side | `meta/verification/signature.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | raw value 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | record | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | remaining raw value (`0xFFFF`) |  |  |

A signature over the content hash of the document (git signed commits and tags).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[Length extension TAG]
Algorithm ID      1 WORD (0x0001 = Ed25519)
Signer            ISSUER-POINTER (Issuer) Reference record
Signature         Everything that remains. The width is set by the algorithm (Ed25519 32 WORD)
```

- Codec: Meta `0x1E6L`, verification class
- Payload: algorithm ID (raw value 1 WORD) + signer (embedded Reference) + signature (raw value, remainder)
- Count: several allowed

## Interpretation and validity {#해석과-유효성}

- The signed target is the content hash. The BODY alone is not signed ([signature](../issuer.md#서명)).
- Being verification class, it is excluded from the content hash. Adding a signature leaves the hash unchanged.
- Verify not as "check if a signature exists" but as "a signature by the designated key must exist".
- The publisher signs the version-list document.
- The signer is an [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) (Issuer) pointing at the Issuer itself. As a Reference record it ends with its own Length, so the layout is fixed even though the signature width varies by algorithm ([DECLARE](../edge/0x0BBL-declare.md) remaining field).
- If the WORD count of the signature differs from the width set by the algorithm, it is invalid.

## Open issues {#열린-문제}

- Whether to sign the signing time as well.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001E60/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
