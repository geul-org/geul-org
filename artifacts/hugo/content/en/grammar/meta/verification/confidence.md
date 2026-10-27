---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE is a verification Meta that records the confidence of the whole document as a decimal Value from 0 to 1."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the confidence of the whole document. Confidence for an individual record is written as a QUALIFIER attached to the target Edge (the property is undecided, [SOURCE](/grammar/edge/source/#expressing-other-evidence)).

## Layout

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[Length extension TAG]
Payload           UNSIGNED-DECIMAL Value, from 0 to 1
```

- Codec: Meta `0x43`, verification class (`100`)
- Payload: embedded Value ([UNSIGNED-DECIMAL](/grammar/value/decimal/unsigned-decimal/))
- Count: at most one

## Interpretation and Validity

- Who assigned the value is written together with [GENERATED-BY](/grammar/meta/lineage/generated-by/) and the like.

## Open Questions

- The scale (0 to 1) and its relation to TOULMIN judgments.
