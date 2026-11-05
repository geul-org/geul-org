---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Records an immutable name given to a version (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `TAG` (spec document BIND `TAG`) |
| TAG ID | `0x1DAL` |
| Codec ID | `0x00001DA0` |
| Spec document | `0x00000000/codecs/0x00001DA0/` (DECLARE target `1DA0`) |
| Section | 14 `1110` (Meta), offset within section C = 10 |
| Kind | Meta · class: lineage |
| TAG WORD | `0001 1101 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | An immutable name given to a version. A TEXT Value and a content hash (git annotated tag) |
| Hugo side | `meta/lineage/tag.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | record | `07C0` SHA-256-DIGEST, `0000` ABSENT (optional field) |  |

Records an immutable name given to a version (git annotated tag).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[Length extension TAG]
Name              UTF8-TEXT-* Value
Target            SHA-256-DIGEST Value, or the omission marker 0x0000 (optional field). If omitted, this version
```

- Codec: Meta `0x1DAL`, lineage class
- Payload: embedded Value (text + optional content hash)
- Count: several allowed

## Interpretation and validity {#해석과-유효성}

- The name is [UTF8-TEXT](../value/0x072L-utf8-text.md) and the target is [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md).
- If the target is omitted (ABSENT `0x0000`, [CODEC](../edge/0x0BEL-codec.md) optional field), the name is attached to this document itself. A document cannot write its own content hash inside itself. The geul.org spec `0x1DA0` is a two-record-field spec: name (`0720`, `0730`) and target (`07C0`, `0000`).
- Do not reuse the same name for another version.

## Example {#예시}

- Name `v1`, this version: `1DA3 0721 7631 0000`

## Open issues {#열린-문제}

- Whether TAG is needed at all when version IDs (sequence numbers) exist.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001DA0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
