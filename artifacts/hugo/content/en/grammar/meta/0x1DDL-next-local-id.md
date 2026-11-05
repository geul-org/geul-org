---
title: "NEXT-LOCAL-ID (0x1DDL)"
weight: 477
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Records the LOCAL ID that the next version of the document will assign to a new statement (a DBMS auto increment, MySQL AUTO_INCREMENT)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `NEXT-LOCAL-ID` (spec document BIND `NEXT-LOCAL-ID`) |
| TAG ID | `0x1DDL` |
| Codec ID | `0x00001DD0` |
| Spec document | `0x00000000/codecs/0x00001DD0/` (DECLARE target `1DD0`) |
| Section | 14 `1110` (Meta), offset within section C = 13 |
| Kind | Meta · class: lineage |
| TAG WORD | `0001 1101 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The LOCAL ID to assign next (auto increment). Placed in the HEAD of the version list `versions.geul` |
| Hugo side | `meta/lineage/next-local-id.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `next` | #2 | remaining raw value (`0xFFFF`) |  |  |

Records the LOCAL ID that the next version of the document will assign to a new statement (a DBMS auto increment, MySQL `AUTO_INCREMENT`). Every LOCAL ID assigned in any version of the document is smaller than this value.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1101 LLLL      Codec 0x1DDL
Payload           The LOCAL ID to assign next, as an unsigned integer of the shortest width
```

- Codec: Meta `0x1DDL`, lineage class
- Payload: raw value (unsigned integer of the shortest width)
- Count: at most one
- Where it goes: the HEAD of the version-list document `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md))

## Interpretation and validity {#해석과-유효성}

- A LOCAL ID (including an Edge Id) is an identity that persists across versions ([revision](../document.md#개정)). A new statement receives this value, and the value increases by 1. A deleted LOCAL ID is not reused. So even if the statement with the maximum value is deleted, this value does not decrease.
- LOCAL ID `0` is not assigned, so the initial value is `1`. If there is no version yet, this Meta is not placed and the next number is `1`.
- When the publisher publishes a version, it updates this value in the new list document. It must be greater than any LOCAL ID used in a published version. If it is smaller than or equal to that, it is invalid.
- The value only increases. If it is smaller than the value in the preceding list document ([PARENT](0x1D1L-parent.md)), it is invalid.
- Documents without version management (documents with no `versions.geul`, unnamed documents) do not have it. Such documents have no diff ([DELTA-BASE](0x1DBL-delta-base.md)) either.
- It is not placed in the document body (a version document). Remembering the number is the state of the publisher that continues the document, not document content (the git refs side, not a git commit).

## Example {#예시}

Next number to assign is 524:

```
1DD1 020C
```

- TAG `1DD1` (Meta `0x1DDL`, `LLLL=0001`, 2 WORD), Payload `020C`.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001DD0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DD000000000
BODY
#1 DECLARE 0x1DD0
#2 FIELD #1 rest
#3 BIND #1 "NEXT-LOCAL-ID"
#4 BIND #2 "next"
```
