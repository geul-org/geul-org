---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY is a 1 WORD structure Meta that ends the HEAD of a document and starts the BODY."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A record that ends the HEAD and starts the BODY.

## Layout

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[Length extension TAG]
```

- Codec: Meta `0x0E`, structure class (`000`)
- Payload: none (1 WORD)
- Count: at most one per document

## Interpretation and Validity

- Omitted if the HEAD is empty. A document with no `BODY` is all BODY. It is placed if the HEAD has any Meta or HEAD Edge (the [SOURCE](/grammar/edge/source/#source-of-the-whole-document) for the whole document and its QUALIFIERs).
- There is no Payload. The total is 1 WORD.

## Example

- `0x180E`
