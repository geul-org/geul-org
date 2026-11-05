---
title: "WHILE (0x0F4L)"
weight: 244
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "WHILE est le Codec du groupe d'instructions des Edge d'exécution."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WHILE est le Codec du groupe d'instructions des Edge d'exécution. Sens : répétition conditionnelle.

| Rubrique | Valeur |
|---|---|
| Nom | `WHILE` (document de spécification BIND `WHILE`) |
| TAG ID | `0x0F4L` |
| Codec ID | `0x00000F40` |
| Document de spécification | `0x00000000/codecs/0x00000F40/` (cible DECLARE `0F40`) |
| Section | 7 `0111` (Edge d'exécution), décalage dans la section C = 20 |
| Kind | Edge · famille : exécution, groupe : instruction |
| TAG WORD | `0000 1111 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Répétition conditionnelle. Condition, BLOCK du corps |
| Côté Hugo | `edge/_index.md` |

## Composants {#구성요소}

Condition, BLOCK du corps.

- Les composants sont désignés par l'ID LOCAL (REF) de ce document. REF `0` signifie absent. À la place d'une expression, on place un Edge d'expression ou un symbole ([Edge](_index.md#실행-edge)).
- Le code d'opérateur, la représentation des types et la disposition du Payload ne sont pas encore fixés ([Edge](_index.md#실행-edge), problèmes ouverts).

## Document de Codec {#코덱-문서}

La disposition n'est pas encore fixée. Le document de Codec ne contient que DECLARE (cible `0F40`). Les FIELD seront ajoutés lorsque la disposition sera fixée.

## Pages liées {#관련-페이지}

- [Edge — Edge d'exécution](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Texte original du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000F40/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F4000000000
BODY
#1 DECLARE 0x0F40
#2 BIND #1 "WHILE"
```
