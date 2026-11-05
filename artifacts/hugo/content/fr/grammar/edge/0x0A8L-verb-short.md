---
title: "VERB-SHORT (0x0A8L)"
weight: 168
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB-SHORT est la forme abrégée de l'Edge d'énoncé verbal VERB."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB-SHORT est la forme abrégée de l'Edge d'énoncé verbal [VERB](0x0A9L-verb.md). Les formes `-SHORT` et générales sont groupées en paire pair/impair ([Edge](_index.md#서술-edge)).

| Élément | Valeur |
|---|---|
| Nom | `VERB-SHORT` (BIND du document de spécification `VERB-SHORT`) |
| TAG ID | `0x0A8L` |
| Codec ID | `0x00000A80` |
| Document de spécification | `0x00000000/codecs/0x00000A80/` (cible de DECLARE `0A80`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 8 |
| Kind | Edge · famille : énoncé, groupe : proposition |
| TAG WORD | `0000 1010 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Forme abrégée de l'énoncé verbal |
| Côté Hugo | `edge/_index.md` |

## Disposition {#레이아웃}

La disposition n'est pas encore fixée. Elle suit la disposition commune des Edge (TAG, [TAG d'extension de Length], Edge Id, composants) ([Edge](_index.md#레이아웃)).

## Document de codec {#코덱-문서}

La disposition n'est pas encore fixée. Le document de codec ne contient que DECLARE (cible `0A80`). Les FIELD seront ajoutés une fois la disposition fixée.

## Pages liées {#관련-페이지}

- [VERB](0x0A9L-verb.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000A80/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A8000000000
BODY
#1 DECLARE 0x0A80
#2 BIND #1 "VERB-SHORT"
```
