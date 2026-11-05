---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER is a pointer-declaration Reference that points to one version of a document published by an Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `DOC-POINTER` (spec document BIND `DOC-POINTER`) |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| Spec document | `0x00000000/codecs/0x00000410/` (DECLARE target `0410`) |
| Section | 2 `0010` (Reference other), offset within section C = 1 |
| Kind | Reference · category: pointer-declaration |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Hugo side | `reference/doc-pointer.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | Remaining raw value (`0xFFFF`) |  |  |
| 2 | `doc` | #3 | Raw value, 4 WORD |  |  |
| 3 | `version` | #4 | Raw value, 2 WORD |  |  |

DOC-POINTER is a pointer-declaration Reference that points to one version of a document published by an Issuer. It can be the target of document publication, deprecation, and deletion, of a cited edition, and of statements about a document.

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[Length extension TAG]
Issuer            2/4/16 WORD
Document ID       4 WORD
Version ID        2 WORD
```

## Interpretation and validity {#해석과-유효성}

- The Issuer width is the rest of the Payload after subtracting 6 WORD for the document ID and version ID. The Codec does not split the width. It is invalid if the width is not 2, 4, or 16 WORD, or if the Issuer value fits a narrower width (Issuer canonical form).
- The version ID is not omitted. If omission were allowed, the Issuer width could not be determined from the Payload length alone (a 4 WORD Issuer with no version and a 2 WORD Issuer with a version would both be 8 WORD).
- Version ID `0` is the latest version. It is bound to the current version at the time of interpretation. Any other value is pinned to that version ([PUBLICATION](../edge/0x0B8L-publication.md)).
- Document ID `0` is the term-definition index document of the Issuer. An Issuer itself is pointed to by [ISSUER-POINTER](0x040L-issuer-pointer.md).
- Every Issuer reserves document IDs `0x0000000000000000` and `0xFFFFFFFFFFFFFFFF` ([Issuer and publication](../issuer.md#용어-정의-문서)). `0xFFFFFFFFFFFFFFFF` is used for the Issuer list `issuers/` of Issuer `0x00000000`, and no other Issuer uses it. The PUBLICATION, DEPRECATION, and TOMBSTONE in `issuers/versions.geul` point to list versions with this value ([Publication addresses and version list](../publishing.md#목록-문서)).
- It is a single Codec slot, `0x041L`. There is no quantification (Identified).
- DOC-POINTER is the only form that points to a document of an Issuer. Pointing to a document with `EXTERNAL-ISSUER-*` (Issuer, document ID, target ID `0`) or `EXTERNAL-POINTER-*` (IMPORT ID, target ID `0`) is invalid.
- Where it is used: Meta [DOC-ID](../meta/0x1C7L-doc-id.md) and [IMPORT-DOC](../meta/0x1E4L-import-doc.md), and PUBLICATION, DEPRECATION, and TOMBSTONE in the version list.
- A codec document has no document ID. A codec document and its version are pointed to by [CODEC-POINTER](0x042L-codec-pointer.md).

## Example {#예시}

Document `0xFFFF000000000001` of GEUL Issuer `0x00000000`.

| Version | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| Latest (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + document ID 4 + version ID 2 = 9 WORD, `LLLL=1000`. The TAG is `0000 0100 0001 1000` = `0418`.

## Related pages {#관련-페이지}

- [Reference](_index.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer and publication](../issuer.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000410/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
