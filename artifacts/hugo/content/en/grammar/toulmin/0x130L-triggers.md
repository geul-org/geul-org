---
title: "TRIGGERS (0x130L)"
weight: 304
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TRIGGERS is the LINK Codec that writes a relation of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIGGERS is the LINK Codec that writes a relation of a TOULMIN graph. Meaning: trigger → case.

| Item | Value |
|---|---|
| Name | `TRIGGERS` (spec document BIND `TRIGGERS`) |
| TAG ID | `0x130L` |
| Codec ID | `0x00001300` |
| Spec document | `0x00000000/codecs/0x00001300/` (DECLARE target `1300`) |
| Section | 9 `1001` (Edge TOULMIN format), offset within section C = 16 |
| Kind | Edge · family: TOULMIN format, layout: LINK |
| TAG WORD | `0001 0011 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Trigger → case |
| Hugo page | `edge/toulmin/link.md` |

## Layout {#레이아웃}

The layout is [LINK](_index.md#link) (ID, src, dst, flags, conditional fields, SPAN).

| Item | Value |
|---|---|
| TANGEUL | trigger `run c` |
| src → dst | trigger → case |

- dst is the REF of a node.
- F_FORCE is not used (it is rejected if turned on).
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1300`). The conditional fields of the LINK layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001300/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000130000000000
BODY
#1 DECLARE 0x1300
#2 BIND #1 "TRIGGERS"
```
