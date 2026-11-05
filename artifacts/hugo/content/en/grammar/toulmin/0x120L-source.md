---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE is a source and section record of a TOULMIN document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE is a source and section record of a TOULMIN document. Meaning: authoring source text.

| Item | Value |
|---|---|
| Name | `SOURCE` (spec document BIND `SOURCE`) |
| TAG ID | `0x120L` |
| Codec ID | `0x00001200` |
| Spec document | `0x00000000/codecs/0x00001200/` (DECLARE target `1200`) |
| Section | 9 `1001` (Edge TOULMIN format), offset within section C = 0 |
| Kind | Edge · family: TOULMIN format, layout: ID, SPAN width WORD, UTF8 Value |
| TAG WORD | `0001 0010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Authoring source text |
| Hugo page | `edge/toulmin/source.md` |

## Layout {#레이아웃}

The whole authoring source text. Every SPAN is a byte range within this source text.

```
ID
SPAN width WORD  top 2 bits = width (00=1, 01=2, 10=4, 11=8 WORD), remaining 14 bits = 0
source text      UTF8-TEXT Value record
```

- SOURCE is the first record of the BODY. There is one per document.
- A SPAN has two fields: start byte and byte count. Each field is an unsigned integer of the width (1/2/4/8 WORD) set by the SPAN width WORD.
- It is a different Codec from the evidence Edge [SOURCE](../edge/0x0C0L-source.md) (`0x0C0L`).

- ID is the Edge Id, and REF is the Edge Id of a record in this document (common fields of [TOULMIN](_index.md#공통-필드)). The Payload follows the TAG, with no Issuer or Codec number slot.

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1200`). The field declaration is decided together with the TOULMIN Codec spec document ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [Source and sections](_index.md#source와-구획), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001200/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
