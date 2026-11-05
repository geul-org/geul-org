---
title: "SPEC-DECLARE (0x102L)"
weight: 258
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SPEC-DECLARE is the NODE Codec that writes a node of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SPEC-DECLARE is the NODE Codec that writes a node of a TOULMIN graph. Meaning: criterion declaration (Backing). The role bits give the kind of definition.

| Item | Value |
|---|---|
| Name | `SPEC-DECLARE` (spec document BIND `SPEC-DECLARE`) |
| TAG ID | `0x102L` |
| Codec ID | `0x00001020` |
| Spec document | `0x00000000/codecs/0x00001020/` (DECLARE target `1020`) |
| Section | 8 `1000` (Edge TOULMIN), offset within section C = 2 |
| Kind | Edge · family: TOULMIN, group: declaration, layout: NODE |
| TAG WORD | `0001 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Criterion declaration (Backing). The role bits give the kind of definition |
| Hugo page | `edge/toulmin/node.md` |

## Layout {#레이아웃}

The layout is [NODE](_index.md#node). A 1 WORD header sets the role, level, Claim form, and conditional fields.

| Item | Value |
|---|---|
| TANGEUL | Definitions item (`means`, `has`) |
| Node | criterion (Backing). The role is the kind of definition |

- The role is the kind of definition.
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1020`). The conditional fields of the NODE layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001020/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000102000000000
BODY
#1 DECLARE 0x1020
#2 BIND #1 "SPEC-DECLARE"
```
