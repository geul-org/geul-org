---
title: "SUPERSEDES (0x109L)"
weight: 265
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDES est le Codec LINK qui écrit une relation du graphe TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDES est le Codec LINK qui écrit une relation du graphe TOULMIN. Sens : relation d'exclusion. Si l'attaquant est Active, la cible est retirée de l'agrégation de façon déterministe. Une chaîne (`A > B > C`) s'écrit avec une relation par paire.

| Élément | Valeur |
|---|---|
| Nom | `SUPERSEDES` (BIND du document de spécification `SUPERSEDES`) |
| TAG ID | `0x109L` |
| Codec ID | `0x00001090` |
| Document de spécification | `0x00000000/codecs/0x00001090/` (cible de DECLARE `1090`) |
| Section | 8 `1000` (Edge TOULMIN), décalage dans la section C = 9 |
| Kind | Edge · famille : TOULMIN, groupe : relation, disposition : LINK |
| TAG WORD | `0001 0000 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Relation d'exclusion. Si l'attaquant est Active, la cible est retirée de l'agrégation de façon déterministe. Une chaîne (`A > B > C`) s'écrit avec une relation par paire |
| Côté Hugo | `edge/toulmin/link.md` |

## Disposition {#레이아웃}

La disposition est [LINK](_index.md#link) (ID, src, dst, flags, champs conditionnels, SPAN).

| Élément | Valeur |
|---|---|
| TANGEUL | `X supersedes Y` |
| src → dst | règle → règle. Si Active, retire la cible de l'agrégation |

- Une chaîne `A > B > C` de SUPERSEDES s'écrit avec un SUPERSEDES par paire. L'abréviation [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) n'a pas encore de disposition.
- F_FORCE n'est pas employé (s'il est allumé, on refuse).
- Les champs communs (ID, REF, SPAN) et les règles numériques suivent [TOULMIN](_index.md#공통-필드).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1090`). Les champs conditionnels de la disposition LINK et la largeur de SPAN fixée par SOURCE ne peuvent pas être déclarés par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001090/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000109000000000
BODY
#1 DECLARE 0x1090
#2 BIND #1 "SUPERSEDES"
```
