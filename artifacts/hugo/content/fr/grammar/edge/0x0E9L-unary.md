---
title: "UNARY (0x0E9L)"
weight: 233
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "UNARY est le Codec du groupe d'expression des Edge d'exécution."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNARY est le Codec du groupe d'expression des Edge d'exécution. Sens : expression unaire.

| Rubrique | Valeur |
|---|---|
| Nom | `UNARY` (document de spécification BIND `UNARY`) |
| TAG ID | `0x0E9L` |
| Codec ID | `0x00000E90` |
| Document de spécification | `0x00000000/codecs/0x00000E90/` (cible DECLARE `0E90`) |
| Section | 7 `0111` (Edge d'exécution), décalage dans la section C = 9 |
| Kind | Edge · famille : exécution, groupe : expression |
| TAG WORD | `0000 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Expression unaire. Opérateur 1 WORD, opérande |
| Côté Hugo | `edge/_index.md` |

## Composants {#구성요소}

Opérateur 1 WORD, opérande.

- Les composants sont désignés par l'ID LOCAL (REF) de ce document. REF `0` signifie absent. À la place d'une expression, on place un Edge d'expression ou un symbole ([Edge](_index.md#실행-edge)).
- Le code d'opérateur, la représentation des types et la disposition du Payload ne sont pas encore fixés ([Edge](_index.md#실행-edge), problèmes ouverts).

## Document de Codec {#코덱-문서}

La disposition n'est pas encore fixée. Le document de Codec ne contient que DECLARE (cible `0E90`). Les FIELD seront ajoutés lorsque la disposition sera fixée.

## Pages liées {#관련-페이지}

- [Edge — Edge d'exécution](_index.md#실행-edge), [CONST](0x0E8L-const.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md)

## Texte original du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000E90/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E9000000000
BODY
#1 DECLARE 0x0E90
#2 BIND #1 "UNARY"
```
