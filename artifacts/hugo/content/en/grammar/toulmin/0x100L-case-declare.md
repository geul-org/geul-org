---
title: "CASE-DECLARE (0x100L)"
weight: 256
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-DECLARE is the NODE Codec that writes a node of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-DECLARE is the NODE Codec that writes a node of a TOULMIN graph. Meaning: case declaration. A judgment graph that holds nodes and relations.

| Item | Value |
|---|---|
| Name | `CASE-DECLARE` (spec document BIND `CASE-DECLARE`) |
| TAG ID | `0x100L` |
| Codec ID | `0x00001000` |
| Spec document | `0x00000000/codecs/0x00001000/` (DECLARE target `1000`) |
| Section | 8 `1000` (Edge TOULMIN), offset within section C = 0 |
| Kind | Edge · family: TOULMIN, group: declaration, layout: NODE |
| TAG WORD | `0001 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Case declaration. A judgment graph that holds nodes and relations |
| Hugo page | `edge/toulmin/node.md` |

## Layout {#레이아웃}

The layout is [NODE](_index.md#node). A 1 WORD header sets the role, level, Claim form, and conditional fields.

| Item | Value |
|---|---|
| TANGEUL | in case of |
| Node | case |

- The role must be 0.
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1000`). The conditional fields of the NODE layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001000/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000100000000000
BODY
#1 DECLARE 0x1000
#2 BIND #1 "CASE-DECLARE"
```
