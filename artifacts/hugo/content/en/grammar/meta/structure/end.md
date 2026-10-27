---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END is a 1 WORD structure Meta that closes a document. It is required in every document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A record that closes the document.

## Layout

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[Length extension TAG]
```

- Codec: Meta `0x0F`, structure class (`000`)
- Payload: none (1 WORD)
- Count: one per document, at the very end

## Interpretation and Validity

- Required. Its position is checked with the length in [DOC](/grammar/meta/structure/doc/) (`DOC-*`).
- If the input ends without END, the document is truncated. Whether to treat the content of a truncated document as valid is a decoder policy.
- Nothing follows it.

## Example

- `0x180F`
