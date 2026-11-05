---
title: "REPLACES (0x1D7L)"
weight: 471
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Records the content hash of the version that was rewritten (git amend, rebase)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `REPLACES` (spec document BIND `REPLACES`) |
| TAG ID | `0x1D7L` |
| Codec ID | `0x00001D70` |
| Spec document | `0x00000000/codecs/0x00001D70/` (DECLARE target `1D70`) |
| Section | 14 `1110` (Meta), offset within section C = 7 |
| Kind | Meta · class: lineage |
| TAG WORD | `0001 1101 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The content hash of the version that was rewritten (git amend, rebase). The original version is not deleted. |
| Hugo side | `meta/lineage/replaces.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | record | `07C0` SHA-256-DIGEST |  |

Records the content hash of the version that was rewritten (git amend, rebase).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0111 LLLL      Codec 0x1D7L
[Length extension TAG]
Payload           One SHA-256-DIGEST Value (16 WORD)
```

- Codec: Meta `0x1D7L`, lineage class
- Payload: embedded Value ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Count: several allowed

## Interpretation and validity {#해석과-유효성}

- The original version is not deleted (the old law is preserved).
- The digest format is embedded as a Value, leaving room to change the hash algorithm. Currently the content hash is SHA-256 only.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001D70/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D7000000000
BODY
#1 DECLARE 0x1D70
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "REPLACES"
#4 BIND #2 "digest"
```
