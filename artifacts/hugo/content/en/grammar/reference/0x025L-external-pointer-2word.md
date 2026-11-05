---
title: "EXTERNAL-POINTER-2WORD (0x025L~0x029L)"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER is a pointer Reference that points to a LOCAL ID in a document brought in by IMPORT-DOC in the HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER is a pointer Reference that points to a LOCAL ID in a document brought in by IMPORT-DOC in the HEAD.

| Item | Value |
|---|---|
| Name | `EXTERNAL-POINTER-2WORD` (a 5Q bundle. See the member table below for the name of each code) |
| TAG ID | `0x025L~0x029L` |
| Section | 1 `0001` (Reference EXTERNAL), offset within section C = 5~9 |
| Kind | Reference · category: pointer |
| Hugo side | `reference/external-pointer.md` (that page also covers [EXTERNAL-POINTER-1WORD](0x020L-external-pointer-1word.md) and [EXTERNAL-POINTER-4WORD](0x02AL-external-pointer-4word.md)) |

## Members {#구성원}

This page covers one 5Q set, five codes together. The quantification is the offset within the section, `C % 5` ([Reference](_index.md#quantifier)). There is one codec document per code. The fields of the five codec documents are the same; only the DECLARE target and the name (BIND) differ.

| TAG ID | Name | Quantification | Codec ID | Spec document | TAG WORD |
|---|---|---|---|---|---|
| `0x025L` | `EXTERNAL-POINTER-2WORD-IDENTIFIED` | Identified | `0x00000250` | `0x00000000/codecs/0x00000250/` | `0000 0010 0101 LLLL` |
| `0x026L` | `EXTERNAL-POINTER-2WORD-GENERIC` | Generic | `0x00000260` | `0x00000000/codecs/0x00000260/` | `0000 0010 0110 LLLL` |
| `0x027L` | `EXTERNAL-POINTER-2WORD-FREE-CHOICE` | Free-choice | `0x00000270` | `0x00000000/codecs/0x00000270/` | `0000 0010 0111 LLLL` |
| `0x028L` | `EXTERNAL-POINTER-2WORD-UNIVERSAL` | Universal | `0x00000280` | `0x00000000/codecs/0x00000280/` | `0000 0010 1000 LLLL` |
| `0x029L` | `EXTERNAL-POINTER-2WORD-VARIABLE` | Variable | `0x00000290` | `0x00000000/codecs/0x00000290/` | `0000 0010 1001 LLLL` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | Raw value, 2 WORD |  |  |
| 2 | `target-id` | #3 | Remaining raw value (`0xFFFF`) |  |  |

EXTERNAL-POINTER is a pointer Reference that points to a LOCAL ID in a document brought in by [IMPORT-DOC](../meta/0x1E4L-import-doc.md) in the HEAD.

## Layout {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (section 1)
[Length extension TAG]
IMPORT ID         width set by the Codec (1/2/4 WORD)
Target ID         all the rest. LOCAL ID of the imported document, shortest width
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Name | IMPORT ID width |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- The width is set by the scheme number: if the scheme − 6 (`C / 5` of the offset within the section `C`) is 0, 1, or 2, the width is 1, 2, or 4 WORD. The quantification is `C % 5`.

- Use the narrowest Codec that fits the IMPORT ID value.
- The IMPORT ID is a value assigned by an `IMPORT-DOC` of this document. No Issuer is written in an EXTERNAL-POINTER. The Issuer and document ID come from that `IMPORT-DOC`. The version is also set by that `IMPORT-DOC` (pinned or latest).
- The same LOCAL ID in the imported document is the same target whether it is written as a LOCAL inside that document or as an EXTERNAL-POINTER here.
- If Variable, it is a LOCAL variable of the imported document.

## Validity {#유효성}

- It is invalid if this document has no `IMPORT-DOC` that assigned that IMPORT ID.
- If the IMPORT ID fits a narrower Codec but a wider Codec is used, it is rejected as non-minimal.
- A target ID of `0` is invalid. The imported document itself is pointed to by [DOC-POINTER](0x041L-doc-pointer.md).
- A leading `0x0000` WORD in the target ID is forbidden.

## Examples {#예시}

| Target | WORD sequence |
|---|---|
| LOCAL 5 of IMPORT ID 1 | `0202 0001 0005` |
| LOCAL 65536 of IMPORT ID 1 | `0203 0001 0001 0000` |
| LOCAL 5 of IMPORT ID 70000 | `0253 0001 1170 0005` |

## Related pages {#관련-페이지}

- [Reference](_index.md), [LOCAL](0x005L-local.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000250/latest.geul` as read by `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000025000000000
BODY
#1 DECLARE 0x0250
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-2WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

The above is the codec document of `EXTERNAL-POINTER-2WORD-IDENTIFIED` (`0x025L`). The codec documents of the other members (`EXTERNAL-POINTER-2WORD-GENERIC`, `EXTERNAL-POINTER-2WORD-FREE-CHOICE`, `EXTERNAL-POINTER-2WORD-UNIVERSAL`, `EXTERNAL-POINTER-2WORD-VARIABLE`) differ only in the codec ID of the DOC-ID, the DECLARE target, and the name bound in `#1` (BIND).
