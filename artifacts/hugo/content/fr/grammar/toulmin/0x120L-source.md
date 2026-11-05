---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE est un enregistrement de texte original et de division d'un document TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE est un enregistrement de texte original et de division d'un document TOULMIN. Sens : texte original d'écriture.

| Élément | Valeur |
|---|---|
| Nom | `SOURCE` (BIND du document de spécification `SOURCE`) |
| TAG ID | `0x120L` |
| Codec ID | `0x00001200` |
| Document de spécification | `0x00000000/codecs/0x00001200/` (cible de DECLARE `1200`) |
| Section | 9 `1001` (Edge, format TOULMIN), décalage dans la section C = 0 |
| Kind | Edge · famille : format TOULMIN, disposition : ID, WORD de largeur SPAN, UTF8 Value |
| TAG WORD | `0001 0010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Texte original d'écriture |
| Côté Hugo | `edge/toulmin/source.md` |

## Disposition {#레이아웃}

C'est la totalité du texte original d'écriture. Tout SPAN est une plage d'octets à l'intérieur de ce texte original.

```
ID
WORD de largeur SPAN   2 bits de poids fort = largeur (00=1, 01=2, 10=4, 11=8 WORD), 14 autres bits = 0
texte original   enregistrement Value UTF8-TEXT
```

- SOURCE est le premier enregistrement du BODY. Il y en a un par document.
- SPAN comprend deux champs : l'octet de début et le nombre d'octets. Chaque champ est un entier unsigned dont la largeur (1/2/4/8 WORD) est fixée par le WORD de largeur SPAN.
- C'est un Codec différent de l'Edge de fondement [SOURCE](../edge/0x0C0L-source.md) (`0x0C0L`).

- ID est l'Edge Id, REF est l'Edge Id d'un enregistrement de ce document (champs communs de [TOULMIN](_index.md#공통-필드)). Il n'y a pas de champ Issuer ni de numéro de Codec : le Payload suit directement le TAG.

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1200`). La déclaration des champs sera fixée avec le document de spécification de Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [SOURCE et divisions](_index.md#source와-구획), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001200/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
