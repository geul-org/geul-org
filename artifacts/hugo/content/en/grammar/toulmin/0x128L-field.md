---
title: "FIELD (0x128L)"
weight: 296
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "FIELD is the NODE Codec that writes a node of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD is the NODE Codec that writes a node of a TOULMIN graph. Meaning: `is required`. Required field.

| Item | Value |
|---|---|
| Name | `FIELD` (spec document BIND `FIELD`) |
| TAG ID | `0x128L` |
| Codec ID | `0x00001280` |
| Spec document | `0x00000000/codecs/0x00001280/` (DECLARE target `1280`) |
| Section | 9 `1001` (Edge TOULMIN format), offset within section C = 8 |
| Kind | Edge · family: TOULMIN format, layout: NODE |
| TAG WORD | `0001 0010 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | `is required`. Required field |
| Hugo page | `edge/toulmin/node.md` |

## Layout {#레이아웃}

The layout is [NODE](_index.md#node). A 1 WORD header sets the role, level, Claim form, and conditional fields.

| Item | Value |
|---|---|
| TANGEUL | `x is required [as Type]` |
| Node | required field |

- The role must be 0.
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1280`). The conditional fields of the NODE layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001280/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000128000000000
BODY
#1 DECLARE 0x1280
#2 BIND #1 "FIELD"
```
