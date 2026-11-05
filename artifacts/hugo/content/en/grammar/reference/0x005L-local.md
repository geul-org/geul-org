---
title: "LOCAL (0x005L~0x009L)"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL is a declaration Reference that points to a target by an ID issued by this document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `LOCAL` (a 5Q bundle. See the member table below for the name of each code) |
| TAG ID | `0x005L~0x009L` |
| Section | 0 `0000` (Reference entity), offset within section C = 5~9 |
| Kind | Reference · category: declaration |
| Hugo side | `reference/local.md` |

## Members {#구성원}

This page covers one 5Q set, five codes together. The quantification is the offset within the section, `C % 5` ([Reference](_index.md#quantifier)). There is one codec document per code. The fields of the five codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Quantification | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x005L` | `LOCAL-IDENTIFIED` | Identified | `0x00000050` | `0x00000000/codecs/0x00000050/` | `0000 0000 0101 LLLL` |
| `0x006L` | `LOCAL-GENERIC` | Generic | `0x00000060` | `0x00000000/codecs/0x00000060/` | `0000 0000 0110 LLLL` |
| `0x007L` | `LOCAL-FREE-CHOICE` | Free-choice | `0x00000070` | `0x00000000/codecs/0x00000070/` | `0000 0000 0111 LLLL` |
| `0x008L` | `LOCAL-UNIVERSAL` | Universal | `0x00000080` | `0x00000000/codecs/0x00000080/` | `0000 0000 1000 LLLL` |
| `0x009L` | `LOCAL-VARIABLE` | Variable | `0x00000090` | `0x00000000/codecs/0x00000090/` | `0000 0000 1001 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `local-id` | #2 | Remaining raw value (`0xFFFF`) |  |  |

LOCAL is a declaration Reference that points to a target by an ID issued by this document. It refers to a target inside the document without an external Issuer. To point to it from outside the document, place a Meta [DOC-ID](../meta/0x1C7L-doc-id.md) in the document, and have another document point to it with a pointer Reference.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0101 LLLL      Codec 0x005L~0x009L (Identified 0x005L)
[Length extension TAG]
LOCAL ID          unsigned big-endian in the shortest width
```

| LOCAL ID | Total | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0051` |
| `65536..2^32-1` | 3 WORD | `0x0052` |
| `2^32..2^48-1` | 4 WORD | `0x0053` |
| `2^48..2^64-1` | 5 WORD | `0x0054` |

- The Codec is `0x005L` (Identified), `0x006L` (Generic), `0x007L` (Free-choice), `0x008L` (Universal), or `0x009L` (Variable). The TAG WORD of Identified is `0000 0000 0101 LLLL`.
- It follows the common Reference rule of writing the target ID in the fewest WORDs.

## Edge Id {#edge-id}

- The LOCAL that is the first element of an Edge Payload is the Edge Id declaration of that Edge ([Edge](../edge/_index.md)). A LOCAL that declares an Edge Id uses only Identified (`0x005L`).
- A LOCAL in any other position of an Edge Payload is a mention. A target of this document is written as a LOCAL each time it is mentioned. There is no separate pointer code for pointing to a target of this document.

## ID allocation {#식별자-할당}

- An ID is an integer and the encoder assigns it. The magnitude of the number and the order of allocation mean nothing except identity.
- **UNIQUE (required).** In a document, one LOCAL ID points to only one target. An Edge Id is declared only once per document (HEAD Edges and BODY Edges share one number space). If two or more Edges declare the same Edge Id, the document is invalid.
- **AUTO INCREMENT (recommended).** Assign a new ID as the maximum of the IDs assigned so far in that document + 1, and let it grow in document order. The same holds across versions (a new one is created with a value larger than any deleted ID). This is only a recommendation, not a validity condition; a document that does not increase is also valid. The decoder does not rely on the magnitude or continuity of IDs.
- ID `0` is not assigned. It points to no target and is not used as an Edge Id. Target IDs are assigned from `1`.
- A document is pointed to, whether from inside that document or outside it, only by a single [DOC-POINTER](0x041L-doc-pointer.md) (the document itself is the DOC-POINTER of its own `DOC-ID`). `BIND`, `LABEL`, and judgment Edges can be attached to a document too.
- An Issuer itself is pointed to by [ISSUER-POINTER](0x040L-issuer-pointer.md). Document ID `0` is the term-definition index document of the Issuer.
- A Codec that gives meaning to `0` in a component slot (the "none" of [TOULMIN](../toulmin/_index.md) REF and execution Edges, the "whole document" of the Target of a HEAD [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)) follows that Codec's rule. This is a convention inside that Codec, different from a [slot marker](../slot-marker.md).
- An ID, once assigned, is not reused in the same document.
- Always use the minimum width that can express the value.

## Identity and scope {#동일성과-범위}

- In the same document, LOCAL IDs with the same integer value are the same target. The encoding width is not part of identity.
- An Identified LOCAL denotes an identified target. Do not use it as anonymous, unspecified, null, or a sentinel. To say that a value exists but is unknown (UNKNOWN-VALUE) or that there is no value (NO-VALUE), write it as a [slot marker](../slot-marker.md) in a field that accepts that marker.
- Different LOCAL IDs are merely different References; they do not mean the targets in reality are different.
- The identity of a LOCAL is not extended outside the document. The same number in another document is unrelated.
- A Variable (`0x009L`) LOCAL is a named discourse variable ([Reference](_index.md) Variable).

## Merging {#병합}

When merging several documents into one, make an `old ID → new ID` mapping table for each source document, reassign every LOCAL ID to an ID of the new document, and change all references.

- IDs that were the same in the same source document must remain the same after the merge.
- The same number in different source documents is unrelated, and is not automatically merged into the same Reference.
- If even one LOCAL could not be changed, the merge is rejected.

## Validity {#유효성}

The following encodings or allocations are invalid.

- A non-minimal encoding with a leading `0x0000` WORD (the 1 WORD `0x0000` for value 0 is an exception)
- A Codec in an Edge Id declaration slot that is not Identified (`0x005L`), or an ID of `0`
- One ID allocated to different targets in the same document
- The same Edge Id declared two or more times in the same document

## Examples {#예시}

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0051 0001` |
| 65535 | `0051 FFFF` |
| 65536 | `0052 0001 0000` |
| 4294967295 | `0052 FFFF FFFF` |
| 1, Variable | `0091 0001` |

## Related pages {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Edge](../edge/_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000050/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000005000000000
BODY
#1 DECLARE 0x0050
#2 FIELD #1 rest
#3 BIND #1 "LOCAL-IDENTIFIED"
#4 BIND #2 "local-id"
```

The above is the codec document of `LOCAL-IDENTIFIED` (`0x005L`). The codec documents of the other members (`LOCAL-GENERIC`, `LOCAL-FREE-CHOICE`, `LOCAL-UNIVERSAL`, `LOCAL-VARIABLE`) differ only in the codec ID of the DOC-ID, the DECLARE target, and the name bound in `#1` (BIND).
