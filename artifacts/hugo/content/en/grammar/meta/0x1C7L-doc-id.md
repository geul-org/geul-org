---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declares the identifier of this document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `DOC-ID` (spec document BIND `DOC-ID`) |
| TAG ID | `0x1C7L` |
| Codec ID | `0x00001C70` |
| Spec document | `0x00000000/codecs/0x00001C70/` (DECLARE target `1C70`) |
| Section | 14 `1110` (Meta), offset within section C = 7 |
| Kind | Meta · class: declaration |
| TAG WORD | `0001 1100 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The identifier of this document. Embedded Reference `DOC-POINTER` (Issuer, document ID, version 0). A codec document uses `CODEC-POINTER` (Issuer, codec ID, version 0) |
| Hugo side | `meta/declaration/doc-id.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | record | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

Declares the identifier of this document. It is needed for other documents to refer to this document and to targets inside it.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[Length extension TAG]
Document          DOC-POINTER Reference record. (Issuer, document ID, version 0). A codec document uses CODEC-POINTER
```

- Codec: Meta `0x1C7L`, declaration class
- Payload: exactly one embedded Reference [DOC-POINTER](../reference/0x041L-doc-pointer.md) (Issuer, document ID, version 0)
- Count: at most one. Required for version documents under `docs/<document ID>/` and `codecs/<codec ID>/`

## Interpretation and validity {#해석과-유효성}

- The Payload is exactly one `DOC-POINTER` (Issuer, document ID, version `0`) Reference record. Only `0` is used as the version ID. The version is assigned by the version list, not by the document. A codec document uses `CODEC-POINTER` (Issuer, codec ID, version `0`) ([CODEC-POINTER](../reference/0x042L-codec-pointer.md)).
- So the notation that points at "this document" is the same in DOC-ID, in the PUBLICATION records of the version list, and in citations from other documents.
- The same document has the same `DOC-ID` regardless of version. The version ID and content hash are not written in the document ([version](../document.md#버전)).
- There is no document name address ([publication addresses and version lists](../publishing.md#문서-이름)). The human-readable title is carried by a statement [LABEL](../edge/0x0A4L-label.md).
- If absent, the document is unnamed and can be pointed at only by its content hash. It is needed for other documents to point at a LOCAL of this document with a pointing Reference.
- A party that fetches a document verifies that the received document's `DOC-ID` equals the requested Issuer and document ID.
- Document ID `0x0000000000000000` is the Issuer's term-definition index document ([Issuer](../issuer.md)). This document is also a version document under `docs/<document ID>/`, so it carries a DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). The Issuer itself is represented by [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- Under `.well-known/geul/`, version documents `<version ID>.geul` (including spec documents) of `<Issuer>/docs/<document ID>/` and `<Issuer>/codecs/<codec ID>/` require `DOC-ID`.
- List documents are the exception and carry no `DOC-ID`: the version list `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md)) and the versions `<version ID>.geul` of the Issuer list `issuers/` ([publication addresses and version lists](../publishing.md#목록-문서)). The DOC-POINTER in a record says what the list is a list of. A version of a list document is pointed at by the PUBLICATION in its `versions.geul` with a DOC-POINTER (`0x00000000`, reserved document ID, version ID). The content-hash address `<Issuer>/hashes/` holds copies of the documents above, so it follows the originals.
- Document ID `0xFFFFFFFFFFFFFFFF` is reserved in every Issuer (as is `0x0000000000000000`) and is used for the Issuer list of Issuer `0x00000000`. Other Issuers do not use it. Because list documents have no `DOC-ID`, this value appears only in the DOC-POINTER of `issuers/versions.geul` records.
- A Codec spec document is a codec document of the GEUL Issuer `0x00000000`. It has no document ID and carries a CODEC-POINTER (`0x00000000`, codec ID, `0`) as its `DOC-ID`. The codec ID is the Kind and Codec TAG WORD written as 32 bits (`0x0B80` → `0x00000B80`) ([spec document](../codec-spec.md)).

## Example {#예시}

- Issuer `0x00000002`, document `0x…0005`: `1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000` (Meta TAG 1 + Reference TAG 1 + Issuer 2 + document ID 4 + version 2 = 10 WORD)

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001C70/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
