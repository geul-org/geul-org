---
title: "ALIAS (0x129L)"
weight: 297
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ALIAS est le Codec NODE qui écrit un nœud du graphe TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS est le Codec NODE qui écrit un nœud du graphe TOULMIN. Sens : `see … from`. Alias de paquet importé.

| Élément | Valeur |
|---|---|
| Nom | `ALIAS` (BIND du document de spécification `ALIAS`) |
| TAG ID | `0x129L` |
| Codec ID | `0x00001290` |
| Document de spécification | `0x00000000/codecs/0x00001290/` (cible de DECLARE `1290`) |
| Section | 9 `1001` (Edge, format TOULMIN), décalage dans la section C = 9 |
| Kind | Edge · famille : format TOULMIN, disposition : NODE |
| TAG WORD | `0001 0010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | `see … from`. Alias de paquet importé |
| Côté Hugo | `edge/toulmin/node.md` |

## Disposition {#레이아웃}

La disposition est [NODE](_index.md#node). 1 WORD d'en-tête fixe le role, le level, la forme de Claim et les champs conditionnels.

| Élément | Valeur |
|---|---|
| TANGEUL | `see a from path` |
| Nœud | Alias de paquet importé |

- role doit valoir 0.
- Les champs communs (ID, REF, SPAN) et les règles numériques suivent [TOULMIN](_index.md#공통-필드).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1290`). Les champs conditionnels de la disposition NODE et la largeur de SPAN fixée par SOURCE ne peuvent pas être déclarés par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001290/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000129000000000
BODY
#1 DECLARE 0x1290
#2 BIND #1 "ALIAS"
```
