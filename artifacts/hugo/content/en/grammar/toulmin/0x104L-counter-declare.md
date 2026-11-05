---
title: "COUNTER-DECLARE (0x104L)"
weight: 260
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "COUNTER-DECLARE is the NODE Codec that writes a node of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COUNTER-DECLARE is the NODE Codec that writes a node of a TOULMIN graph. Meaning: rebuttal declaration. It attacks with a conclusion of its own. The default Level is Fail.

| Item | Value |
|---|---|
| Name | `COUNTER-DECLARE` (spec document BIND `COUNTER-DECLARE`) |
| TAG ID | `0x104L` |
| Codec ID | `0x00001040` |
| Spec document | `0x00000000/codecs/0x00001040/` (DECLARE target `1040`) |
| Section | 8 `1000` (Edge TOULMIN), offset within section C = 4 |
| Kind | Edge · family: TOULMIN, group: declaration, layout: NODE |
| TAG WORD | `0001 0000 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Rebuttal declaration. It attacks with a conclusion of its own. The default Level is Fail |
| Hugo page | `edge/toulmin/node.md` |

## Layout {#레이아웃}

The layout is [NODE](_index.md#node). A 1 WORD header sets the role, level, Claim form, and conditional fields.

| Item | Value |
|---|---|
| TANGEUL | counter rule |
| Node | rebuttal (Rebuttal) |

- The role must be 1 (counter). If level is 0 (Unset), the engine default Fail is used.
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1040`). The conditional fields of the NODE layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001040/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000104000000000
BODY
#1 DECLARE 0x1040
#2 BIND #1 "COUNTER-DECLARE"
```
