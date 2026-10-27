---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM is a lineage Meta that records the document or material of another lineage that this document was derived from."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records that this document was derived from a document or material of another lineage.

## Layout

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[Length extension TAG]
Payload           a Reference, or SHA-256-DIGEST (content hash), or a URI Value
```

- Codec: Meta `0x31`, lineage class (`011`)
- Payload: embedded Reference or Value
- Count: several allowed

## Interpretation and Validity

- If derived from a GEUL document, place its content hash ([SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/)); if from external material, place a [URI](/grammar/value/text/uri/). To pin the edition of external material by hash, attach a source hash QUALIFIER (P4092) to the HEAD [SOURCE](/grammar/edge/source/#source-of-the-whole-document).
- The source of an individual record is handled by the evidence Edge [SOURCE](/grammar/edge/source/), and the old record before a move, split, or merge by QUALIFIER P1365 on the target Edge (the value is the old Edge Id).
