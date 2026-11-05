---
title: "CONSTRUCT (0x0EEL)"
weight: 238
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "CONSTRUCT is the Codec of the execution Edge expression group."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CONSTRUCT is the Codec of the execution Edge expression group. Meaning: construction of a compound value (list, record).

| Item | Value |
|---|---|
| Name | `CONSTRUCT` (spec document BIND `CONSTRUCT`) |
| TAG ID | `0x0EEL` |
| Codec ID | `0x00000EE0` |
| Spec document | `0x00000000/codecs/0x00000EE0/` (DECLARE target `0EE0`) |
| Section | 7 `0111` (Edge execution), offset within section C = 14 |
| Kind | Edge · family: execution, group: expression |
| TAG WORD | `0000 1110 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Construction of a compound value (list, record). Type, element count, element x element count |
| Hugo page | `edge/_index.md` |

## Components {#구성요소}

Type, element count, element x element count.

- Components are referred to by this document's LOCAL ID (REF). REF `0` means none. In an expression position, place an expression Edge or a symbol ([Edge](_index.md#실행-edge)).
- Operator codes, type representation, and Payload layout are not yet decided ([Edge](_index.md#실행-edge) open problems).

## Codec document {#코덱-문서}

The layout is not yet decided. The Codec document holds only DECLARE (target `0EE0`). FIELDs will be added once the layout is decided.

## Related pages {#관련-페이지}

- [Edge — Execution Edge](_index.md#실행-edge), [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONDITIONAL](0x0EFL-conditional.md)

## Spec document source text {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000EE0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000EE000000000
BODY
#1 DECLARE 0x0EE0
#2 BIND #1 "CONSTRUCT"
```
