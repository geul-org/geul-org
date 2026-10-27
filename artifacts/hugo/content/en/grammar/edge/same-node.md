---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE is an undirected identity description Edge that declares that two References denote the same target (Codec 0x01)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE is an undirected identity description Edge that declares that two References denote the same referent. Codec `0x01`.

It does not mean that the byte encodings, Codecs, or IDs of the two Reference records are the same. Whereas [REFERENCE-NODE](/grammar/edge/reference-node/) is a directional binding of `Reference → record`, SAME-NODE expresses identity (referential identity) between two References.

## Layout

```
TAG WORD          0001 0LLL L000 0001
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           one Reference record
Object            one Reference record
```

## Interpretation and Validity

- Subject and Object are serialized in this order, and each must be exactly one complete [Reference](/grammar/reference/) record. Each finds its boundary by the Length of its record.
- If Subject or Object is a Value, an Edge, or an incomplete record, it is invalid.
- The SAME-NODE relation is reflexive, symmetric, and transitive. The Subject/Object order on the wire is for framing and creates no direction of meaning. An implementation must be able to traverse this relation in both directions.
- Different [LOCAL](/grammar/reference/local/) IDs are merely different References, and are not evidence that the referents are the same or different. That two References denote the same referent is stated with SAME-NODE.
- Interpretation and inference must keep the source, time, world, and policy scope of the document that holds the Edge and of the judgment graph. SAME-NODE is not used as grounds for a global merge regardless of context.
- Even with a SAME-NODE, the original Reference records and lineage are not erased or overwritten.
- If SAME-NODE and [DIFFERENT-NODE](/grammar/edge/different-node/) are both present on the same pair, the wire is not invalid. The context of each claim is kept and the conflict is evaluated.
- A Variable Reference is linked to an Identified Reference with SAME-NODE to resolve the variable ([Reference](/grammar/reference/), Variable).

## Length

```
total = 1 + N_len + N_id + N_subject + N_object WORDs
```

## Example (non-normative)

Edge Id `0009`, Subject is LOCAL 1, Object is LOCAL 2.

- The Edge is TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORDs, `LLLL=0110`. The TAG is `0001 0 0110 0000001` = `1301`.

```
1301 0088 0009 0088 0001 0088 0002
```

## Related Pages

- [Edge](/grammar/edge/), [REFERENCE-NODE](/grammar/edge/reference-node/), [DIFFERENT-NODE](/grammar/edge/different-node/)
- [Reference](/grammar/reference/), [LOCAL](/grammar/reference/local/)
