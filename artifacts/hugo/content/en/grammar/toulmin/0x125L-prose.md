---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE is a source and section record of a TOULMIN document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE is a source and section record of a TOULMIN document. Meaning: descriptive paragraph.

| Item | Value |
|---|---|
| Name | `PROSE` (spec document BIND `PROSE`) |
| TAG ID | `0x125L` |
| Codec ID | `0x00001250` |
| Spec document | `0x00000000/codecs/0x00001250/` (DECLARE target `1250`) |
| Section | 9 `1001` (Edge TOULMIN format), offset within section C = 5 |
| Kind | Edge · family: TOULMIN format, layout: ID, SPAN |
| TAG WORD | `0001 0010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Descriptive paragraph |
| Hugo page | `edge/toulmin/source.md` |

## Layout {#레이아웃}

A descriptive paragraph that is not a rule. It points only to a range (SPAN) of the source text.

```
ID
SPAN             width set by SOURCE × 2 (start byte, byte count)
```

- ID is the Edge Id, and REF is the Edge Id of a record in this document (common fields of [TOULMIN](_index.md#공통-필드)). The Payload follows the TAG, with no Issuer or Codec number slot.

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1250`). The SPAN width is set by SOURCE and cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [Source and sections](_index.md#source와-구획), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001250/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
