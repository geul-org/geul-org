---
title: "END (0x1C4L)"
weight: 452
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "A record that closes the document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `END` (spec document BIND `END`) |
| TAG ID | `0x1C4L` |
| Codec ID | `0x00001C40` |
| Spec document | `0x00000000/codecs/0x00001C40/` (DECLARE target `1C40`) |
| Section | 14 `1110` (Meta), offset within section C = 4 |
| Kind | Meta · class: structure |
| TAG WORD | `0001 1100 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | 1 WORD. Closes the document. |
| Hugo side | `meta/structure/end.md` |

## Fields (spec document) {#필드-규격-문서}

The spec document has no FIELD. No Payload field is declared.

A record that closes the document.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0100 LLLL      Codec 0x1C4L
[Length extension TAG]
```

- Codec: Meta `0x1C4L`, structure class
- Payload: none (1 WORD)
- Count: one per document, at the very end

## Interpretation and validity {#해석과-유효성}

- Required. Its position is checked against the length given by [DOC](0x1C0L-doc-1word.md) (`DOC-*`).
- If the input ends without END, the document is truncated. Whether to treat the content of a truncated document as valid is decoder policy.
- Nothing follows it.

## Example {#예시}

- `0x1C40`

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001C40/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C4000000000
BODY
#1 DECLARE 0x1C40
#2 BIND #1 "END"
```
