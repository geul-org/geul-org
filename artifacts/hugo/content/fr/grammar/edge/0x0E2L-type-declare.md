---
title: "TYPE-DECLARE (0x0E2L)"
weight: 226
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TYPE-DECLARE est le Codec du groupe de déclaration des Edge d'exécution."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TYPE-DECLARE est le Codec du groupe de déclaration des Edge d'exécution. Sens : déclaration de type.

| Rubrique | Valeur |
|---|---|
| Nom | `TYPE-DECLARE` (document de spécification BIND `TYPE-DECLARE`) |
| TAG ID | `0x0E2L` |
| Codec ID | `0x00000E20` |
| Document de spécification | `0x00000000/codecs/0x00000E20/` (cible DECLARE `0E20`) |
| Section | 7 `0111` (Edge d'exécution), décalage dans la section C = 2 |
| Kind | Edge · famille : exécution, groupe : déclaration |
| TAG WORD | `0000 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Déclaration de type. Symbole et composition (liste des symboles de champs, valeurs d'énumération, cible d'alias) |
| Côté Hugo | `edge/_index.md` |

## Composants {#구성요소}

Symbole et composition (liste des symboles de champs, valeurs d'énumération, cible d'alias).

- Les composants sont désignés par l'ID LOCAL (REF) de ce document. REF `0` signifie absent. À la place d'une expression, on place un Edge d'expression ou un symbole ([Edge](_index.md#실행-edge)).
- Le code d'opérateur, la représentation des types et la disposition du Payload ne sont pas encore fixés ([Edge](_index.md#실행-edge), problèmes ouverts).

## Document de Codec {#코덱-문서}

La disposition n'est pas encore fixée. Le document de Codec ne contient que DECLARE (cible `0E20`). Les FIELD seront ajoutés lorsque la disposition sera fixée.

## Pages liées {#관련-페이지}

- [Edge — Edge d'exécution](_index.md#실행-edge), [FUNCTION-DECLARE](0x0E1L-function-declare.md)

## Texte original du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000E20/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E2000000000
BODY
#1 DECLARE 0x0E20
#2 BIND #1 "TYPE-DECLARE"
```
