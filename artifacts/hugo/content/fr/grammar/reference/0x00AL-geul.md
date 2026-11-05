---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL est une Reference de déclaration qui désigne une entité émise par geul.org sous CC0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `GEUL` (groupe 5Q. Noms par code dans le tableau des membres ci-dessous) |
| TAG ID | `0x00AL~0x00EL` |
| Section | 0 `0000` (entité Reference), offset dans la section C = 10~14 |
| Kind | Reference · classification : déclaration |
| Côté Hugo | `reference/geul.md` |

## Membres {#구성원}

Cette page traite d'un jeu complet du système 5Q, soit cinq codes. La quantification est l'offset dans la section `C % 5` ([Reference](_index.md#quantifier)). Il y a un document de Codec par code. Les champs des cinq documents de Codec sont identiques ; seuls la cible DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Quantification | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | valeur brute restante (`0xFFFF`) |  |  |

GEUL est une Reference de déclaration qui désigne une entité émise par geul.org sous CC0. C'est un ID séquentiel dont le numéro ne porte pas de sens. L'identifiant qui porte du sens dans ses bits relève d'un Codec distinct, [GEUL-SIDX](0x00FL-geul-sidx.md) (`0x00FL~0x013L`).

## Disposition {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[TAG d'extension de Length]
GEUL ID           unsigned big-endian sur la largeur la plus courte
```

- On attribue les petits numéros aux entités les plus fréquentes. Un ID qui tient dans 1 WORD donne 2 WORD au total.
- L'attribution des ID et le registre sont gérés par geul.org. On ne met dans le registre que ce qui provient de sources CC0.
- Pour Variable, c'est une variable anonyme de ce type ([Reference](_index.md) Variable).

## Exemple {#예시}

| GEUL ID | Séquence de WORD |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## Problèmes ouverts {#열린-문제}

- Règle d'attribution des GEUL ID et format de publication du registre.

## Pages liées {#관련-페이지}

- [Reference](_index.md), [GEUL-SIDX](0x00FL-geul-sidx.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x000000A0/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

Ce qui précède est le document de Codec de `GEUL-IDENTIFIED` (`0x00AL`). Pour les autres membres (`GEUL-GENERIC`, `GEUL-FREE-CHOICE`, `GEUL-UNIVERSAL`, `GEUL-VARIABLE`), seuls le Codec ID du DOC-ID, la cible DECLARE et le nom lié (BIND) en `#1` diffèrent.
