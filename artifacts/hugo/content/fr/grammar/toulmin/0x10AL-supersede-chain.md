---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN est un Codec Edge TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN est un Codec Edge TOULMIN. Sens : chaîne de priorité `A > B > C`. Abréviation des SUPERSEDES par paires.

| Élément | Valeur |
|---|---|
| Nom | `SUPERSEDE-CHAIN` (BIND du document de spécification `SUPERSEDE-CHAIN`) |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| Document de spécification | `0x00000000/codecs/0x000010A0/` (cible de DECLARE `10A0`) |
| Section | 8 `1000` (Edge TOULMIN), décalage dans la section C = 10 |
| Kind | Edge · famille : TOULMIN, groupe : relation |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Chaîne de priorité `A > B > C`. Abréviation des SUPERSEDES par paires. Disposition non fixée |
| Côté Hugo | `edge/toulmin/_index.md` |

## Disposition {#레이아웃}

Seul le code est attribué, il n'y a pas encore de disposition ([TOULMIN](_index.md#열린-문제)).

- Pour l'instant, on écrit un [SUPERSEDES](0x109L-supersedes.md) par paire. Savoir si cela suffit pour une chaîne est un problème ouvert.

## Document de Codec {#코덱-문서}

La disposition n'est pas fixée. Le document de Codec ne porte qu'un DECLARE (cible `10A0`). FIELD sera ajouté quand la disposition sera fixée.

## Pages liées {#관련-페이지}

- [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x000010A0/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
