---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC is an IMPORT Meta that points to an external document with a DOC-POINTER and assigns it an IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Imports an external document under an IMPORT ID. The document to import is pointed to by a [DOC-POINTER](/grammar/reference/doc-pointer/), and the DOC-POINTER also carries the Issuer width.

## Layout

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[Length extension TAG]
Document          DOC-POINTER Reference record (Issuer, document ID, version ID. Version 0 means latest)
IMPORT ID         everything else. An unsigned integer in the shortest width
```

- Codec: Meta `0x60`, IMPORT class (`110`)
- Payload: embedded Reference `DOC-POINTER` (Issuer, document ID, version ID) + raw IMPORT ID value
- Count: several allowed (one per IMPORT ID)

## Interpretation and Validity

- The document is exactly one DOC-POINTER record. It ends at its own Length, and the rest is the IMPORT ID.
- The IMPORT ID is at least 1 WORD, in the shortest width. The width of the IMPORT ID is set here by the record length, and in [EXTERNAL-POINTER-*](/grammar/reference/external-pointer/) by the Codec. An IMPORT ID is valid only inside that document.
- The same IMPORT ID is not assigned twice in one document.
- If a version ID is written, it is bound to that edition; if `0`, to the latest edition at the time of interpretation (or the edition in force at a specified time) ([Revisions](/grammar/document/#revisions)).
- [EXTERNAL-POINTER-*](/grammar/reference/external-pointer/) in the BODY points to a LOCAL of the document imported by IMPORT ID. The imported document itself is pointed to with a DOC-POINTER.
- The HEAD of the imported document is not imported. Targets in that document are interpreted as that document declares.
- Documents cannot be searched across by IMPORT ID. A repository that loads several documents resolves an IMPORT ID to the full path (Issuer, document ID, version ID, LOCAL ID) and stores that.

## Example

- IMPORT ID 1, Issuer `0x0001`, document `0x…0002`, latest: `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (Meta TAG 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORDs)
