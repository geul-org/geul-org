---
title: "EXCEPT-DECLARE (0x105L)"
weight: 261
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXCEPT-DECLARE is the NODE Codec that writes a node of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXCEPT-DECLARE is the NODE Codec that writes a node of a TOULMIN graph. Meaning: exception declaration. It attacks without a conclusion of its own. The default Level is Review.

| Item | Value |
|---|---|
| Name | `EXCEPT-DECLARE` (spec document BIND `EXCEPT-DECLARE`) |
| TAG ID | `0x105L` |
| Codec ID | `0x00001050` |
| Spec document | `0x00000000/codecs/0x00001050/` (DECLARE target `1050`) |
| Section | 8 `1000` (Edge TOULMIN), offset within section C = 5 |
| Kind | Edge · family: TOULMIN, group: declaration, layout: NODE |
| TAG WORD | `0001 0000 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Exception declaration. It attacks without a conclusion of its own. The default Level is Review |
| Hugo page | `edge/toulmin/node.md` |

## Layout {#레이아웃}

The layout is [NODE](_index.md#node). A 1 WORD header sets the role, level, Claim form, and conditional fields.

| Item | Value |
|---|---|
| TANGEUL | except rule |
| Node | exception (Defeater) |

- The role must be 2 (except). If level is 0 (Unset), the engine default Review is used.
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1050`). The conditional fields of the NODE layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001050/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000105000000000
BODY
#1 DECLARE 0x1050
#2 BIND #1 "EXCEPT-DECLARE"
```
