---
title: "TRY (0x0F9L)"
weight: 249
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TRY is the Codec of the execution Edge error group."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRY is the Codec of the execution Edge error group. Meaning: error handling.

| Item | Value |
|---|---|
| Name | `TRY` (spec document BIND `TRY`) |
| TAG ID | `0x0F9L` |
| Codec ID | `0x00000F90` |
| Spec document | `0x00000000/codecs/0x00000F90/` (DECLARE target `0F90`) |
| Section | 7 `0111` (Edge execution), offset within section C = 25 |
| Kind | Edge · family: execution, group: error |
| TAG WORD | `0000 1111 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Error handling. Body BLOCK, error symbol, handler BLOCK, finalizer BLOCK (0 if none) |
| Hugo page | `edge/_index.md` |

## Components {#구성요소}

Body BLOCK, error symbol, handler BLOCK, finalizer BLOCK (0 if none).

- Components are referred to by this document's LOCAL ID (REF). REF `0` means none. In an expression position, place an expression Edge or a symbol ([Edge](_index.md#실행-edge)).
- Operator codes, type representation, and Payload layout are not yet decided ([Edge](_index.md#실행-edge) open problems).

## Codec document {#코덱-문서}

The layout is not yet decided. The Codec document holds only DECLARE (target `0F90`). FIELDs will be added once the layout is decided.

## Related pages {#관련-페이지}

- [Edge — Execution Edge](_index.md#실행-edge), [RAISE](0x0F8L-raise.md)

## Spec document source text {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000F90/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F9000000000
BODY
#1 DECLARE 0x0F90
#2 BIND #1 "TRY"
```
