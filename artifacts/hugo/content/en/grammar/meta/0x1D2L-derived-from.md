---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Records that this document derives from documents or materials of another lineage."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `DERIVED-FROM` (spec document BIND `DERIVED-FROM`) |
| TAG ID | `0x1D2L` |
| Codec ID | `0x00001D20` |
| Spec document | `0x00000000/codecs/0x00001D20/` (DECLARE target `1D20`) |
| Section | 14 `1110` (Meta), offset within section C = 2 |
| Kind | Meta · class: lineage |
| TAG WORD | `0001 1101 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Derived from a record or material of another lineage. To pin a specific version of external material, attach the source-text hash QUALIFIER (P4092) to the HEAD [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) (git submodule). |
| Hugo side | `meta/lineage/derived-from.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | record | `000F` all of Section 0 (wildcard, Reference), `020F` all of Section 1 (wildcard, Reference), `040F` all of Section 2 (wildcard, Reference), `07C0` SHA-256-DIGEST, `0740` URI-EVEN, `0750` URI-ODD |  |

Records that this document derives from documents or materials of another lineage.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[Length extension TAG]
Payload           A Reference, or SHA-256-DIGEST (content hash), or URI Value
```

- Codec: Meta `0x1D2L`, lineage class
- Payload: embedded Reference or Value
- Count: several allowed

## Interpretation and validity {#해석과-유효성}

- If derived from a GEUL document, give its content hash ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)); if from external material, give a [URI](../value/0x074L-uri.md). To pin an edition of external material by hash, attach the source-text hash QUALIFIER (P4092) to the HEAD [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처).
- Record-level origin is carried by the evidence Edge [SOURCE](../edge/0x0C0L-source.md); old records from before a move, split, or merge are carried by QUALIFIER P1365 (the value is the old Edge Id) on the target Edge.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001D20/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
