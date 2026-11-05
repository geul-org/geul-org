---
title: "ASSIGN (0x0F1L)"
weight: 241
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "ASSIGN est le Codec du groupe d'instructions des Edge d'exécution."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ASSIGN est le Codec du groupe d'instructions des Edge d'exécution. Sens : affectation.

| Rubrique | Valeur |
|---|---|
| Nom | `ASSIGN` (document de spécification BIND `ASSIGN`) |
| TAG ID | `0x0F1L` |
| Codec ID | `0x00000F10` |
| Document de spécification | `0x00000000/codecs/0x00000F10/` (cible DECLARE `0F10`) |
| Section | 7 `0111` (Edge d'exécution), décalage dans la section C = 17 |
| Kind | Edge · famille : exécution, groupe : instruction |
| TAG WORD | `0000 1111 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Affectation. Cible (symbole, MEMBER, INDEX), valeur |
| Côté Hugo | `edge/_index.md` |

## Composants {#구성요소}

Cible (symbole, MEMBER, INDEX), valeur.

- Les composants sont désignés par l'ID LOCAL (REF) de ce document. REF `0` signifie absent. À la place d'une expression, on place un Edge d'expression ou un symbole ([Edge](_index.md#실행-edge)).
- Le code d'opérateur, la représentation des types et la disposition du Payload ne sont pas encore fixés ([Edge](_index.md#실행-edge), problèmes ouverts).

## Document de Codec {#코덱-문서}

La disposition n'est pas encore fixée. Le document de Codec ne contient que DECLARE (cible `0F10`). Les FIELD seront ajoutés lorsque la disposition sera fixée.

## Pages liées {#관련-페이지}

- [Edge — Edge d'exécution](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Texte original du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000F10/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F1000000000
BODY
#1 DECLARE 0x0F10
#2 BIND #1 "ASSIGN"
```
