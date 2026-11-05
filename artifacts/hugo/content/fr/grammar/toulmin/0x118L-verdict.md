---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT est un Codec Edge TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT est un Codec Edge TOULMIN. Sens : résultat de verdict d'un nœud ou d'un enregistrement. Résultat (Pass, Review, Fail), valeur de verdict, Activated, Excluded, Level.

| Élément | Valeur |
|---|---|
| Nom | `VERDICT` (BIND du document de spécification `VERDICT`) |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| Document de spécification | `0x00000000/codecs/0x00001180/` (cible de DECLARE `1180`) |
| Section | 8 `1000` (Edge TOULMIN), décalage dans la section C = 24 |
| Kind | Edge · famille : TOULMIN, groupe : résultat |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Résultat de verdict d'un nœud ou d'un enregistrement. Résultat (Pass, Review, Fail), valeur de verdict, Activated, Excluded, Level. Disposition non fixée |
| Côté Hugo | `edge/toulmin/_index.md` |

## Disposition {#레이아웃}

Seul le code est attribué, il n'y a pas encore de disposition ([TOULMIN](_index.md#열린-문제)).

- Le verdict d'un document entier revient au Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`). Ce sont deux Codec distincts, de Kind différents.
- Les résultats de verdict se placent dans un autre document que la cible du verdict ([TOULMIN](_index.md#판정-결과)).

## Document de Codec {#코덱-문서}

La disposition n'est pas fixée. Le document de Codec ne porte qu'un DECLARE (cible `1180`). FIELD sera ajouté quand la disposition sera fixée.

## Pages liées {#관련-페이지}

- [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001180/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
