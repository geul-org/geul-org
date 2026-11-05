---
title: "TRY (0x0F9L)"
weight: 249
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TRY est le Codec du groupe d'erreur des Edge d'exécution."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRY est le Codec du groupe d'erreur des Edge d'exécution. Sens : traitement d'erreur.

| Rubrique | Valeur |
|---|---|
| Nom | `TRY` (document de spécification BIND `TRY`) |
| TAG ID | `0x0F9L` |
| Codec ID | `0x00000F90` |
| Document de spécification | `0x00000000/codecs/0x00000F90/` (cible DECLARE `0F90`) |
| Section | 7 `0111` (Edge d'exécution), décalage dans la section C = 25 |
| Kind | Edge · famille : exécution, groupe : erreur |
| TAG WORD | `0000 1111 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Traitement d'erreur. BLOCK du corps, symbole d'erreur, BLOCK de traitement, BLOCK de finalisation (0 si absent) |
| Côté Hugo | `edge/_index.md` |

## Composants {#구성요소}

BLOCK du corps, symbole d'erreur, BLOCK de traitement, BLOCK de finalisation (0 si absent).

- Les composants sont désignés par l'ID LOCAL (REF) de ce document. REF `0` signifie absent. À la place d'une expression, on place un Edge d'expression ou un symbole ([Edge](_index.md#실행-edge)).
- Le code d'opérateur, la représentation des types et la disposition du Payload ne sont pas encore fixés ([Edge](_index.md#실행-edge), problèmes ouverts).

## Document de Codec {#코덱-문서}

La disposition n'est pas encore fixée. Le document de Codec ne contient que DECLARE (cible `0F90`). Les FIELD seront ajoutés lorsque la disposition sera fixée.

## Pages liées {#관련-페이지}

- [Edge — Edge d'exécution](_index.md#실행-edge), [RAISE](0x0F8L-raise.md)

## Texte original du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000F90/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F9000000000
BODY
#1 DECLARE 0x0F90
#2 BIND #1 "TRY"
```
