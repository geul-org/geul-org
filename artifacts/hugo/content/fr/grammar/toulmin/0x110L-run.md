---
title: "RUN (0x110L)"
weight: 272
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RUN est le Codec LINK qui écrit une relation du graphe TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RUN est le Codec LINK qui écrit une relation du graphe TOULMIN. Sens : composition d'exécution. Si le nœud est Active, exécute le cas inférieur (DAG).

| Élément | Valeur |
|---|---|
| Nom | `RUN` (BIND du document de spécification `RUN`) |
| TAG ID | `0x110L` |
| Codec ID | `0x00001100` |
| Document de spécification | `0x00000000/codecs/0x00001100/` (cible de DECLARE `1100`) |
| Section | 8 `1000` (Edge TOULMIN), décalage dans la section C = 16 |
| Kind | Edge · famille : TOULMIN, groupe : exécution, disposition : LINK |
| TAG WORD | `0001 0001 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Composition d'exécution. Si le nœud est Active, exécute le cas inférieur (DAG) |
| Côté Hugo | `edge/toulmin/link.md` |

## Disposition {#레이아웃}

La disposition est [LINK](_index.md#link) (ID, src, dst, flags, champs conditionnels, SPAN).

| Élément | Valeur |
|---|---|
| TANGEUL | `run c when n` |
| src → dst | règle → cas |

- dst est le REF d'un nœud.
- F_FORCE n'est pas employé (s'il est allumé, on refuse).
- Les champs communs (ID, REF, SPAN) et les règles numériques suivent [TOULMIN](_index.md#공통-필드).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1100`). Les champs conditionnels de la disposition LINK et la largeur de SPAN fixée par SOURCE ne peuvent pas être déclarés par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001100/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000110000000000
BODY
#1 DECLARE 0x1100
#2 BIND #1 "RUN"
```
