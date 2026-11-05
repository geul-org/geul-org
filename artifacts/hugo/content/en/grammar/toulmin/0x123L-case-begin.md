---
title: "CASE-BEGIN (0x123L)"
weight: 291
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-BEGIN is a source and section record of a TOULMIN document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-BEGIN is a source and section record of a TOULMIN document. Meaning: start of a case scope.

| Item | Value |
|---|---|
| Name | `CASE-BEGIN` (spec document BIND `CASE-BEGIN`) |
| TAG ID | `0x123L` |
| Codec ID | `0x00001230` |
| Spec document | `0x00000000/codecs/0x00001230/` (DECLARE target `1230`) |
| Section | 9 `1001` (Edge TOULMIN format), offset within section C = 3 |
| Kind | Edge · family: TOULMIN format, layout: ID, REF (case) |
| TAG WORD | `0001 0010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Start of a case scope |
| Hugo page | `edge/toulmin/source.md` |

## Layout {#레이아웃}

The start of a case scope.

```
ID
case             REF(CASE-DECLARE NODE)
```

- The scope of a case ([CASE-DECLARE](0x100L-case-declare.md) NODE) lies between the CASE-BEGIN and the [CASE-END](0x124L-case-end.md) that point to the same case.

- ID is the Edge Id, and REF is the Edge Id of a record in this document (common fields of [TOULMIN](_index.md#공통-필드)). The Payload follows the TAG, with no Issuer or Codec number slot.

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1230`). The field declaration is decided together with the TOULMIN Codec spec document ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [Source and sections](_index.md#source와-구획), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001230/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000123000000000
BODY
#1 DECLARE 0x1230
#2 BIND #1 "CASE-BEGIN"
```
