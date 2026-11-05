---
title: "EXTERNAL-ISSUER-4WORD (0x034L~0x038L)"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER is a pointer-declaration Reference that cites a LOCAL ID in a document published by an Issuer, without IMPORT, using a single record."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER is a pointer-declaration Reference that cites a LOCAL ID in a document published by an Issuer, without IMPORT, using a single record.

| Item | Value |
|---|---|
| Name | `EXTERNAL-ISSUER-4WORD` (a 5Q bundle. See the member table below for the name of each code) |
| TAG ID | `0x034L~0x038L` |
| Section | 1 `0001` (Reference EXTERNAL), offset within section C = 20~24 |
| Kind | Reference · category: pointer-declaration |
| Hugo side | `reference/external-issuer.md` (that page also covers [EXTERNAL-ISSUER-2WORD](0x02FL-external-issuer-2word.md) and [EXTERNAL-ISSUER-16WORD](0x039L-external-issuer-16word.md)) |

## Members {#구성원}

This page covers one 5Q set, five codes together. The quantification is the offset within the section, `C % 5` ([Reference](_index.md#quantifier)). There is one codec document per code. The fields of the five codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Quantification | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x034L` | `EXTERNAL-ISSUER-4WORD-IDENTIFIED` | Identified | `0x00000340` | `0x00000000/codecs/0x00000340/` | `0000 0011 0100 LLLL` |
| `0x035L` | `EXTERNAL-ISSUER-4WORD-GENERIC` | Generic | `0x00000350` | `0x00000000/codecs/0x00000350/` | `0000 0011 0101 LLLL` |
| `0x036L` | `EXTERNAL-ISSUER-4WORD-FREE-CHOICE` | Free-choice | `0x00000360` | `0x00000000/codecs/0x00000360/` | `0000 0011 0110 LLLL` |
| `0x037L` | `EXTERNAL-ISSUER-4WORD-UNIVERSAL` | Universal | `0x00000370` | `0x00000000/codecs/0x00000370/` | `0000 0011 0111 LLLL` |
| `0x038L` | `EXTERNAL-ISSUER-4WORD-VARIABLE` | Variable | `0x00000380` | `0x00000000/codecs/0x00000380/` | `0000 0011 1000 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | Raw value, 4 WORD |  |  |
| 2 | `doc` | #3 | Raw value, 4 WORD |  |  |
| 3 | `target-id` | #4 | Remaining raw value (`0xFFFF`) |  |  |

EXTERNAL-ISSUER is a pointer-declaration Reference that cites a LOCAL ID in a document published by an Issuer, without IMPORT. A single record is complete in meaning and follows the latest version.

## Layout {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (section 1)
[Length extension TAG]
Issuer            width set by the Codec (2/4/16 WORD)
Document ID       4 WORD
Target ID         all the rest. LOCAL ID in that document, shortest width
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Name | Issuer width |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (registered with geul.org, domain proof) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (registered with geul.org, no proof) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (computed from a public key) |

- The width is set by the scheme number: if the scheme − 9 (`C / 5 − 3` of the offset within the section `C`) is 0, 1, or 2, the width is 2, 4, or 16 WORD. The quantification is `C % 5`.
- The Issuer ID is an integer value. The same value is the same Issuer. Write the Issuer in the shortest width that fits the value, and choose the Codec of that width (4 WORD only at `2^32` or above, 16 WORD only at `2^64` or above). A notation in a wider width is invalid ([Issuer](../issuer.md)).
- geul.org handles Issuer registration and management.
- No version is written; it follows the latest version. To pin the version, use [IMPORT-DOC](../meta/0x1E4L-import-doc.md) and [EXTERNAL-POINTER](0x020L-external-pointer-1word.md).
- The location is found by the publication address rule ([Publication addresses and version list](../publishing.md)).
- The same LOCAL ID of that document is the same target whether it is written as a LOCAL inside that document, as an EXTERNAL-ISSUER in another document (or as an EXTERNAL-POINTER after IMPORT).
- It points only to a LOCAL of a document. A document itself is pointed to by [DOC-POINTER](0x041L-doc-pointer.md), and an Issuer itself by [ISSUER-POINTER](0x040L-issuer-pointer.md). So the target ID is not `0`. Document ID `0` is the term-definition index document of the Issuer.

## Validity {#유효성}

- It is invalid if the Issuer width does not match the Codec, or if the value fits a narrower width.
- A target ID of `0` is invalid. Target ID `0` (the document itself) is handled by DOC-POINTER.
- A leading `0x0000` WORD in the target ID is forbidden.

## Examples {#예시}

| Target | WORD sequence |
|---|---|
| Issuer `0x00000002`, document `0x…0002`, LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, document `0x…0002`, LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## Related pages {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer and publication](../issuer.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000340/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000034000000000
BODY
#1 DECLARE 0x0340
#2 FIELD #1 0x0004
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-4WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

The above is the codec document of `EXTERNAL-ISSUER-4WORD-IDENTIFIED` (`0x034L`). The codec documents of the other members (`EXTERNAL-ISSUER-4WORD-GENERIC`, `EXTERNAL-ISSUER-4WORD-FREE-CHOICE`, `EXTERNAL-ISSUER-4WORD-UNIVERSAL`, `EXTERNAL-ISSUER-4WORD-VARIABLE`) differ only in the codec ID of the DOC-ID, the DECLARE target, and the name bound in `#1` (BIND).
