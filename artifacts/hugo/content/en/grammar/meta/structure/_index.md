---
title: "Meta — Structure"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "The Meta structure class (upper 3 bits `000`, `0x00`-`0x0F`) sets the boundaries and length of a document. A document is opened with DOC-1WORD/2WORD/4WORD, the HEAD is ended by BODY, and the document is closed by END."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The Meta structure class (upper 3 bits `000`, Codec `0x00`-`0x0F`) sets the boundaries and length of a document. The unit of GEUL data is one document.

```
DOC-*                  ← HEAD starts
  Declaration, provenance, lineage, verification, policy, IMPORT Meta
  SOURCE for the whole document and its QUALIFIERs
BODY                   ← BODY starts
  Reference, Value, Edge
END                    ← closes the document
```

- Every document is opened with `DOC-1WORD/2WORD/4WORD`, which gives the total length. A decoder can skip the whole document at once using this length.
- `BODY` and `END` are 1 WORD records with no Payload. `END` is required.
- Documents are not nested. Another document is pointed to with IMPORT.
- If the HEAD (Meta, and the SOURCE for the whole document with its QUALIFIERs) is empty, `BODY` is omitted. `BODY` may appear only once per document.

The full document structure is in [Document](/grammar/document/).
