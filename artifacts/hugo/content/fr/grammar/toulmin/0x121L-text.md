---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT est un enregistrement de texte original et de division d'un document TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT est un enregistrement de texte original et de division d'un document TOULMIN. Sens : nom ou chaîne.

| Élément | Valeur |
|---|---|
| Nom | `TEXT` (BIND du document de spécification `TEXT`) |
| TAG ID | `0x121L` |
| Codec ID | `0x00001210` |
| Document de spécification | `0x00000000/codecs/0x00001210/` (cible de DECLARE `1210`) |
| Section | 9 `1001` (Edge, format TOULMIN), décalage dans la section C = 1 |
| Kind | Edge · famille : format TOULMIN, disposition : ID, UTF8 Value |
| TAG WORD | `0001 0010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Nom ou chaîne |
| Côté Hugo | `edge/toulmin/source.md` |

## Disposition {#레이아웃}

C'est un nom ou une chaîne. Les listes F_WITH·F_GROUNDS de NODE, ainsi que [LABEL](0x134L-label.md) et [IMPORTED-FROM](0x133L-imported-from.md) de LINK, le désignent par REF.

```
ID
chaîne           enregistrement Value UTF8-TEXT
```

- ID est l'Edge Id, REF est l'Edge Id d'un enregistrement de ce document (champs communs de [TOULMIN](_index.md#공통-필드)). Il n'y a pas de champ Issuer ni de numéro de Codec : le Payload suit directement le TAG.

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1210`). La déclaration des champs sera fixée avec le document de spécification de Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [SOURCE et divisions](_index.md#source와-구획), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001210/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
