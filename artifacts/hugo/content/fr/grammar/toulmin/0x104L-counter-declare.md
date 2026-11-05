---
title: "COUNTER-DECLARE (0x104L)"
weight: 260
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "COUNTER-DECLARE est le Codec NODE qui écrit un nœud du graphe TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COUNTER-DECLARE est le Codec NODE qui écrit un nœud du graphe TOULMIN. Sens : déclaration de réfutation. Attaque avec sa propre conclusion. Level par défaut : Fail.

| Élément | Valeur |
|---|---|
| Nom | `COUNTER-DECLARE` (BIND du document de spécification `COUNTER-DECLARE`) |
| TAG ID | `0x104L` |
| Codec ID | `0x00001040` |
| Document de spécification | `0x00000000/codecs/0x00001040/` (cible de DECLARE `1040`) |
| Section | 8 `1000` (Edge TOULMIN), décalage dans la section C = 4 |
| Kind | Edge · famille : TOULMIN, groupe : déclaration, disposition : NODE |
| TAG WORD | `0001 0000 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Déclaration de réfutation. Attaque avec sa propre conclusion. Level par défaut : Fail |
| Côté Hugo | `edge/toulmin/node.md` |

## Disposition {#레이아웃}

La disposition est [NODE](_index.md#node). 1 WORD d'en-tête fixe le role, le level, la forme de Claim et les champs conditionnels.

| Élément | Valeur |
|---|---|
| TANGEUL | counter rule |
| Nœud | Réfutation (Rebuttal) |

- role doit valoir 1 (counter). Si level vaut 0 (Unset), on emploie la valeur par défaut du moteur, Fail.
- Les champs communs (ID, REF, SPAN) et les règles numériques suivent [TOULMIN](_index.md#공통-필드).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1040`). Les champs conditionnels de la disposition NODE et la largeur de SPAN fixée par SOURCE ne peuvent pas être déclarés par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001040/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000104000000000
BODY
#1 DECLARE 0x1040
#2 BIND #1 "COUNTER-DECLARE"
```
