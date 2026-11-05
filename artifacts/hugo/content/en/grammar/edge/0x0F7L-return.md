---
title: "RETURN (0x0F7L)"
weight: 247
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "RETURN is the Codec of the execution Edge statement group."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RETURN is the Codec of the execution Edge statement group. Meaning: return.

| Item | Value |
|---|---|
| Name | `RETURN` (spec document BIND `RETURN`) |
| TAG ID | `0x0F7L` |
| Codec ID | `0x00000F70` |
| Spec document | `0x00000000/codecs/0x00000F70/` (DECLARE target `0F70`) |
| Section | 7 `0111` (Edge execution), offset within section C = 23 |
| Kind | Edge · family: execution, group: statement |
| TAG WORD | `0000 1111 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Return. Value (0 if none) |
| Hugo page | `edge/_index.md` |

## Components {#구성요소}

Value (0 if none).

- Components are referred to by this document's LOCAL ID (REF). REF `0` means none. In an expression position, place an expression Edge or a symbol ([Edge](_index.md#실행-edge)).
- Operator codes, type representation, and Payload layout are not yet decided ([Edge](_index.md#실행-edge) open problems).

## Codec document {#코덱-문서}

The layout is not yet decided. The Codec document holds only DECLARE (target `0F70`). FIELDs will be added once the layout is decided.

## Related pages {#관련-페이지}

- [Edge — Execution Edge](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md)

## Spec document source text {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000F70/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F7000000000
BODY
#1 DECLARE 0x0F70
#2 BIND #1 "RETURN"
```
