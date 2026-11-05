---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "A record that ends the HEAD and starts the BODY."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `BODY` (spec document BIND `BODY`) |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| Spec document | `0x00000000/codecs/0x00001C30/` (DECLARE target `1C30`) |
| Section | 14 `1110` (Meta), offset within section C = 3 |
| Kind | Meta · class: structure |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | 1 WORD. Ends the HEAD of the document and starts the BODY. |
| Hugo side | `meta/structure/body.md` |

## Fields (spec document) {#필드-규격-문서}

The spec document has no FIELD. No Payload field is declared.

A record that ends the HEAD and starts the BODY.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[Length extension TAG]
```

- Codec: Meta `0x1C3L`, structure class
- Payload: none (1 WORD)
- Count: at most one per document

## Interpretation and validity {#해석과-유효성}

- Omit it if the HEAD is empty. A document without `BODY` is entirely BODY. Place it when the HEAD holds Meta or HEAD Edges (the document-wide [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) and its QUALIFIER).
- There is no Payload. The whole record is 1 WORD.

## Example {#예시}

- `0x1C30`

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001C30/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
