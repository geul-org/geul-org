---
title: "LOCAL"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL is a declaration Reference that points to a target by an ID issued by this document. An Edge Id is also a LOCAL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LOCAL is a declaration Reference that points to a target by an ID issued by this document. It refers to targets inside the document without an external Issuer and has no meaning outside the document. To point to a target from outside the document, put the Meta [DOC-ID](/grammar/meta/declaration/doc-id/) in the document and have another document point to it with a pointer Reference.

## Layout

```
TAG WORD          0000 0LLL L000 1QQQ      CCCC = 0001
[Length extension TAG]
LOCAL ID          unsigned big-endian in the shortest width
```

| LOCAL ID | Total | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0088` |
| `65536..2^32-1` | 3 WORD | `0x0108` |
| `2^32..2^48-1` | 4 WORD | `0x0188` |
| `2^48..2^64-1` | 5 WORD | `0x0208` |

- The TAG WORD is `0000 0 LLLL 0001 QQQ`. For Identified (`000`), the lower 7 bits are `0x08`.
- It follows the common Reference rule of writing the target ID in the fewest WORDs.

## Edge Id

- The LOCAL that is the first element of an Edge Payload is the declaration of that Edge's Edge Id ([Edge](/grammar/edge/)). The Quantifier of a LOCAL that declares an Edge Id is only `000`.
- A LOCAL in any other position of an Edge Payload is a mention. A target of this document is written as a LOCAL each time it is mentioned. There is no separate pointer code for a target of this document.

## ID Assignment

- An ID is an integer assigned by the encoder. The size of the number and the order of assignment mean nothing except identity.
- **UNIQUE (required).** Within one document, a LOCAL ID points to only one target. An Edge Id is declared only once per document (HEAD Edges and BODY Edges share one number space). If two or more Edges declare the same Edge Id, it is invalid.
- **AUTO INCREMENT (recommended).** A new ID is assigned as the maximum ID assigned so far in that document plus 1, so that IDs grow in document order. This holds across versions too (new IDs are created above any deleted ID). It is only a recommendation, not a validity condition, and a document whose IDs do not increase is still valid. A decoder does not rely on the size or continuity of IDs.
- ID `0` is not assigned. It points to no target and is not used as an Edge Id. Target IDs are assigned from `1`.
- A document is pointed to only by a [DOC-POINTER](/grammar/reference/doc-pointer/), whether from inside or outside that document (a document points to itself with the DOC-POINTER of its own `DOC-ID`). `BIND`, `LABEL`, and judgment Edges can be attached to a document too.
- An Issuer itself is pointed to by an [ISSUER-POINTER](/grammar/reference/issuer-pointer/). Document ID `0` is the Issuer's term definition index document.
- For Codecs that give meaning to `0` in a component position ("none" in [TOULMIN](/grammar/edge/toulmin/) REF and execution Edges, "the whole document" in the Target of a HEAD [SOURCE](/grammar/edge/source/#source-of-the-whole-document)), that Codec's rules apply. This is a convention inside that Codec, different from a [slot marker](/grammar/reference/slot-marker/).
- An ID, once assigned, is not reused in the same document.
- Always use the minimum width that can represent the value.

## Identity and Scope

- Within the same document, LOCAL IDs with the same integer value are the same target. The encoding width is not part of identity.
- An Identified LOCAL represents an identified target. It is not used as anonymous, unspecified, null, or sentinel. To say that a value exists but is unknown (UNKNOWN-VALUE) or that there is no value (NO-VALUE), write a [slot marker](/grammar/reference/slot-marker/) in a field that accepts that marker.
- Different LOCAL IDs are merely different References; they do not mean that the real-world targets are different.
- The identity of a LOCAL is not extended outside the document. The same number in another document is unrelated.
- A Variable (`100`) LOCAL is a named discourse variable ([Reference](/grammar/reference/), Variable).

## Merging

When merging several documents into one, make an `old ID → new ID` table for each source document, reassign every LOCAL ID to an ID in the new document, and replace all references.

- IDs that were the same in one source document must still be the same after merging.
- The same number in different source documents is unrelated and is not automatically merged into the same Reference.
- If even one LOCAL could not be replaced, the merge is rejected.

## Validity

The following encodings and assignments are invalid.

- A non-minimal encoding with a leading `0x0000` WORD (the 1 WORD `0x0000` for the value 0 is an exception)
- A Quantifier other than `000`, or an ID of `0`, in an Edge Id declaration position
- Assigning one ID to different targets in the same document
- Declaring the same Edge Id two or more times in the same document

## Examples

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0088 0001` |
| 65535 | `0088 ffff` |
| 65536 | `0108 0001 0000` |
| 4294967295 | `0108 ffff ffff` |
| 1, Variable | `008C 0001` |

## Related Pages

- [Reference](/grammar/reference/), [DOC-POINTER](/grammar/reference/doc-pointer/), [ISSUER-POINTER](/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/grammar/reference/external-pointer/)
- [Edge](/grammar/edge/)
