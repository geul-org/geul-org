---
title: "WIKIDATA-QID (0x014L~0x018L)"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID est une Reference de déclaration qui désigne un élément (Item) de Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `WIKIDATA-QID` (groupe 5Q. Noms par code dans le tableau des membres ci-dessous) |
| TAG ID | `0x014L~0x018L` |
| Section | 0 `0000` (entité Reference), offset dans la section C = 20~24 |
| Kind | Reference · classification : déclaration |
| Côté Hugo | `reference/wikidata-qid.md` |

## Membres {#구성원}

Cette page traite d'un jeu complet du système 5Q, soit cinq codes. La quantification est l'offset dans la section `C % 5` ([Reference](_index.md#quantifier)). Il y a un document de Codec par code. Les champs des cinq documents de Codec sont identiques ; seuls la cible DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Quantification | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x014L` | `WIKIDATA-QID-IDENTIFIED` | Identified | `0x00000140` | `0x00000000/codecs/0x00000140/` | `0000 0001 0100 LLLL` |
| `0x015L` | `WIKIDATA-QID-GENERIC` | Generic | `0x00000150` | `0x00000000/codecs/0x00000150/` | `0000 0001 0101 LLLL` |
| `0x016L` | `WIKIDATA-QID-FREE-CHOICE` | Free-choice | `0x00000160` | `0x00000000/codecs/0x00000160/` | `0000 0001 0110 LLLL` |
| `0x017L` | `WIKIDATA-QID-UNIVERSAL` | Universal | `0x00000170` | `0x00000000/codecs/0x00000170/` | `0000 0001 0111 LLLL` |
| `0x018L` | `WIKIDATA-QID-VARIABLE` | Variable | `0x00000180` | `0x00000000/codecs/0x00000180/` | `0000 0001 1000 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `qid` | #2 | valeur brute restante (`0xFFFF`) |  |  |

WIKIDATA-QID est une Reference de déclaration qui désigne un élément (Item) de Wikidata. On écrit la partie numérique du Q-id, sans le `Q`, comme entier non signé.

## Disposition {#레이아웃}

```
TAG WORD          0000 0001 0100 LLLL      Codec 0x014L~0x018L (Identified 0x014L)
[TAG d'extension de Length]
QID               unsigned big-endian sur la largeur la plus courte
```

- Le QID s'écrit sur la largeur la plus courte. `Q1`~`Q65535` font 2 WORD au total, au-delà 3 WORD.
- Les données de Wikidata sont sous CC0.
- Pour Variable, c'est une variable anonyme du type que désigne cet élément ([Reference](_index.md) Variable).

## Exemple {#예시}

| Élément | Séquence de WORD |
|---|---|
| `Q5` (human) | `0141 0005` |
| `Q76` (Barack Obama) | `0141 004C` |
| `Q884` (South Korea) | `0141 0374` |
| `Q317521` (Elon Musk) | `0142 0004 D851` |
| `Q30461` (president), Variable | `0181 76FD` |

## Pages liées {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-PID](0x019L-wikidata-pid.md), [TRIPLE](../edge/0x0AAL-triple.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000140/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000014000000000
BODY
#1 DECLARE 0x0140
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-QID-IDENTIFIED"
#4 BIND #2 "qid"
```

Ce qui précède est le document de Codec de `WIKIDATA-QID-IDENTIFIED` (`0x014L`). Pour les autres membres (`WIKIDATA-QID-GENERIC`, `WIKIDATA-QID-FREE-CHOICE`, `WIKIDATA-QID-UNIVERSAL`, `WIKIDATA-QID-VARIABLE`), seuls le Codec ID du DOC-ID, la cible DECLARE et le nom lié (BIND) en `#1` diffèrent.
