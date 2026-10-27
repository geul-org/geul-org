---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD, and DOC-4WORD are structure Meta that open a document by giving the total WORD count of the document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A record that opens a document. It gives the total WORD count of the document in its Payload. `DOC-1WORD` (`0x00`), `DOC-2WORD` (`0x01`), and `DOC-4WORD` (`0x02`) are covered together on this page.

## Layout

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[Length extension TAG]
Payload           total WORD count. The Codec sets the width: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x00`-`0x02`, structure class (`000`)
- Payload: raw value (total WORD count of the document, unsigned)
- Count: one per document, at the very front

## Interpretation and Validity

- The length runs from the start of the opening record to the end of [END](/grammar/meta/structure/end/).
- Use the narrowest width that holds the value. Encoding in a wider width is a non-canonical encoding and is rejected.
- The length must equal the whole input. One document is one input.
- A decoder can skip the whole document using this length. There is no Codec that opens a document without knowing its length.
- When calculating the content hash, rewrite it with the length excluding verification-class Meta and the width that fits it ([Content Hash](/grammar/document/#content-hash)).

## Example

- `0x1880 0x0017`: DOC-1WORD, 23 WORDs in total
