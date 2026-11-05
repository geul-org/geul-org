---
title: "FOREACH (0x0F5L)"
weight: 245
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FOREACH is the Codec of the execution Edge statement group."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FOREACH is the Codec of the execution Edge statement group. Meaning: iteration loop.

| Item | Value |
|---|---|
| Name | `FOREACH` (spec document BIND `FOREACH`) |
| TAG ID | `0x0F5L` |
| Codec ID | `0x00000F50` |
| Spec document | `0x00000000/codecs/0x00000F50/` (DECLARE target `0F50`) |
| Section | 7 `0111` (Edge execution), offset within section C = 21 |
| Kind | Edge · family: execution, group: statement |
| TAG WORD | `0000 1111 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Iteration loop. Element symbol, target, body BLOCK |
| Hugo page | `edge/_index.md` |

## Components {#구성요소}

Element symbol, target, body BLOCK.

- Components are referred to by this document's LOCAL ID (REF). REF `0` means none. In an expression position, place an expression Edge or a symbol ([Edge](_index.md#실행-edge)).
- Operator codes, type representation, and Payload layout are not yet decided ([Edge](_index.md#실행-edge) open problems).

## Codec document {#코덱-문서}

The layout is not yet decided. The Codec document holds only DECLARE (target `0F50`). FIELDs will be added once the layout is decided.

## Related pages {#관련-페이지}

- [Edge — Execution Edge](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Spec document source text {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000F50/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F5000000000
BODY
#1 DECLARE 0x0F50
#2 BIND #1 "FOREACH"
```
