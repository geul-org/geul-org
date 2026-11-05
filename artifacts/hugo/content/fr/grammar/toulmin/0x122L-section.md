---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION est un enregistrement de texte original et de division d'un document TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION est un enregistrement de texte original et de division d'un document TOULMIN. Sens : début de section.

| Élément | Valeur |
|---|---|
| Nom | `SECTION` (BIND du document de spécification `SECTION`) |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| Document de spécification | `0x00000000/codecs/0x00001220/` (cible de DECLARE `1220`) |
| Section | 9 `1001` (Edge, format TOULMIN), décalage dans la section C = 2 |
| Kind | Edge · famille : format TOULMIN, disposition : ID, code de section 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Début de section |
| Côté Hugo | `edge/toulmin/source.md` |

## Disposition {#레이아웃}

C'est le début d'une section. Le code de section est 1 WORD.

```
ID
code de section   1 WORD
```

| Code | Section | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | Règle à expression conditionnelle |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` n'est pas employé. Les sections sont déclarées dans l'ordre de ces codes.
- Le titre de la section est le [PROSE](0x125L-prose.md) qui suit immédiatement SECTION.

- ID est l'Edge Id, REF est l'Edge Id d'un enregistrement de ce document (champs communs de [TOULMIN](_index.md#공통-필드)). Il n'y a pas de champ Issuer ni de numéro de Codec : le Payload suit directement le TAG.

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1220`). La déclaration des champs sera fixée avec le document de spécification de Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [SOURCE et divisions](_index.md#source와-구획), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001220/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
