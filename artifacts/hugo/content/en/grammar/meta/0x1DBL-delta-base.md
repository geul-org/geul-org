---
title: "DELTA-BASE (0x1DBL)"
weight: 475
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "A marker that this version file is not a snapshot but a diff against a base version of the same document (delta in a git packfile)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `DELTA-BASE` (spec document BIND `DELTA-BASE`) |
| TAG ID | `0x1DBL` |
| Codec ID | `0x00001DB0` |
| Spec document | `0x00000000/codecs/0x00001DB0/` (DECLARE target `1DB0`) |
| Section | 14 `1110` (Meta), offset within section C = 11 |
| Kind | Meta · class: lineage |
| TAG WORD | `0001 1101 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | This version file is a diff against a base version (2 WORD version ID) of the same document (git packfile delta) |
| Hugo side | `meta/lineage/delta-base.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | raw value 2 WORD | `0620` UNSIGNED-INTEGER |  |

A marker that this version file is not a snapshot but a **diff** against a base version of the same document (delta in a git packfile). The version itself is still defined as a snapshot. The content hash, the version list, and signatures are all based on the snapshot restored by applying the diff ([diff storage](../document.md#diff-저장)).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1011 LLLL      Codec 0x1DBL
Version ID        2 WORD unsigned (base version of the same document)
```

- Codec: Meta `0x1DBL`, lineage class
- Payload: 2 WORD version ID (raw value)
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- Use it only on documents that have a [DOC-ID](0x1C7L-doc-id.md). The version list `versions.geul`, list documents (versions of `issuers/`), and unnamed documents, which carry no `DOC-ID`, have no diff.
- The base version is a published version of the same `DOC-ID` and precedes this version. `0` (no version) is invalid.
- The content hash of the restored snapshot must equal the hash of this version in the version list ([PUBLICATION](../edge/0x0B8L-publication.md)). If it differs, this diff is invalid. So the resulting hash is not written separately inside the diff.
- Only a document whose BODY records are all Edges (records with an Edge Id) can be kept as a diff, because the diff unit is the LOCAL ID (Edge Id).
- The snapshot restoration rules follow [diff storage](../document.md#diff-저장). Deletion is carried by [DELTA-REMOVE](0x1DCL-delta-remove.md).
- There is no separate addition or revision marker. If the Edge Id in the diff BODY exists in the base, it is a revision; if not, an addition. An addition receives its number from [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) of the version list. Reusing a deleted LOCAL ID is invalid ([revision](../document.md#개정)).

## Example {#예시}

A diff against base version 3:

```
1DB2 0000 0003
```

- TAG `1DB2` (Meta `0x1DBL`, `LLLL=0010`, 3 WORD), version ID `0000 0003`.

## Open issues {#열린-문제}

1. Snapshot interval: how many versions apart to keep a full snapshot (diff chain length versus restoration cost).
2. Whether to restrict the base version to the immediately preceding version.
3. Where to store diff files: in the version file slot (`<version ID>.geul`), and the relation to the content-hash address `<Issuer>/hashes/` (`hashes/` is looked up by the content hash of the snapshot).

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001DB0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DB000000000
BODY
#1 DECLARE 0x1DB0
#2 FIELD #1 0x0002
#3 BIND #1 "DELTA-BASE"
#4 BIND #2 "version"
#5 CODEC #2 0x0620
```
