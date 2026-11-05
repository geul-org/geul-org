---
title: "VERB (0x0A9L)"
weight: 169
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB is a verb statement Edge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB is a verb statement Edge. Its abbreviated form is [VERB-SHORT](0x0A8L-verb-short.md) (`0x0A8L`) ([Edge](_index.md#서술-edge)).

| Item | Value |
|---|---|
| Name | `VERB` (specification document BIND `VERB`) |
| TAG ID | `0x0A9L` |
| Codec ID | `0x00000A90` |
| Specification document | `0x00000000/codecs/0x00000A90/` (DECLARE target `0A90`) |
| Section | 5 `0101` (Edge statement), offset within section C = 9 |
| Kind | Edge · family: statement, group: proposition |
| TAG WORD | `0000 1010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Verb statement |
| Hugo side | `edge/_index.md` |

## Layout {#레이아웃}

The layout is not yet defined. It follows the common Edge layout (TAG, [Length extension TAG], Edge Id, components) ([Edge](_index.md#레이아웃)).

## Codec document {#코덱-문서}

The layout is not yet defined. The codec document holds only DECLARE (target `0A90`). FIELDs will be added once the layout is defined.

## Related pages {#관련-페이지}

- [VERB-SHORT](0x0A8L-verb-short.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000A90/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A9000000000
BODY
#1 DECLARE 0x0A90
#2 BIND #1 "VERB"
```
