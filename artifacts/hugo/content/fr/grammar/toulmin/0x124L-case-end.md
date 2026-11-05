---
title: "CASE-END (0x124L)"
weight: 292
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-END est un enregistrement de texte original et de division d'un document TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-END est un enregistrement de texte original et de division d'un document TOULMIN. Sens : fin de la portée d'un cas.

| Élément | Valeur |
|---|---|
| Nom | `CASE-END` (BIND du document de spécification `CASE-END`) |
| TAG ID | `0x124L` |
| Codec ID | `0x00001240` |
| Document de spécification | `0x00000000/codecs/0x00001240/` (cible de DECLARE `1240`) |
| Section | 9 `1001` (Edge, format TOULMIN), décalage dans la section C = 4 |
| Kind | Edge · famille : format TOULMIN, disposition : ID, REF (cas) |
| TAG WORD | `0001 0010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Fin de la portée d'un cas |
| Côté Hugo | `edge/toulmin/source.md` |

## Disposition {#레이아웃}

C'est la fin de la portée d'un cas.

```
ID
cas              REF (NODE CASE-DECLARE)
```

- La portée d'un cas, pour un même cas (NODE [CASE-DECLARE](0x100L-case-declare.md)), s'étend entre [CASE-BEGIN](0x123L-case-begin.md) et CASE-END.

- ID est l'Edge Id, REF est l'Edge Id d'un enregistrement de ce document (champs communs de [TOULMIN](_index.md#공통-필드)). Il n'y a pas de champ Issuer ni de numéro de Codec : le Payload suit directement le TAG.

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1240`). La déclaration des champs sera fixée avec le document de spécification de Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [SOURCE et divisions](_index.md#source와-구획), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001240/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000124000000000
BODY
#1 DECLARE 0x1240
#2 BIND #1 "CASE-END"
```
