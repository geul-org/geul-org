---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF is a verification Meta that records confirmation of the right to contribute as a Reference (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Confirmation of the right to contribute (git `Signed-off-by`, DCO).

## Layout

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[Length extension TAG]
Payload           one Reference
```

- Codec: Meta `0x42`, verification class (`100`)
- Payload: embedded Reference
- Count: several allowed

## Interpretation and Validity

- A document published on geul.org does not carry a Reference that points to a natural person ([Issuer and Publication](/grammar/issuer/#publication-on-geulorg)). It points to an organization or Issuer. As an exception, pointing to a natural person with [WIKIDATA-QID](/grammar/reference/wikidata-qid/) is allowed.
