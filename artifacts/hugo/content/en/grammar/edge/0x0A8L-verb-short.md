---
title: "VERB-SHORT (0x0A8L)"
weight: 168
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB-SHORT is the abbreviated form of the verb statement Edge VERB."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB-SHORT is the abbreviated form of the verb statement Edge [VERB](0x0A9L-verb.md). A `-SHORT` form and its general form are placed as an even-odd pair ([Edge](_index.md#서술-edge)).

| Item | Value |
|---|---|
| Name | `VERB-SHORT` (specification document BIND `VERB-SHORT`) |
| TAG ID | `0x0A8L` |
| Codec ID | `0x00000A80` |
| Specification document | `0x00000000/codecs/0x00000A80/` (DECLARE target `0A80`) |
| Section | 5 `0101` (Edge statement), offset within section C = 8 |
| Kind | Edge · family: statement, group: proposition |
| TAG WORD | `0000 1010 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Abbreviated verb statement |
| Hugo side | `edge/_index.md` |

## Layout {#레이아웃}

The layout is not yet defined. It follows the common Edge layout (TAG, [Length extension TAG], Edge Id, components) ([Edge](_index.md#레이아웃)).

## Codec document {#코덱-문서}

The layout is not yet defined. The codec document holds only DECLARE (target `0A80`). FIELDs will be added once the layout is defined.

## Related pages {#관련-페이지}

- [VERB](0x0A9L-verb.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000A80/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A8000000000
BODY
#1 DECLARE 0x0A80
#2 BIND #1 "VERB-SHORT"
```
