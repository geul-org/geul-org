---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE est un enregistrement de texte original et de division d'un document TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE est un enregistrement de texte original et de division d'un document TOULMIN. Sens : paragraphe descriptif.

| Élément | Valeur |
|---|---|
| Nom | `PROSE` (BIND du document de spécification `PROSE`) |
| TAG ID | `0x125L` |
| Codec ID | `0x00001250` |
| Document de spécification | `0x00000000/codecs/0x00001250/` (cible de DECLARE `1250`) |
| Section | 9 `1001` (Edge, format TOULMIN), décalage dans la section C = 5 |
| Kind | Edge · famille : format TOULMIN, disposition : ID, SPAN |
| TAG WORD | `0001 0010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Paragraphe descriptif |
| Côté Hugo | `edge/toulmin/source.md` |

## Disposition {#레이아웃}

C'est un paragraphe descriptif qui n'est pas une règle. Il ne désigne qu'une plage (SPAN) du texte original.

```
ID
SPAN             largeur fixée par SOURCE × 2 (octet de début, nombre d'octets)
```

- ID est l'Edge Id, REF est l'Edge Id d'un enregistrement de ce document (champs communs de [TOULMIN](_index.md#공통-필드)). Il n'y a pas de champ Issuer ni de numéro de Codec : le Payload suit directement le TAG.

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1250`). La largeur de SPAN étant fixée par SOURCE, elle ne peut pas être déclarée par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [SOURCE et divisions](_index.md#source와-구획), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001250/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
