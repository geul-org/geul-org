---
title: "UNTIL (0x131L)"
weight: 305
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "UNTIL is the LINK Codec that writes a relation of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNTIL is the LINK Codec that writes a relation of a TOULMIN graph. Meaning: trigger → case (`every … until`).

| Item | Value |
|---|---|
| Name | `UNTIL` (spec document BIND `UNTIL`) |
| TAG ID | `0x131L` |
| Codec ID | `0x00001310` |
| Spec document | `0x00000000/codecs/0x00001310/` (DECLARE target `1310`) |
| Section | 9 `1001` (Edge TOULMIN format), offset within section C = 17 |
| Kind | Edge · family: TOULMIN format, layout: LINK |
| TAG WORD | `0001 0011 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Trigger → case (`every … until`) |
| Hugo page | `edge/toulmin/link.md` |

## Layout {#레이아웃}

The layout is [LINK](_index.md#link) (ID, src, dst, flags, conditional fields, SPAN).

| Item | Value |
|---|---|
| TANGEUL | `every … until c` |
| src → dst | trigger → case |

- dst is the REF of a node.
- F_FORCE is not used (it is rejected if turned on).
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1310`). The conditional fields of the LINK layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001310/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000131000000000
BODY
#1 DECLARE 0x1310
#2 BIND #1 "UNTIL"
```
