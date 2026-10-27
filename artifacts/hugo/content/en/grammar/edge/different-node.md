---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE is a non-identity description Edge saying that two References denote different targets (Codec 0x02)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE is a non-identity description Edge saying that two References denote different referents. Codec `0x02`.

It does not mean that the byte encodings, Codecs, or IDs of the two Reference records differ. Distinguish it from the directional binding of [REFERENCE-NODE](/grammar/edge/reference-node/) and the identity of [SAME-NODE](/grammar/edge/same-node/).

## Layout

```
TAG WORD          0001 0LLL L000 0010
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           one Reference record
Object            one Reference record
```

## Interpretation and Validity

- Subject and Object must each be exactly one complete [Reference](/grammar/reference/) record. Each finds its boundary by the Length of its record; if one is a Value or Edge, or is incomplete, it is invalid.
- Subject and Object denote different referents. That the referents differ is not inferred from a difference in the byte sequence, Codec, or ID of the Reference records.
- In particular, different [LOCAL](/grammar/reference/local/) IDs are merely different References; they do not mean that the real-world referents are different. DIFFERENT is not derived from a difference in LOCAL IDs alone.
- Non-identity is symmetric, irreflexive, and not transitive. `DIFFERENT(A, B)` is the same relation as `DIFFERENT(B, A)`. But `DIFFERENT(A, C)` is not inferred from `DIFFERENT(A, B)` and `DIFFERENT(B, C)`.
- The Subject/Object order on the wire is only a serialization order for framing and creates no direction of meaning. An implementation must be able to traverse in both directions.
- The cursor after reading both components must match the end of the Edge exactly.

The relation itself is irreflexive, but a structurally valid `DIFFERENT(A, A)` claim, or a claim where SAME and DIFFERENT collide, must not be erased as a wire grammar error. Such claims keep their context and lineage and are treated as contradictions in the judgment layer. When interpreting or deriving DIFFERENT, keep the source, time, world, and policy scope of the document that holds the Edge, and do not widen it into a global conclusion that ignores them.

## Length

```
total = 1 + N_len + N_id + N_subject + N_object WORDs
```

## Example (non-normative)

Edge Id `000a`, Subject is LOCAL 1, Object is LOCAL 2.

- The Edge is TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORDs, `LLLL=0110`. The TAG is `0001 0 0110 0000010` = `1302`.

```
1302 0088 000a 0088 0001 0088 0002
```

The difference of LOCAL IDs in this example is only to show the encoding. Make this sequence a DIFFERENT-NODE only when there is a separate claim that ID 1 and ID 2 denote different referents.

## Related Pages

- [Edge](/grammar/edge/), [REFERENCE-NODE](/grammar/edge/reference-node/), [SAME-NODE](/grammar/edge/same-node/)
- [Reference](/grammar/reference/), [LOCAL](/grammar/reference/local/)
