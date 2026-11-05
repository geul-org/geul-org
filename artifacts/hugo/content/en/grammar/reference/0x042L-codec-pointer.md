---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER is a pointer-declaration Reference that points to one version of a codec document published by an Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER is a pointer-declaration Reference that points to one version of a codec document published by an Issuer. A codec document has no document ID, and points to itself and its version with a CODEC-POINTER.

| Item | Value |
|---|---|
| Name | `CODEC-POINTER` (spec document BIND `CODEC-POINTER`) |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| Spec document | `0x00000000/codecs/0x00000420/` (DECLARE target `0420`) |
| Section | 2 `0010` (Reference other), offset within section C = 2 |
| Kind | Reference · category: pointer-declaration |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | One version of an Issuer codec. Issuer + codec ID 2 WORD + version ID 2 WORD, no target ID |
| Hugo side | `reference/codec-pointer.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | Remaining raw value (`0xFFFF`) |  |  |
| 2 | `codec` | #3 | Raw value, 2 WORD |  |  |
| 3 | `version` | #4 | Raw value, 2 WORD |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[Length extension TAG]
Issuer            2/4/16 WORD
Codec ID          2 WORD
Version ID        2 WORD
```

## Interpretation and validity {#해석과-유효성}

- The Issuer width is the rest of the Payload after subtracting 4 WORD for the codec ID and version ID. The Payload is one of 6, 8, or 20 WORD, and any other length is invalid. It is invalid if the Issuer value fits a narrower width (Issuer canonical form).
- If the Issuer is 16 WORD, the total is 21 WORD, so 1 WORD of Length extension is added.
- The codec ID is 32 bits. The codec ID of a GEUL direct code is its TAG WORD (L=0) written as 32 bits (TRIPLE `0x0AAL` → `0x00000AA0`). The codec ID of an Issuer codec is the codec number of the record, and the Issuer sets it so that it does not collide within its own `codecs/`, regardless of Kind ([Publication addresses and version list](../publishing.md#id-표기)).
- Version ID `0` is the latest version. Any other value is pinned to that version.
- It is a single Codec slot, `0x042L`. There is no quantification (Identified). Because it is in section 2, it is not read as a quantification or scheme.
- Where it is used: Meta [DOC-ID](../meta/0x1C7L-doc-id.md) of a codec document, [PUBLICATION](../edge/0x0B8L-publication.md), DEPRECATION, and TOMBSTONE in a codec version list, and [IMPORT-DOC](../meta/0x1E4L-import-doc.md) that brings in a codec document. In these slots it takes the place of DOC-POINTER.
- The publication address is `/.well-known/geul/<Issuer>/codecs/<codec ID>/<version ID>.geul` ([Publication addresses and version list](../publishing.md#공표-주소)).

## Example {#예시}

The TRIPLE codec (codec ID `0x00000AA0`) of GEUL Issuer `0x00000000`.

| Version | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| Latest (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + codec ID 2 + version ID 2 = 7 WORD, `LLLL=0110`. The TAG is `0000 0100 0010 0110` = `0426`.

## Related pages {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [Codec spec document](../codec-spec.md)
- [Publication addresses and version list](../publishing.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000420/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
