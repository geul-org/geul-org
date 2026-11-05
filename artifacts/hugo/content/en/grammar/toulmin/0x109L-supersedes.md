---
title: "SUPERSEDES (0x109L)"
weight: 265
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDES is the LINK Codec that writes a relation of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDES is the LINK Codec that writes a relation of a TOULMIN graph. Meaning: exclusion relation. If the attacker is Active, it deterministically removes the target from the aggregation. A chain (`A > B > C`) is written one pair at a time.

| Item | Value |
|---|---|
| Name | `SUPERSEDES` (spec document BIND `SUPERSEDES`) |
| TAG ID | `0x109L` |
| Codec ID | `0x00001090` |
| Spec document | `0x00000000/codecs/0x00001090/` (DECLARE target `1090`) |
| Section | 8 `1000` (Edge TOULMIN), offset within section C = 9 |
| Kind | Edge · family: TOULMIN, group: relation, layout: LINK |
| TAG WORD | `0001 0000 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Exclusion relation. If the attacker is Active, it deterministically removes the target from the aggregation. A chain (`A > B > C`) is written one pair at a time |
| Hugo page | `edge/toulmin/link.md` |

## Layout {#레이아웃}

The layout is [LINK](_index.md#link) (ID, src, dst, flags, conditional fields, SPAN).

| Item | Value |
|---|---|
| TANGEUL | `X supersedes Y` |
| src → dst | rule → rule. If Active, removes the target from the aggregation |

- A SUPERSEDES chain `A > B > C` writes one SUPERSEDES per pair. The abbreviation [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) has no layout yet.
- F_FORCE is not used (it is rejected if turned on).
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1090`). The conditional fields of the LINK layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001090/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000109000000000
BODY
#1 DECLARE 0x1090
#2 BIND #1 "SUPERSEDES"
```
