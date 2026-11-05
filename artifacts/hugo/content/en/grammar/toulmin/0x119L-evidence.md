---
title: "EVIDENCE (0x119L)"
weight: 281
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EVIDENCE is a TOULMIN Edge Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EVIDENCE is a TOULMIN Edge Codec. Meaning: the evidence of a judgment. Location, expected value, actual value (Fact).

| Item | Value |
|---|---|
| Name | `EVIDENCE` (spec document BIND `EVIDENCE`) |
| TAG ID | `0x119L` |
| Codec ID | `0x00001190` |
| Spec document | `0x00000000/codecs/0x00001190/` (DECLARE target `1190`) |
| Section | 8 `1000` (Edge TOULMIN), offset within section C = 25 |
| Kind | Edge · family: TOULMIN, group: result |
| TAG WORD | `0001 0001 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The evidence of a judgment. Location, expected value, actual value (Fact). Layout undecided |
| Hugo page | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Only the code is assigned; there is no layout yet ([TOULMIN](_index.md#열린-문제)).

- A judgment result is kept in a document different from the one being judged ([TOULMIN](_index.md#판정-결과)).

## Codec document {#코덱-문서}

The layout is not decided. The Codec document holds only a DECLARE (target `1190`). FIELD will be added once the layout is decided.

## Related pages {#관련-페이지}

- [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001190/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000119000000000
BODY
#1 DECLARE 0x1190
#2 BIND #1 "EVIDENCE"
```
