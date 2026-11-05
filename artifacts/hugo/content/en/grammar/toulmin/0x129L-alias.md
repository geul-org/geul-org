---
title: "ALIAS (0x129L)"
weight: 297
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ALIAS is the NODE Codec that writes a node of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS is the NODE Codec that writes a node of a TOULMIN graph. Meaning: `see … from`. Alias of an imported package.

| Item | Value |
|---|---|
| Name | `ALIAS` (spec document BIND `ALIAS`) |
| TAG ID | `0x129L` |
| Codec ID | `0x00001290` |
| Spec document | `0x00000000/codecs/0x00001290/` (DECLARE target `1290`) |
| Section | 9 `1001` (Edge TOULMIN format), offset within section C = 9 |
| Kind | Edge · family: TOULMIN format, layout: NODE |
| TAG WORD | `0001 0010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | `see … from`. Alias of an imported package |
| Hugo page | `edge/toulmin/node.md` |

## Layout {#레이아웃}

The layout is [NODE](_index.md#node). A 1 WORD header sets the role, level, Claim form, and conditional fields.

| Item | Value |
|---|---|
| TANGEUL | `see a from path` |
| Node | alias of an imported package |

- The role must be 0.
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1290`). The conditional fields of the NODE layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001290/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000129000000000
BODY
#1 DECLARE 0x1290
#2 BIND #1 "ALIAS"
```
