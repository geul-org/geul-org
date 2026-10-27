---
title: "GEUL-SIDX"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX is a declaration Reference that points to a target with a GEUL SIDX (Semantic-aligned Index), an identifier that carries meaning in its bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL-SIDX is a declaration Reference that points to a target with a GEUL SIDX (Semantic-aligned Index). A SIDX is an identifier that carries meaning (kind, attributes) in the bits themselves.

## Layout

```
TAG WORD          0000 0LLL L001 1QQQ      CCCC = 0011
[Length extension TAG]
SIDX              everything that remains
```

- The Quantifier is the same as in other declaration Codecs. A Variable is an anonymous variable of that kind ([Reference](/grammar/reference/), Variable). Quantification is done only with `QQQ`. No quantification is put into the SIDX value.
- The specification document declares the SIDX as a single remaining-width raw-value field. This will be changed once the width rule is decided.

## Example

| SIDX | WORD sequence |
|---|---|
| (non-normative) 64-bit `0x1234 5678 9abc def0`, Identified | `0218 1234 5678 9abc def0` |

## Assignment Policy

- Its role differs from [GEUL](/grammar/reference/geul/). GEUL is an identity ID assigned mostly in order (auto increment), while GEUL-SIDX is a semantic address that gives close values to semantically close targets.
- How close is decided statistically, by accumulating usage data. Until the statistics are gathered, use GEUL IDs; after a SIDX is assigned, link the GEUL and GEUL-SIDX of the same target with [SAME-NODE](/grammar/edge/same-node/).

## Open Questions

- **Width.** To be decided by looking at the statistics. 4 WORD (64 bits), 16 WORD, and others are under consideration. A SIDX carries meaning in its upper bits, so the "shortest width" rule of other declaration Codecs (no leading `0x0000`) cannot be used as is. So it will be a fixed width (or a fixed width per subtype). Until it is decided, the specification document declares the SIDX as a remaining-width raw value.
- **Stability of assignment.** In Reference, the same integer value is the same target, and an assigned ID is not reused. To avoid moving an already assigned SIDX when the statistics change, append-only assignment (sparse assignment that leaves room near semantically close ones) is needed. If moves would be frequent, decide whether to define a SIDX not as a permanent identifier but as an index tied to a registry edition.
- **Uniqueness.** If a SIDX is generated from bit meanings and can collide, it does not fit the premise that "the same integer value is the same target". Resolve collisions at assignment to guarantee uniqueness.
- The codebook and the public format of the registry.

## Related Pages

- [Reference](/grammar/reference/), [GEUL](/grammar/reference/geul/)
