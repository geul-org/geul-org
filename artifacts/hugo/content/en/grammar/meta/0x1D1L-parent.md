---
title: "PARENT (0x1D1L)"
weight: 465
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Records the content hash of the immediately preceding version (git parent)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `PARENT` (spec document BIND `PARENT`) |
| TAG ID | `0x1D1L` |
| Codec ID | `0x00001D10` |
| Spec document | `0x00000000/codecs/0x00001D10/` (DECLARE target `1D10`) |
| Section | 14 `1110` (Meta), offset within section C = 1 |
| Kind | Meta · class: lineage |
| TAG WORD | `0001 1101 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The content hash of the immediately preceding version (git parent). If absent, this is the first version; if several, it is a merge (git merge commit). |
| Hugo side | `meta/lineage/parent.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | record | `07C0` SHA-256-DIGEST |  |

Records the content hash of the immediately preceding version (git parent).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0001 LLLL      Codec 0x1D1L
[Length extension TAG]
Payload           One SHA-256-DIGEST Value (16 WORD)
```

- Codec: Meta `0x1D1L`, lineage class
- Payload: embedded Value ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Count: several allowed (merge)

## Interpretation and validity {#해석과-유효성}

- If absent, this is the first version; if several, it is a merge (git merge commit).
- It enters the [content hash](../document.md#내용-해시), so the whole history becomes a hash chain.
- A version-list document points at the preceding list document ([PUBLICATION](../edge/0x0B8L-publication.md)).
- The digest format is embedded as a Value, leaving room to change the hash algorithm. Currently the content hash is SHA-256 only.

## Example {#예시}

- `0x1D1E 0x0014 0x07CE 0x0012 <16 WORD>` (Meta 20 WORD = TAG + Length extension + embedded Value 18 WORD)

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001D10/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D1000000000
BODY
#1 DECLARE 0x1D10
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "PARENT"
#4 BIND #2 "digest"
```
