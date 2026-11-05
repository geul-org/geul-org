---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Confirmation of the right to contribute (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `SIGNED-OFF` (spec document BIND `SIGNED-OFF`) |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| Spec document | `0x00000000/codecs/0x00001E70/` (DECLARE target `1E70`) |
| Section | 15 `1111` (Meta), offset within section C = 7 |
| Kind | Meta · class: verification |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Confirmation of the right to contribute. Reference (git `Signed-off-by`, DCO) |
| Hugo side | `meta/verification/signed-off.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | record | any record (except slot markers) |  |

Confirmation of the right to contribute (git `Signed-off-by`, DCO).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[Length extension TAG]
Payload           One Reference
```

- Codec: Meta `0x1E7L`, verification class
- Payload: embedded Reference
- Count: several allowed

## Interpretation and validity {#해석과-유효성}

- Documents published on geul.org carry no Reference that points at a natural person ([Issuer and publication](../issuer.md#geulorg-공표)). They point at an organization or Issuer. As an exception, pointing at a natural person with [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) is allowed.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001E70/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
