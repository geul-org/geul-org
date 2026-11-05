---
title: "GROUP (0x12AL)"
weight: 298
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "GROUP est le Codec NODE qui écrit un nœud du graphe TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GROUP est le Codec NODE qui écrit un nœud du graphe TOULMIN. Sens : groupe d'exécution ordonné.

| Élément | Valeur |
|---|---|
| Nom | `GROUP` (BIND du document de spécification `GROUP`) |
| TAG ID | `0x12AL` |
| Codec ID | `0x000012A0` |
| Document de spécification | `0x00000000/codecs/0x000012A0/` (cible de DECLARE `12A0`) |
| Section | 9 `1001` (Edge, format TOULMIN), décalage dans la section C = 10 |
| Kind | Edge · famille : format TOULMIN, disposition : NODE |
| TAG WORD | `0001 0010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Groupe d'exécution ordonné |
| Côté Hugo | `edge/toulmin/node.md` |

## Disposition {#레이아웃}

La disposition est [NODE](_index.md#node). 1 WORD d'en-tête fixe le role, le level, la forme de Claim et les champs conditionnels.

| Élément | Valeur |
|---|---|
| TANGEUL | Liste ordonnée `1.` |
| Nœud | Groupe d'exécution ordonné |

- role doit valoir 0.
- Les champs communs (ID, REF, SPAN) et les règles numériques suivent [TOULMIN](_index.md#공통-필드).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `12A0`). Les champs conditionnels de la disposition NODE et la largeur de SPAN fixée par SOURCE ne peuvent pas être déclarés par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x000012A0/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012A000000000
BODY
#1 DECLARE 0x12A0
#2 BIND #1 "GROUP"
```
