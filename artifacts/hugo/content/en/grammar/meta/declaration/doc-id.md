---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID is a declaration Meta that declares the identifier of the document as a DOC-POINTER (Issuer, document ID, version 0) that points to the document itself."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declares the identifier of this document. It is needed for other documents to point to this document and the targets inside it.

## Layout

```
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[Length extension TAG]
Document          DOC-POINTER Reference record. (Issuer, document ID, version 0)
```

- Codec: Meta `0x12`, declaration class (`001`)
- Payload: one embedded Reference [DOC-POINTER](/grammar/reference/doc-pointer/) (Issuer, document ID, version 0)
- Count: at most one. Required for documents whose name starts with `0x`

## Interpretation and Validity

- The Payload is exactly one `DOC-POINTER` (Issuer, document ID, version `0`) Reference record. Only `0` is used for the version ID. A version is assigned not by the document but by the version list. The Quantifier is `000`.
- So the notation that points to "this document" is the same in DOC-ID, in the [BIND](/grammar/edge/bind/) Subject of `documents.geul`, and in citations from other documents.
- The same document is the same `DOC-ID` regardless of version. The version ID and content hash are not written in the document ([Versions](/grammar/document/#versions)).
- The name for addressing is handled by the statement `BIND` in the name index `documents.geul` ([Publication Addresses and Version Lists](/grammar/publishing/#document-names)), and the human-readable title by the statement [LABEL](/grammar/edge/label/).
- Without it the document is unnamed and can be pointed to only by its content hash. It is needed for another document to point to a LOCAL of this document with a pointer Reference.
- The side that fetches a document verifies that the received document's `DOC-ID` equals the Issuer and document ID that were requested.
- Document ID `0x0000000000000000` is the Issuer's term definition index document ([Issuer](/grammar/issuer/)). Its name also starts with `0x`, so it carries a DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). The Issuer itself is represented by [ISSUER-POINTER](/grammar/reference/issuer-pointer/).
- Documents under `.well-known/geul/` whose names start with `0x` (version documents `<version ID>.geul`, specification documents) must have a `DOC-ID`.
- Documents whose names do not start with `0x` are exceptions and carry no `DOC-ID`: the version list `versions.geul` ([PUBLICATION](/grammar/edge/publication/)), the document name index `documents.geul`, and the Issuer name index `issuers.geul` ([Publication Addresses and Version Lists](/grammar/publishing/)). The content-hash store `h/` holds copies of the documents above and follows the originals.
- A Codec specification document is a document of the GEUL Issuer `0x0000`. Its document ID is the Kind and Codec TAG WORD widened to 4 WORDs (`0x1018` → `0x0000000000001018`). Reference `0000` is reserved, so it never becomes document ID `0` ([specification documents](/grammar/codec-spec/)).

## Example

- Issuer `0x0001`, document `0x…0005`: `1C12 03B8 0001 0000 0000 0000 0005 0000 0000` (Meta TAG 1 + Reference TAG 1 + Issuer 1 + document ID 4 + version 2 = 9 WORDs)
