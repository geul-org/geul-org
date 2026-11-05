---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT is a TOULMIN Edge Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT is a TOULMIN Edge Codec. Meaning: the judgment result of a node or record. Result (Pass, Review, Fail), verdict value, Activated, Excluded, Level.

| Item | Value |
|---|---|
| Name | `VERDICT` (spec document BIND `VERDICT`) |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| Spec document | `0x00000000/codecs/0x00001180/` (DECLARE target `1180`) |
| Section | 8 `1000` (Edge TOULMIN), offset within section C = 24 |
| Kind | Edge · family: TOULMIN, group: result |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The judgment result of a node or record. Result (Pass, Review, Fail), verdict value, Activated, Excluded, Level. Layout undecided |
| Hugo page | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Only the code is assigned; there is no layout yet ([TOULMIN](_index.md#열린-문제)).

- The verdict of a whole document belongs to Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`). The two are separate Codecs with different Kinds.
- A judgment result is kept in a document different from the one being judged ([TOULMIN](_index.md#판정-결과)).

## Codec document {#코덱-문서}

The layout is not decided. The Codec document holds only a DECLARE (target `1180`). FIELD will be added once the layout is decided.

## Related pages {#관련-페이지}

- [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001180/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
