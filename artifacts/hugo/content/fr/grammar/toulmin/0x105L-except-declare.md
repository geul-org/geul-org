---
title: "EXCEPT-DECLARE (0x105L)"
weight: 261
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXCEPT-DECLARE est le Codec NODE qui écrit un nœud du graphe TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXCEPT-DECLARE est le Codec NODE qui écrit un nœud du graphe TOULMIN. Sens : déclaration d'exception. Attaque sans conclusion propre. Level par défaut : Review.

| Élément | Valeur |
|---|---|
| Nom | `EXCEPT-DECLARE` (BIND du document de spécification `EXCEPT-DECLARE`) |
| TAG ID | `0x105L` |
| Codec ID | `0x00001050` |
| Document de spécification | `0x00000000/codecs/0x00001050/` (cible de DECLARE `1050`) |
| Section | 8 `1000` (Edge TOULMIN), décalage dans la section C = 5 |
| Kind | Edge · famille : TOULMIN, groupe : déclaration, disposition : NODE |
| TAG WORD | `0001 0000 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Déclaration d'exception. Attaque sans conclusion propre. Level par défaut : Review |
| Côté Hugo | `edge/toulmin/node.md` |

## Disposition {#레이아웃}

La disposition est [NODE](_index.md#node). 1 WORD d'en-tête fixe le role, le level, la forme de Claim et les champs conditionnels.

| Élément | Valeur |
|---|---|
| TANGEUL | except rule |
| Nœud | Exception (Defeater) |

- role doit valoir 2 (except). Si level vaut 0 (Unset), on emploie la valeur par défaut du moteur, Review.
- Les champs communs (ID, REF, SPAN) et les règles numériques suivent [TOULMIN](_index.md#공통-필드).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1050`). Les champs conditionnels de la disposition NODE et la largeur de SPAN fixée par SOURCE ne peuvent pas être déclarés par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001050/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000105000000000
BODY
#1 DECLARE 0x1050
#2 BIND #1 "EXCEPT-DECLARE"
```
