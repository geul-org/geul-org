---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declares the edition of the GEUL specification the document follows."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `SPEC-VERSION` (spec document BIND `SPEC-VERSION`) |
| TAG ID | `0x1C5L` |
| Codec ID | `0x00001C50` |
| Spec document | `0x00000000/codecs/0x00001C50/` (DECLARE target `1C50`) |
| Section | 14 `1110` (Meta), offset within section C = 5 |
| Kind | Meta · class: declaration |
| TAG WORD | `0001 1100 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The GEUL specification edition followed. The Payload itself is the shortest-width unsigned integer. v1 is `0x0001` (record `0x1C51 0x0001`) |
| Hugo side | `meta/declaration/spec-version.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | remaining raw value (`0xFFFF`) |  |  |

Declares the edition of the GEUL specification the document follows. This value determines how the remaining records are read.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[Length extension TAG]
Payload           Specification edition. v1 = 0x0001
```

- Codec: Meta `0x1C5L`, declaration class
- Payload: raw value (shortest-width unsigned integer)
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- It does not rely on Value codes. So that a decoder of any edition can read it, it holds a plain integer with no embedded Value.
- If the edition is unknown, the decoder rejects the document or warns.
- If absent, the decoder reads with the edition it knows. Published documents state it.

## Example {#예시}

- `0x1C51 0x0001`: GEUL v1

## Open issues {#열린-문제}

- Correspondence with the codebook document version ([spec document](../codec-spec.md)).

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001C50/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
