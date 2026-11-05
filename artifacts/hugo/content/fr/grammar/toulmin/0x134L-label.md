---
title: "LABEL (0x134L)"
weight: 308
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LABEL est le Codec LINK qui écrit une relation du graphe TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL est le Codec LINK qui écrit une relation du graphe TOULMIN. Sens : nœud → TEXT, notation du nom.

| Élément | Valeur |
|---|---|
| Nom | `LABEL` (BIND du document de spécification `LABEL`) |
| TAG ID | `0x134L` |
| Codec ID | `0x00001340` |
| Document de spécification | `0x00000000/codecs/0x00001340/` (cible de DECLARE `1340`) |
| Section | 9 `1001` (Edge, format TOULMIN), décalage dans la section C = 20 |
| Kind | Edge · famille : format TOULMIN, disposition : LINK |
| TAG WORD | `0001 0011 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Nœud → TEXT, notation du nom |
| Côté Hugo | `edge/toulmin/link.md` |

## Disposition {#레이아웃}

La disposition est [LINK](_index.md#link) (ID, src, dst, flags, champs conditionnels, SPAN).

| Élément | Valeur |
|---|---|
| TANGEUL | nom entre accents graves |
| src → dst | nœud → TEXT. Notation du nom |

- dst est le REF d'un enregistrement TEXT. Faut-il exprimer les noms entre accents graves par [LABEL](../edge/0x0A4L-label.md)·[BIND](../edge/0x0A3L-bind.md) d'énoncé : c'est un problème ouvert ([TOULMIN](_index.md#열린-문제)).
- F_FORCE n'est pas employé (s'il est allumé, on refuse).
- Les champs communs (ID, REF, SPAN) et les règles numériques suivent [TOULMIN](_index.md#공통-필드).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1340`). Les champs conditionnels de la disposition LINK et la largeur de SPAN fixée par SOURCE ne peuvent pas être déclarés par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001340/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000134000000000
BODY
#1 DECLARE 0x1340
#2 BIND #1 "LABEL"
```
