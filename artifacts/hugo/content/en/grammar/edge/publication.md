---
title: "PUBLICATION"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION, and TOMBSTONE are description Edges that record the publication, deprecation advisory, and deletion of document versions, and this page also sets the specification of the version list document written with them (Codec 0x18-0x1A)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Description Edges that record the publication, deprecation, and deletion of documents, and the specification of the version list document written with those Edges. It sets the version list format of [Publication Addresses and Version Lists](/grammar/publishing/#version-lists).

## Codes

| Codec | Name | Payload |
|---|---|---|
| `0x18` | PUBLICATION | Edge Id, DOC-POINTER, content hash |
| `0x19` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x1A` | TOMBSTONE | Edge Id, DOC-POINTER, reason category |

- The three codes are built into the decoder ([Layer 0](/grammar/publishing/#layers)). A version list is interpreted without consulting a codebook.
- No subformat (Codec-specific TAG) is used. The [Edge](/grammar/edge/) rule that the first element of the Payload is the Edge Id is kept as it is.

## Layout

```
TAG WORD          Edge, Codec 0x18 / 0x19 / 0x1A
[Length extension TAG]
Edge Id           LOCAL Reference record
Document          DOC-POINTER Reference record (Issuer, document ID, version ID)
Content hash      16 WORD   (PUBLICATION)
Reason category   1 WORD    (TOMBSTONE)
```

| Field | Width | Description |
|---|---|---|
| Edge Id | LOCAL Reference record | Sequence number within the list. Numbered from 1 and appended |
| Document | DOC-POINTER record | One version of the published document ([DOC-POINTER](/grammar/reference/doc-pointer/)). The Issuer and document ID are the same as the document the list covers. This lets the list document say what it is a list of even without a path. The version ID is the sequence number within that document ([Document](/grammar/document/), Versions), and `0` (latest) is not used |
| Content hash | 16 WORD | The content hash of that version (SHA-256, [Document](/grammar/document/), Content Hash) |
| Reason category | 1 WORD | The category code of the reason for deletion. The code table is an open question |

- The length after the DOC-POINTER is fixed per code (16, 0, 1 WORD). If it differs, reject.
- No time is placed in the record. The `RECORDED-AT` of the list document in which the record first appeared is the time of publication, deprecation, or deletion.

## Version List Document

The publisher keeps appending to one version list document per document: `/<Issuer>/<document ID>/versions.geul`. All versions of that document published by that publisher go into one list.

```
DOC-1WORD/2WORD/4WORD     total length
  SPEC-VERSION            0x0001 (v1)
  PARENT                  SHA-256-DIGEST Value. Content hash of the previous list document (none for the first list)
  RECORDED-AT             POSIX-TIMESTAMP-SECONDS Value. The time this list was issued
  NEXT-LOCAL-ID           the next LOCAL ID to assign (if there are versions)
  SIGNATURE               the publisher's signature. The target is the content hash of this list document
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE · BIND …
END
```

- HEAD Meta: [SPEC-VERSION](/grammar/meta/declaration/spec-version/), [PARENT](/grammar/meta/lineage/parent/), [RECORDED-AT](/grammar/meta/provenance/recorded-at/), [NEXT-LOCAL-ID](/grammar/meta/lineage/next-local-id/), [SIGNATURE](/grammar/meta/verification/signature/).
- A list document carries no `DOC-ID` (an exception for documents whose names do not start with `0x`, [DOC-ID](/grammar/meta/declaration/doc-id/)). A list is not a published document but a record that belongs to one. Which document it is a list of is stated by the document ID in the records. So even when received without a path (`h/`, a dump), it is known what the list is of.
- The document IDs in the records must all be the document the list covers. A record for another document is rejected.
- A list document carries no IMPORT and uses only Layer 0 Codecs. It is not placed in another list (no list of lists).
- A new list document keeps the BODY of the previous list document as it is at the front and appends records. It does not modify, delete, or reorder.
- The publisher signs the list. For geul.org publication, geul.org (the GEUL Issuer) signs; for private publication, that Issuer signs.
- Document ID `0x0000000000000000` is the Issuer's term definition index document ([Issuer and Publication](/grammar/issuer/)). The Issuer itself is pointed to with an [ISSUER-POINTER](/grammar/reference/issuer-pointer/).

## Rules

- The version IDs of PUBLICATION ascend from 1 with no gaps. The publisher assigns version IDs.
- The same content hash is not published again. If it already exists, its version ID is returned.
- DEPRECATION and TOMBSTONE point only to the version ID of an earlier PUBLICATION. Pointing to a nonexistent version is rejected.
- The state of a version is calculated by applying the records in order: published → deprecated → deleted. A deleted version is neither published again nor served.
- The latest version is the highest version ID that is neither deprecated nor deleted.
- When the version ID reaches the end of 2 WORDs, that document is not published further and is issued under a new document ID.

## Document Names

The name for addressing a document is bound by the Issuer's name index `/<Issuer>/documents.geul` with [BIND](/grammar/edge/bind/) ([Publication Addresses and Version Lists](/grammar/publishing/#document-names)). The resolver reads only this index.

The same BIND can also be placed in a list document (optional). If placed, observe the following.

- Subject is `DOC-POINTER` (Issuer, the document ID of that list, version `0`). The name is bound to the document, not to a version, so the version is `0`.
- It is bound only to a document for which a PUBLICATION appeared earlier. A name is not bound to a document that was never published.
- The name follows the document name rules (lowercase ASCII slug) and must equal the BIND in the name index.
- To change the name, append a new BIND. The old name stays and points to the same document. The representative name is the last BIND.
- The document does not write its own name inside itself.

## Addresses

```
/.well-known/geul/<Issuer>/<document ID>/versions.geul             latest list document (mutable)
/.well-known/geul/h/<content hash>.geul                            past list documents (immutable)
```

- The only mutable thing is the latest list address. A received list is verified by the signature, `RECORDED-AT`, and the `PARENT` chain.
- Every past list document is kept in `h/`. By following the `PARENT` chain, the list at any point in time can be traced back.

## Verification

- The list document must have a `SIGNATURE` by the designated publisher key.
- The document ID in the records must equal the requested document ID.
- The content hash of the previous list left in the lock record must be in the `PARENT` chain of the new list. The BODY of that list must equal the front part of the new list's BODY.
- The content hash of a received document must equal the value written by the PUBLICATION of that version ID, and the document's `DOC-ID` must equal the requested Issuer and document ID.

## Open Questions

- The reason category code table.
- The default signature algorithm and the `SIGNATURE` Payload layout.
- When and in what format to move to a Merkle log (inclusion and consistency proofs) as lists grow.
- Whether to merge the list's BIND and the name index `documents.geul` into one, and the index's signature.
- Rollback protection per Issuer. Since lists form a separate chain per document, an attack that presents an old list for only one document is blocked only by that document's chain.

## Related Pages

- [Edge](/grammar/edge/), [BIND](/grammar/edge/bind/), [DOC-POINTER](/grammar/reference/doc-pointer/)
- [Issuer and Publication](/grammar/issuer/), [Publication Addresses and Version Lists](/grammar/publishing/), [Document](/grammar/document/)
