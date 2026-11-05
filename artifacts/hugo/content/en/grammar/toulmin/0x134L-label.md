---
title: "LABEL (0x134L)"
weight: 308
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LABEL is the LINK Codec that writes a relation of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL is the LINK Codec that writes a relation of a TOULMIN graph. Meaning: node → TEXT, name notation.

| Item | Value |
|---|---|
| Name | `LABEL` (spec document BIND `LABEL`) |
| TAG ID | `0x134L` |
| Codec ID | `0x00001340` |
| Spec document | `0x00000000/codecs/0x00001340/` (DECLARE target `1340`) |
| Section | 9 `1001` (Edge TOULMIN format), offset within section C = 20 |
| Kind | Edge · family: TOULMIN format, layout: LINK |
| TAG WORD | `0001 0011 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Node → TEXT, name notation |
| Hugo page | `edge/toulmin/link.md` |

## Layout {#레이아웃}

The layout is [LINK](_index.md#link) (ID, src, dst, flags, conditional fields, SPAN).

| Item | Value |
|---|---|
| TANGEUL | backtick name |
| src → dst | node → TEXT. Name notation |

- dst is the REF of a TEXT record. Whether to place a backtick name as a statement [LABEL](../edge/0x0A4L-label.md) or [BIND](../edge/0x0A3L-bind.md) is an open problem ([TOULMIN](_index.md#열린-문제)).
- F_FORCE is not used (it is rejected if turned on).
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1340`). The conditional fields of the LINK layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001340/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000134000000000
BODY
#1 DECLARE 0x1340
#2 BIND #1 "LABEL"
```
