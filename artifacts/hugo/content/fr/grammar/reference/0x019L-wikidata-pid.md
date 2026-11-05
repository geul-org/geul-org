---
title: "WIKIDATA-PID (0x019L~0x01DL)"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID est une Reference de déclaration qui désigne une propriété (Property) de Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `WIKIDATA-PID` (groupe 5Q. Noms par code dans le tableau des membres ci-dessous) |
| TAG ID | `0x019L~0x01DL` |
| Section | 0 `0000` (entité Reference), offset dans la section C = 25~29 |
| Kind | Reference · classification : déclaration |
| Côté Hugo | `reference/wikidata-pid.md` |

## Membres {#구성원}

Cette page traite d'un jeu complet du système 5Q, soit cinq codes. La quantification est l'offset dans la section `C % 5` ([Reference](_index.md#quantifier)). Il y a un document de Codec par code. Les champs des cinq documents de Codec sont identiques ; seuls la cible DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Quantification | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x019L` | `WIKIDATA-PID-IDENTIFIED` | Identified | `0x00000190` | `0x00000000/codecs/0x00000190/` | `0000 0001 1001 LLLL` |
| `0x01AL` | `WIKIDATA-PID-GENERIC` | Generic | `0x000001A0` | `0x00000000/codecs/0x000001A0/` | `0000 0001 1010 LLLL` |
| `0x01BL` | `WIKIDATA-PID-FREE-CHOICE` | Free-choice | `0x000001B0` | `0x00000000/codecs/0x000001B0/` | `0000 0001 1011 LLLL` |
| `0x01CL` | `WIKIDATA-PID-UNIVERSAL` | Universal | `0x000001C0` | `0x00000000/codecs/0x000001C0/` | `0000 0001 1100 LLLL` |
| `0x01DL` | `WIKIDATA-PID-VARIABLE` | Variable | `0x000001D0` | `0x00000000/codecs/0x000001D0/` | `0000 0001 1101 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `pid` | #2 | valeur brute restante (`0xFFFF`) |  |  |

WIKIDATA-PID est une Reference de déclaration qui désigne une propriété (Property) de Wikidata. On écrit la partie numérique du P-id, sans le `P`, comme entier non signé.

## Disposition {#레이아웃}

```
TAG WORD          0000 0001 1001 LLLL      Codec 0x019L~0x01DL (Identified 0x019L)
[TAG d'extension de Length]
PID               unsigned big-endian sur la largeur la plus courte
```

- Le PID s'écrit sur la largeur la plus courte. Les numéros de propriété actuels tiennent dans 1 WORD, soit 2 WORD au total ; au-delà de 65535, cela passe naturellement à 3 WORD.
- On l'emploie surtout à la place du Predicate de [TRIPLE](../edge/0x0AAL-triple.md) et de la Property de [QUALIFIER](../edge/0x0ABL-qualifier.md).

## Exemple {#예시}

| Propriété | Séquence de WORD |
|---|---|
| `P31` (instance of) | `0191 001F` |
| `P279` (subclass of) | `0191 0117` |
| `P569` (date of birth) | `0191 0239` |

## Pages liées {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-QID](0x014L-wikidata-qid.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000190/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000019000000000
BODY
#1 DECLARE 0x0190
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-PID-IDENTIFIED"
#4 BIND #2 "pid"
```

Ce qui précède est le document de Codec de `WIKIDATA-PID-IDENTIFIED` (`0x019L`). Pour les autres membres (`WIKIDATA-PID-GENERIC`, `WIKIDATA-PID-FREE-CHOICE`, `WIKIDATA-PID-UNIVERSAL`, `WIKIDATA-PID-VARIABLE`), seuls le Codec ID du DOC-ID, la cible DECLARE et le nom lié (BIND) en `#1` diffèrent.
