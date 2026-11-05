---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION is a source and section record of a TOULMIN document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION is a source and section record of a TOULMIN document. Meaning: section start.

| Item | Value |
|---|---|
| Name | `SECTION` (spec document BIND `SECTION`) |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| Spec document | `0x00000000/codecs/0x00001220/` (DECLARE target `1220`) |
| Section | 9 `1001` (Edge TOULMIN format), offset within section C = 2 |
| Kind | Edge · family: TOULMIN format, layout: ID, section code 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Section start |
| Hugo page | `edge/toulmin/source.md` |

## Layout {#레이아웃}

The start of a section. The section code is 1 WORD.

```
ID
section code     1 WORD
```

| Code | Section | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | condition expression rules |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` is not used. Sections are declared in the order of these codes.
- The section title is the [PROSE](0x125L-prose.md) immediately after SECTION.

- ID is the Edge Id, and REF is the Edge Id of a record in this document (common fields of [TOULMIN](_index.md#공통-필드)). The Payload follows the TAG, with no Issuer or Codec number slot.

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1220`). The field declaration is decided together with the TOULMIN Codec spec document ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [Source and sections](_index.md#source와-구획), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001220/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
