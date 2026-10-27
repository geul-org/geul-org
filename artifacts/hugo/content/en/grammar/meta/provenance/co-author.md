---
title: "CO-AUTHOR"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CO-AUTHOR is a provenance Meta that records, as a Reference, a party that wrote the document together (git Co-authored-by)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records a party that wrote the document together (git `Co-authored-by`).

## Layout

```
TAG WORD          0001 1LLL L010 0001      Codec 0x21
[Length extension TAG]
Payload           one Reference record (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL, and so on)
```

- Codec: Meta `0x21`, provenance class (`010`)
- Payload: embedded Reference
- Count: several allowed

## Interpretation and Validity

- Reference does not discriminate by Codec. A person, an organization, a model, or a rule engine can all be authors ([EXTERNAL-ISSUER](/grammar/reference/external-issuer/), [GEUL](/grammar/reference/geul/), [WIKIDATA-QID](/grammar/reference/wikidata-qid/), [LOCAL](/grammar/reference/local/), and so on).
- A document published on geul.org does not carry a Reference that points to a natural person ([Issuer and Publication](/grammar/issuer/#publication-on-geulorg)). It points to an organization or Issuer. As an exception, pointing to a natural person with [WIKIDATA-QID](/grammar/reference/wikidata-qid/) is allowed.
- If it is a LOCAL, that target is described in the BODY.
