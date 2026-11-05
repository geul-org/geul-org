---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT is a source and section record of a TOULMIN document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT is a source and section record of a TOULMIN document. Meaning: name or string.

| Item | Value |
|---|---|
| Name | `TEXT` (spec document BIND `TEXT`) |
| TAG ID | `0x121L` |
| Codec ID | `0x00001210` |
| Spec document | `0x00000000/codecs/0x00001210/` (DECLARE target `1210`) |
| Section | 9 `1001` (Edge TOULMIN format), offset within section C = 1 |
| Kind | Edge · family: TOULMIN format, layout: ID, UTF8 Value |
| TAG WORD | `0001 0010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Name or string |
| Hugo page | `edge/toulmin/source.md` |

## Layout {#레이아웃}

A single name or string. It is referenced by REF from the F_WITH and F_GROUNDS lists of NODE and from [LABEL](0x134L-label.md) and [IMPORTED-FROM](0x133L-imported-from.md) of LINK.

```
ID
string           UTF8-TEXT Value record
```

- ID is the Edge Id, and REF is the Edge Id of a record in this document (common fields of [TOULMIN](_index.md#공통-필드)). The Payload follows the TAG, with no Issuer or Codec number slot.

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1210`). The field declaration is decided together with the TOULMIN Codec spec document ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [Source and sections](_index.md#source와-구획), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001210/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
