---
title: "RAISE (0x0F8L)"
weight: 248
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "RAISE est le Codec du groupe d'erreur des Edge d'exécution."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RAISE est le Codec du groupe d'erreur des Edge d'exécution. Sens : levée d'erreur.

| Rubrique | Valeur |
|---|---|
| Nom | `RAISE` (document de spécification BIND `RAISE`) |
| TAG ID | `0x0F8L` |
| Codec ID | `0x00000F80` |
| Document de spécification | `0x00000000/codecs/0x00000F80/` (cible DECLARE `0F80`) |
| Section | 7 `0111` (Edge d'exécution), décalage dans la section C = 24 |
| Kind | Edge · famille : exécution, groupe : erreur |
| TAG WORD | `0000 1111 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Levée d'erreur. Valeur d'erreur |
| Côté Hugo | `edge/_index.md` |

## Composants {#구성요소}

Valeur d'erreur.

- Les composants sont désignés par l'ID LOCAL (REF) de ce document. REF `0` signifie absent. À la place d'une expression, on place un Edge d'expression ou un symbole ([Edge](_index.md#실행-edge)).
- Le code d'opérateur, la représentation des types et la disposition du Payload ne sont pas encore fixés ([Edge](_index.md#실행-edge), problèmes ouverts).

## Document de Codec {#코덱-문서}

La disposition n'est pas encore fixée. Le document de Codec ne contient que DECLARE (cible `0F80`). Les FIELD seront ajoutés lorsque la disposition sera fixée.

## Pages liées {#관련-페이지}

- [Edge — Edge d'exécution](_index.md#실행-edge), [TRY](0x0F9L-try.md)

## Texte original du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000F80/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F8000000000
BODY
#1 DECLARE 0x0F80
#2 BIND #1 "RAISE"
```
