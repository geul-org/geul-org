---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE is an undirected identity statement Edge that declares two References point to the same referent."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `SAME-NODE` (specification document BIND `SAME-NODE`) |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| Specification document | `0x00000000/codecs/0x00000A10/` (DECLARE target `0A10`) |
| Section | 5 `0101` (Edge statement), offset within section C = 1 |
| Kind | Edge · family: statement, group: pointing and names |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | An identity in which two References point to the same target |
| Hugo side | `edge/same-node.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | Any record (excluding slot markers) |  |
| 2 | `object` | #3 | record | Any record (excluding slot markers) |  |

SAME-NODE is an undirected identity statement Edge that declares two References point to the same referent. Codec `0x0A1L`.

It does not mean that the byte encodings, Codecs, or IDs of the two Reference records are equal. Whereas [REFERENCE-NODE](0x0A0L-reference-node.md) is a directional binding `Reference → record`, SAME-NODE expresses identity (referential identity) between two References.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           1 Reference record
Object            1 Reference record
```

## Interpretation and validity {#해석과-유효성}

- Subject and Object are serialized in this order, and each must be exactly one complete [Reference](../reference/_index.md) record. Boundaries are found by each record's Length.
- If Subject or Object is a Value, an Edge, or an incomplete record, it is invalid.
- The SAME-NODE relation is reflexive, symmetric, and transitive. The Subject/Object order on the wire is for framing and creates no semantic direction. An implementation must be able to traverse this relation in both directions.
- Different [LOCAL](../reference/0x005L-local.md) IDs are merely different References, not evidence that the referents are the same or different. That two References point to the same referent is stated by SAME-NODE.
- Interpretation and inference must preserve the provenance, time, world, and policy scope of the document containing the Edge and of the verdict graph. SAME-NODE is not used as grounds for a global merge independent of context.
- Even where SAME-NODE exists, the original Reference records and their lineage are not erased or overwritten.
- The wire is not invalid merely because SAME-NODE and [DIFFERENT-NODE](0x0A2L-different-node.md) both exist for the same pair. The context of each claim is preserved and the pair is evaluated as a conflict.
- A Variable Reference is resolved by linking it to an Identified Reference with SAME-NODE ([Reference](../reference/_index.md) Variable).

## Length {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Example (non-normative) {#예시-비규범}

Edge Id `0009`, Subject is LOCAL 1, and Object is LOCAL 2.

- The Edge is TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORDs, `LLLL=0110`. The TAG is `0000 1010 0001 0110` = `0A16`.

```
0A16 0051 0009 0051 0001 0051 0002
```

## Related pages {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000A10/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
