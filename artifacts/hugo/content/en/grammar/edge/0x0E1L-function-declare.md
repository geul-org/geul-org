---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE is the Codec of the execution Edge declaration group."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE is the Codec of the execution Edge declaration group. Meaning: function declaration.

| Item | Value |
|---|---|
| Name | `FUNCTION-DECLARE` (spec document BIND `FUNCTION-DECLARE`) |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| Spec document | `0x00000000/codecs/0x00000E10/` (DECLARE target `0E10`) |
| Section | 7 `0111` (Edge execution), offset within section C = 1 |
| Kind | Edge · family: execution, group: declaration |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Function declaration. Symbol, parameter symbol list, return type, body (BLOCK) |
| Hugo page | `edge/_index.md` |

## Components {#구성요소}

Symbol, parameter symbol list, return type, body (BLOCK).

- Components are referred to by this document's LOCAL ID (REF). REF `0` means none. In an expression position, place an expression Edge or a symbol ([Edge](_index.md#실행-edge)).
- Operator codes, type representation, and Payload layout are not yet decided ([Edge](_index.md#실행-edge) open problems).

## Codec document {#코덱-문서}

The layout is not yet decided. The Codec document holds only DECLARE (target `0E10`). FIELDs will be added once the layout is decided.

## Related pages {#관련-페이지}

- [Edge — Execution Edge](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## Spec document source text {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000E10/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
