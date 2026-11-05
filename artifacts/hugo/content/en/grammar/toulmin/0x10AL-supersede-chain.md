---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN is a TOULMIN Edge Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN is a TOULMIN Edge Codec. Meaning: priority chain `A > B > C`. An abbreviation of pairwise SUPERSEDES.

| Item | Value |
|---|---|
| Name | `SUPERSEDE-CHAIN` (spec document BIND `SUPERSEDE-CHAIN`) |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| Spec document | `0x00000000/codecs/0x000010A0/` (DECLARE target `10A0`) |
| Section | 8 `1000` (Edge TOULMIN), offset within section C = 10 |
| Kind | Edge · family: TOULMIN, group: relation |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Priority chain `A > B > C`. An abbreviation of pairwise SUPERSEDES. Layout undecided |
| Hugo page | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Only the code is assigned; there is no layout yet ([TOULMIN](_index.md#열린-문제)).

- For now, write one [SUPERSEDES](0x109L-supersedes.md) per pair. Whether that is enough for a chain is an open problem.

## Codec document {#코덱-문서}

The layout is not decided. The Codec document holds only a DECLARE (target `10A0`). FIELD will be added once the layout is decided.

## Related pages {#관련-페이지}

- [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000010A0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
