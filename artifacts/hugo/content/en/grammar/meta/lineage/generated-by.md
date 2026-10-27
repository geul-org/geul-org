---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY is a lineage Meta that records the party that made the document (person, model, rule engine) and its version."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the party that made the document. It can be a person, a model, or a rule engine.

## Layout

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[Length extension TAG]
Generator         Reference (person, model, rule engine)
Version           UTF8-TEXT Value, or the omission marker 0x0000 (optional field)
```

- Codec: Meta `0x32`, lineage class (`011`)
- Payload: embedded Reference + version text (optional)
- Count: several allowed

## Interpretation and Validity

- For a model, write the model version too.
- If the version is unknown or not given, omit that position and write ABSENT (`0x0000`) ([CODEC](/grammar/edge/codec/) optional field). The geul.org specification `0x1832` has two record fields: agent (no CODEC) and version (`0840`, `0841`, `0000`).
- For the source version (commit) of a program, the format of [TRANSFORMED-BY](/grammar/meta/lineage/transformed-by/) (digest, required) is more accurate. The version in GENERATED-BY is for things that are not commit IDs, such as a model name and version, written as text.
- A document published on geul.org does not carry a Reference that points to a natural person ([Issuer and Publication](/grammar/issuer/#publication-on-geulorg)). It points to an organization or Issuer. As an exception, pointing to a natural person with [WIKIDATA-QID](/grammar/reference/wikidata-qid/) is allowed.
