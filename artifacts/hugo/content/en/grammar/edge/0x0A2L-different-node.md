---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE is a non-identity statement Edge stating that two References point to different referents."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `DIFFERENT-NODE` (specification document BIND `DIFFERENT-NODE`) |
| TAG ID | `0x0A2L` |
| Codec ID | `0x00000A20` |
| Specification document | `0x00000000/codecs/0x00000A20/` (DECLARE target `0A20`) |
| Section | 5 `0101` (Edge statement), offset within section C = 2 |
| Kind | Edge · family: statement, group: pointing and names |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | A non-identity in which two References point to different targets |
| Hugo side | `edge/different-node.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | Any record (excluding slot markers) |  |
| 2 | `object` | #3 | record | Any record (excluding slot markers) |  |

DIFFERENT-NODE is a non-identity statement Edge stating that two References point to different referents. Codec `0x0A2L`.

It does not mean that the byte encodings, Codecs, or IDs of the two Reference records differ. Distinguish it from the directional binding of [REFERENCE-NODE](0x0A0L-reference-node.md) and the identity of [SAME-NODE](0x0A1L-same-node.md).

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0010 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           1 Reference record
Object            1 Reference record
```

## Interpretation and validity {#해석과-유효성}

- Subject and Object must each be exactly one complete [Reference](../reference/_index.md) record. Boundaries are found by each record's Length; if either is a Value or an Edge, or is incomplete, it is invalid.
- Subject and Object point to different referents. A difference in the byte sequence, Codec, or ID of the Reference records alone does not allow inferring that the referents differ.
- In particular, different [LOCAL](../reference/0x005L-local.md) IDs are merely different References and do not mean that the referents in reality differ. DIFFERENT is not derived from a difference in LOCAL IDs alone.
- Non-identity is symmetric, irreflexive, and not transitive. `DIFFERENT(A, B)` is the same relation as `DIFFERENT(B, A)`. However, `DIFFERENT(A, C)` is not inferred from `DIFFERENT(A, B)` and `DIFFERENT(B, C)`.
- The Subject/Object order on the wire is only a serialization order for framing and creates no semantic direction. An implementation must be able to traverse in both directions.
- The cursor after reading both components must coincide exactly with the end of the Edge.

Although the relation itself is irreflexive, a structurally valid claim `DIFFERENT(A, A)`, or a claim where SAME and DIFFERENT collide, must not be erased as a wire grammar error. Such a claim preserves its context and lineage and is handled as a contradiction in the verdict layer. When interpreting or deriving DIFFERENT, preserve the provenance, time, world, and policy scope of the document containing the Edge, and do not broaden it into a global conclusion that ignores them.

## Length {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Example (non-normative) {#예시-비규범}

Edge Id `000A`, Subject is LOCAL 1, and Object is LOCAL 2.

- The Edge is TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORDs, `LLLL=0110`. The TAG is `0000 1010 0010 0110` = `0A26`.

```
0A26 0051 000A 0051 0001 0051 0002
```

The difference in LOCAL IDs in this example is only to show the encoding. Make this sequence a DIFFERENT-NODE only when there is a separate claim that ID 1 and ID 2 point to different referents.

## Related pages {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000A20/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
