---
title: "DOC-4WORD (0x1C2L)"
weight: 450
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD, and DOC-4WORD are structure Meta records that open a document by giving its total WORD count."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD, DOC-2WORD, and DOC-4WORD are structure Meta records that open a document by giving its total WORD count.

| Item | Value |
|---|---|
| Name | `DOC-4WORD` (spec document BIND `DOC-4WORD`) |
| TAG ID | `0x1C2L` |
| Codec ID | `0x00001C20` |
| Spec document | `0x00000000/codecs/0x00001C20/` (DECLARE target `1C20`) |
| Section | 14 `1110` (Meta), offset within section C = 2 |
| Kind | Meta · class: structure |
| TAG WORD | `0001 1100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Document start whose total length is given in a Payload of 4 WORD |
| Hugo side | `meta/structure/doc.md` (that page also covers [DOC-1WORD](0x1C0L-doc-1word.md) and [DOC-2WORD](0x1C1L-doc-2word.md)) |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | raw value 4 WORD |  |  |

A record that opens the document. It specifies the total WORD count of the document in the Payload. `DOC-1WORD` (`0x1C0L`), `DOC-2WORD` (`0x1C1L`), and `DOC-4WORD` (`0x1C2L`) are covered together on this page.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[Length extension TAG]
Payload           Total WORD count. The Codec sets the width: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x1C0L~0x1C2L`, structure class
- Payload: raw value (total WORD count of the document, unsigned)
- Count: one per document, at the very beginning

## Interpretation and validity {#해석과-유효성}

- The length runs from the start of the opening record to the end of [END](0x1C4L-end.md).
- Use the narrowest width that holds the value. Encoding with a wider width is rejected as a non-canonical encoding.
- The length must equal the whole input. One document is one input.
- A decoder can skip the whole document using this length. No Codec opens a document without knowing its length.
- When computing the content hash, rewrite the length and its matching width with the verification-class Meta removed ([content hash](../document.md#내용-해시)).

## Example {#예시}

- `0x1C01 0x0017`: DOC-1WORD, 23 WORD in total

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001C20/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C2000000000
BODY
#1 DECLARE 0x1C20
#2 FIELD #1 0x0004
#3 BIND #1 "DOC-4WORD"
#4 BIND #2 "count"
```
