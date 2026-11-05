---
title: "DO-ONCE (0x112L)"
weight: 274
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "DO-ONCE est le Codec LINK qui écrit une relation du graphe TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DO-ONCE est le Codec LINK qui écrit une relation du graphe TOULMIN. Sens : action exécutée une seule fois même en cas de nouvelle tentative.

| Élément | Valeur |
|---|---|
| Nom | `DO-ONCE` (BIND du document de spécification `DO-ONCE`) |
| TAG ID | `0x112L` |
| Codec ID | `0x00001120` |
| Document de spécification | `0x00000000/codecs/0x00001120/` (cible de DECLARE `1120`) |
| Section | 8 `1000` (Edge TOULMIN), décalage dans la section C = 18 |
| Kind | Edge · famille : TOULMIN, groupe : exécution, disposition : LINK |
| TAG WORD | `0001 0001 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Action exécutée une seule fois même en cas de nouvelle tentative |
| Côté Hugo | `edge/toulmin/link.md` |

## Disposition {#레이아웃}

La disposition est [LINK](_index.md#link) (ID, src, dst, flags, champs conditionnels, SPAN).

| Élément | Valeur |
|---|---|
| TANGEUL | `do fn once when n` |
| src → dst | règle → FuncRef |

- dst est un FuncRef. `do … once` est exprimé par ce Codec. On n'emploie pas F_ONCE dans flags (s'il est allumé, on refuse).
- F_FORCE n'est pas employé (s'il est allumé, on refuse).
- Les champs communs (ID, REF, SPAN) et les règles numériques suivent [TOULMIN](_index.md#공통-필드).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1120`). Les champs conditionnels de la disposition LINK et la largeur de SPAN fixée par SOURCE ne peuvent pas être déclarés par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001120/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000112000000000
BODY
#1 DECLARE 0x1120
#2 BIND #1 "DO-ONCE"
```
