---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Imports an external document under an IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `IMPORT-DOC` (spec document BIND `IMPORT-DOC`) |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| Spec document | `0x00000000/codecs/0x00001E40/` (DECLARE target `1E40`) |
| Section | 15 `1111` (Meta), offset within section C = 4 |
| Kind | Meta · class: IMPORT |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Imports an external document under an IMPORT ID. Embedded Reference `DOC-POINTER` (`CODEC-POINTER` for a codec document) + IMPORT ID |
| Hugo side | `meta/import/import-doc.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | record | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | remaining raw value (`0xFFFF`) |  |  |

Imports an external document under an IMPORT ID. The document to import is pointed at by [DOC-POINTER](../reference/0x041L-doc-pointer.md), which also carries the Issuer width.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[Length extension TAG]
Document          DOC-POINTER Reference record (Issuer, document ID, version ID. Version 0 means latest). A codec document uses CODEC-POINTER
IMPORT ID         Everything that remains. Unsigned, of the shortest width
```

- Codec: Meta `0x1E4L`, IMPORT class
- Payload: embedded Reference `DOC-POINTER` (Issuer, document ID, version ID) + IMPORT ID raw value
- Count: several allowed (one per IMPORT ID)

## Interpretation and validity {#해석과-유효성}

- The document is exactly one DOC-POINTER record. When importing a codec document, it is a [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, codec ID, version ID) record. It ends with its own Length, and the rest is the IMPORT ID.
- The IMPORT ID is 1 WORD or more, at the shortest width. The width of the IMPORT ID is set by the record length here, and by the Codec in [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md).
- The same IMPORT ID is not assigned twice in one document.
- If a version ID is given, it binds to that edition; if `0`, to the latest edition at interpretation time (or the one in force at a specified point in time) ([revision](../document.md#개정)).
- An [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) in the BODY points at a LOCAL of the document imported under the IMPORT ID. The imported document itself is pointed at by DOC-POINTER.
- The HEAD of the imported document is not imported. Targets of that document are interpreted as that document declares.
- An IMPORT ID cannot be used to search across documents. A store that loads multiple documents resolves each IMPORT ID to the full path (Issuer, document ID, version ID, LOCAL ID) and stores that.

## Example {#예시}

- IMPORT ID 1, Issuer `0x00000002`, document `0x…0002`, latest: `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (Meta TAG 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD)

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001E40/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
