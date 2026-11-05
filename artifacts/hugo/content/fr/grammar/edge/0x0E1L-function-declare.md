---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE est le Codec du groupe de déclaration des Edge d'exécution."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE est le Codec du groupe de déclaration des Edge d'exécution. Sens : déclaration de fonction.

| Rubrique | Valeur |
|---|---|
| Nom | `FUNCTION-DECLARE` (document de spécification BIND `FUNCTION-DECLARE`) |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| Document de spécification | `0x00000000/codecs/0x00000E10/` (cible DECLARE `0E10`) |
| Section | 7 `0111` (Edge d'exécution), décalage dans la section C = 1 |
| Kind | Edge · famille : exécution, groupe : déclaration |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Déclaration de fonction. Symbole, liste des symboles de paramètres, type de retour, corps (BLOCK) |
| Côté Hugo | `edge/_index.md` |

## Composants {#구성요소}

Symbole, liste des symboles de paramètres, type de retour, corps (BLOCK).

- Les composants sont désignés par l'ID LOCAL (REF) de ce document. REF `0` signifie absent. À la place d'une expression, on place un Edge d'expression ou un symbole ([Edge](_index.md#실행-edge)).
- Le code d'opérateur, la représentation des types et la disposition du Payload ne sont pas encore fixés ([Edge](_index.md#실행-edge), problèmes ouverts).

## Document de Codec {#코덱-문서}

La disposition n'est pas encore fixée. Le document de Codec ne contient que DECLARE (cible `0E10`). Les FIELD seront ajoutés lorsque la disposition sera fixée.

## Pages liées {#관련-페이지}

- [Edge — Edge d'exécution](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## Texte original du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000E10/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
