---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "In a diff (DELTA-BASE), records the LOCAL IDs (Edge Ids) of records to remove from the BODY of the base snapshot (“Article X deleted”)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `DELTA-REMOVE` (spec document BIND `DELTA-REMOVE`) |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| Spec document | `0x00000000/codecs/0x00001DC0/` (DECLARE target `1DC0`) |
| Section | 14 `1110` (Meta), offset within section C = 12 |
| Kind | Meta · class: lineage |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | In a diff, the list of LOCAL IDs (Edge Ids) to remove from the base BODY |
| Hugo side | `meta/lineage/delta-remove.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | remaining raw value (`0xFFFF`) |  |  |

In a diff ([DELTA-BASE](0x1DBL-delta-base.md)), records the LOCAL IDs (Edge Ids) of records to remove from the BODY of the base snapshot ("Article X deleted").

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[Length extension TAG]
LOCAL IDs to remove  LOCAL Reference record × 1 or more
```

- Codec: Meta `0x1DCL`, lineage class
- Payload: one or more [LOCAL](../reference/0x005L-local.md) Reference records
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- Place it only in a document that has `DELTA-BASE`.
- Each LOCAL ID must be an Edge Id present in the base snapshot BODY. Otherwise it is invalid. Listing the same ID twice is invalid.
- Placing the same Edge Id again in the BODY of the same diff is invalid (deletion and revision cannot be done together).
- A deleted LOCAL ID is not reassigned to another target in later versions ([revision](../document.md#개정)).
- A record absent from the diff BODY means "unchanged". So deletion is expressed only by this Meta.
- HEAD Edges (the document-wide [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) and its QUALIFIER) are not written. The HEAD is replaced wholesale by the diff's HEAD ([diff storage](../document.md#diff-저장)).

## Example {#예시}

Deleting LOCAL `#7` and `#12`:

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4` (Meta `0x1DCL`, `LLLL=0100`, 5 WORD), LOCAL References `0051 0007`, `0051 000C`.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001DC0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
