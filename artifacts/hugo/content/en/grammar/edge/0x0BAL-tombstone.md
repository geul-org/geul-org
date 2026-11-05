---
title: "TOMBSTONE (0x0BAL)"
weight: 186
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION, and TOMBSTONE are statement Edges that record the publication, deprecation advisory, and deletion of a document version, and this page also sets the specification of the version-list document written with those Edges (Codec 0x0B8L~0x0BAL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION, DEPRECATION, and TOMBSTONE are statement Edges that record the publication, deprecation advisory, and deletion of a document version, and this page also sets the specification of the version-list document written with those Edges (Codec 0x0B8L~0x0BAL).

| Item | Value |
|---|---|
| Name | `TOMBSTONE` (specification document BIND `TOMBSTONE`) |
| TAG ID | `0x0BAL` |
| Codec ID | `0x00000BA0` |
| Specification document | `0x00000000/codecs/0x00000BA0/` (DECLARE target `0BA0`) |
| Section | 5 `0101` (Edge statement), offset within section C = 26 |
| Kind | Edge · family: statement, group: other |
| TAG WORD | `0000 1011 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Deletion (tombstone) of a published version. DOC-POINTER, reason category |
| Hugo side | `edge/publication.md` (that page also covers [PUBLICATION](0x0B8L-publication.md) and [DEPRECATION](0x0B9L-deprecation.md)) |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | record | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `reason` | #4 | raw value, 1 WORD |  |  |

These are the statement Edges that record the publication, deprecation, and deletion of a document, and the specification of the version-list document written with those Edges. They set the version-list form of [publication addresses and version list](../publishing.md#버전-목록).

## Codes {#코드}

| Codec | Name | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id, DOC-POINTER, content hash |
| `0x0B9L` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id, DOC-POINTER, reason category |

- The three codes are built into the decoder ([layer 0](../publishing.md#층)). A version list is interpreted without consulting a codebook.
- No subform (Codec-specific TAG) is used. The [Edge](_index.md) rule that the first element of the Payload is the Edge Id is kept as is.

## Layout {#레이아웃}

```
TAG WORD          Edge, Codec 0x0B8L / 0x0B9L / 0x0BAL
[Length extension TAG]
Edge Id           LOCAL Reference record
Document          DOC-POINTER Reference record (Issuer, document ID, version ID). For a codec version list, CODEC-POINTER
Content hash      16 WORD   (PUBLICATION)
Reason category   1 WORD    (TOMBSTONE)
```

| Field | Width | Description |
|---|---|---|
| Edge Id | LOCAL Reference record | Sequence number in the list. Numbered from 1 and appended in sequence |
| Document | DOC-POINTER record | One version of the published document ([DOC-POINTER](../reference/0x041L-doc-pointer.md)). The Issuer and document ID are the same as the document the list covers. This lets the list document say what it is a list of even without a path. The version ID is the sequence number within that document ([Document](../document.md) version), and `0` (latest) is not used. The version list of a codec uses [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, codec ID, version ID) |
| Content hash | 16 WORD | The content hash of that version (SHA-256, [Document](../document.md) content hash) |
| Reason category | 1 WORD | Category code of the deletion reason. The code table is an open problem |

- The length after the DOC-POINTER is fixed per code (16, 0, 1 WORD). Otherwise, reject.
- No time is placed in a record. The `RECORDED-AT` of the list document in which the record first appeared is the time of publication, deprecation, or deletion.

## Version-list document {#버전-목록-문서}

The publisher keeps appending one version-list document per document: `/<Issuer>/docs/<document ID>/versions.geul` (for a codec, `/<Issuer>/codecs/<codec ID>/versions.geul`; for the Issuer list, see [below](#목록-문서의-버전-목록)). Every version of that document published at that publisher goes into one list.

```
DOC-1WORD/2WORD/4WORD     total length
  SPEC-VERSION            0x0001 (v1)
  PARENT                  SHA-256-DIGEST Value. Content hash of the previous list document (none for the first list)
  RECORDED-AT             POSIX-TIMESTAMP-SECONDS Value. Time this list was issued
  NEXT-LOCAL-ID           Next LOCAL ID to assign (if there are versions)
  SIGNATURE               The publisher's signature. Its subject is the content hash of this list document
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- HEAD Meta: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PARENT](../meta/0x1D1L-parent.md), [RECORDED-AT](../meta/0x1D0L-recorded-at.md), [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md), [SIGNATURE](../meta/0x1E6L-signature.md).
- A version-list document holds no `DOC-ID` (an exception for list documents, [DOC-ID](../meta/0x1C7L-doc-id.md)). A list is not a published document but a record attached to that document. Which document a list belongs to is stated by the DOC-POINTER (document ID) of the records. So even when received without a path (`hashes/`, a dump), it is known what the list is of.
- The document IDs of the records must all be the document the list covers. Reject a record of another document.
- A version-list document holds no IMPORT and uses only layer-0 Codecs. BODY holds only PUBLICATION, DEPRECATION, and TOMBSTONE. It holds no document-name BIND ([publication addresses and version list](../publishing.md#문서-이름)).
- A new list document keeps the BODY of the previous list document as is at the front and appends records. It does not edit, delete, or reorder.
- The publisher signs the list. For geul.org publication, geul.org (the GEUL Issuer) signs; for private publication, that Issuer signs.
- Document ID `0x0000000000000000` is the Issuer's term-definition index document ([Issuer and publication](../issuer.md)). The Issuer itself is pointed to by [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).

## Version list of the list document {#목록-문서의-버전-목록}

The list document is the single Issuer list `issuers/` ([publication addresses and version list](../publishing.md#목록-문서)). The Issuer list also starts at version 1 and has a version list `issuers/versions.geul`. Its records point to list versions by a DOC-POINTER with the reserved document ID (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, version ID).

- The record form is as above. So even when received through `hashes/`, it is known what the list is of.
- The list document itself (`<version ID>.geul`) also holds no `DOC-ID`.
- Document ID `0xFFFFFFFFFFFFFFFF` is not served at an `<Issuer>/docs/<document ID>/` address at any Issuer (404).
- The `latest.geul` of the list is an alias that is not stored. It finds the most recent version in this version list and serves those bytes.

## Rules {#규칙}

- The version IDs of PUBLICATION are ascending from 1 without gaps. The version ID is assigned by the publisher.
- The same content hash is not published again. If it already exists, return that version ID.
- DEPRECATION and TOMBSTONE point only to the version ID of a PUBLICATION that appeared earlier. Reject one that points to a nonexistent version.
- The state of a version is computed by applying the records in order. Published → deprecated → deleted. A deleted version is not published again and is not served.
- The latest version is the highest version ID that is neither deprecated nor deleted.
- When a version ID reaches the end of 2 WORDs, that document is published no further and a new document ID is used.

## Addresses {#주소}

```
/.well-known/geul/<Issuer>/docs/<document ID>/versions.geul        latest list document (mutable)
/.well-known/geul/<Issuer>/codecs/<codec ID>/versions.geul         latest list document of a codec (mutable)
/.well-known/geul/issuers/versions.geul                            latest version list of the Issuer list (mutable)
/.well-known/geul/<Issuer>/hashes/<content hash>.geul              past list document (immutable)
```

- What is mutable is the latest-list address. A received list is verified by its signature, `RECORDED-AT`, and the `PARENT` chain.
- All past list documents remain in `<Issuer>/hashes/`. Following the `PARENT` chain, the list at any point in time can be traced back.

## Verification {#검증}

- The list document must carry a `SIGNATURE` by the key designated for the publisher.
- The document ID of the records must equal the requested document ID.
- The content hash of the previous list kept in the lock record must be in the `PARENT` chain of the new list. The BODY of that list must equal the leading part of the new list's BODY.
- The content hash of a received document must equal the value written by the PUBLICATION of that version ID, and the document's `DOC-ID` must equal the requested Issuer and document ID. A list document has no `DOC-ID`.

## Open problems {#열린-문제}

- The reason-category code table.
- The default signature algorithm and the `SIGNATURE` Payload layout.
- When and in what form to move to a Merkle log (inclusion and consistency proofs) as lists grow.
- Issuer-level rollback protection. Because a list forms its own chain per document, an attack presenting an old list for only one document is blocked only by that document's chain.

## Related pages {#관련-페이지}

- [Edge](_index.md), [BIND](0x0A3L-bind.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer and publication](../issuer.md), [publication addresses and version list](../publishing.md), [Document](../document.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000BA0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BA000000000
BODY
#1 DECLARE 0x0BA0
#2 FIELD #1 record
#9 CODEC #2 0x0410
#4 FIELD #1 0x0001
#5 BIND #1 "TOMBSTONE"
#6 BIND #2 "doc"
#8 BIND #4 "reason"
#10 CODEC #2 0x0420
```
