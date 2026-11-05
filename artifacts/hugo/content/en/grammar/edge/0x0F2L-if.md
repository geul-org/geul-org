---
title: "IF (0x0F2L)"
weight: 242
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "IF is the Codec of the execution Edge statement group."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IF is the Codec of the execution Edge statement group. Meaning: conditional branch.

| Item | Value |
|---|---|
| Name | `IF` (spec document BIND `IF`) |
| TAG ID | `0x0F2L` |
| Codec ID | `0x00000F20` |
| Spec document | `0x00000000/codecs/0x00000F20/` (DECLARE target `0F20`) |
| Section | 7 `0111` (Edge execution), offset within section C = 18 |
| Kind | Edge · family: execution, group: statement |
| TAG WORD | `0000 1111 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Conditional branch. Condition, true BLOCK, false (BLOCK or IF; 0 if none) |
| Hugo page | `edge/_index.md` |

## Components {#구성요소}

Condition, true BLOCK, false (BLOCK or IF; 0 if none).

- Components are referred to by this document's LOCAL ID (REF). REF `0` means none. In an expression position, place an expression Edge or a symbol ([Edge](_index.md#실행-edge)).
- Operator codes, type representation, and Payload layout are not yet decided ([Edge](_index.md#실행-edge) open problems).

## Codec document {#코덱-문서}

The layout is not yet decided. The Codec document holds only DECLARE (target `0F20`). FIELDs will be added once the layout is decided.

## Related pages {#관련-페이지}

- [Edge — Execution Edge](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Spec document source text {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000F20/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F2000000000
BODY
#1 DECLARE 0x0F20
#2 BIND #1 "IF"
```
