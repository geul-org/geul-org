---
title: "RUNS (0x12EL)"
weight: 302
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RUNS est le Codec LINK qui écrit une relation du graphe TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RUNS est le Codec LINK qui écrit une relation du graphe TOULMIN. Sens : point d'entrée → cas, exécution.

| Élément | Valeur |
|---|---|
| Nom | `RUNS` (BIND du document de spécification `RUNS`) |
| TAG ID | `0x12EL` |
| Codec ID | `0x000012E0` |
| Document de spécification | `0x00000000/codecs/0x000012E0/` (cible de DECLARE `12E0`) |
| Section | 9 `1001` (Edge, format TOULMIN), décalage dans la section C = 14 |
| Kind | Edge · famille : format TOULMIN, disposition : LINK |
| TAG WORD | `0001 0010 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Point d'entrée → cas, exécution |
| Côté Hugo | `edge/toulmin/link.md` |

## Disposition {#레이아웃}

La disposition est [LINK](_index.md#link) (ID, src, dst, flags, champs conditionnels, SPAN).

| Élément | Valeur |
|---|---|
| TANGEUL | point d'entrée `run c` |
| src → dst | point d'entrée → cas (exécution) |

- dst est le REF d'un nœud.
- F_FORCE n'est pas employé (s'il est allumé, on refuse).
- Les champs communs (ID, REF, SPAN) et les règles numériques suivent [TOULMIN](_index.md#공통-필드).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `12E0`). Les champs conditionnels de la disposition LINK et la largeur de SPAN fixée par SOURCE ne peuvent pas être déclarés par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x000012E0/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012E000000000
BODY
#1 DECLARE 0x12E0
#2 BIND #1 "RUNS"
```
