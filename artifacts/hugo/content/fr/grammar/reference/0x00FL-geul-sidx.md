---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX est une Reference de déclaration qui désigne une cible par un GEUL SIDX (Semantic-aligned Index)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `GEUL-SIDX` (groupe 5Q. Noms par code dans le tableau des membres ci-dessous) |
| TAG ID | `0x00FL~0x013L` |
| Section | 0 `0000` (entité Reference), offset dans la section C = 15~19 |
| Kind | Reference · classification : déclaration |
| Côté Hugo | `reference/geul-sidx.md` |

## Membres {#구성원}

Cette page traite d'un jeu complet du système 5Q, soit cinq codes. La quantification est l'offset dans la section `C % 5` ([Reference](_index.md#quantifier)). Il y a un document de Codec par code. Les champs des cinq documents de Codec sont identiques ; seuls la cible DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Quantification | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | valeur brute restante (`0xFFFF`) |  |  |

GEUL-SIDX est une Reference de déclaration qui désigne une cible par un GEUL SIDX (Semantic-aligned Index). Le SIDX est un identifiant dont les bits eux-mêmes portent du sens (type, attributs).

## Disposition {#레이아웃}

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[TAG d'extension de Length]
SIDX              tout le reste
```

- Le Quantifier est identique à celui des autres Codec de déclaration. Pour Variable, c'est une variable anonyme de ce type ([Reference](_index.md) Variable). La quantification se fait uniquement par le code 5Q (`0x00FL~0x013L`, `C % 5`). On ne met pas de quantification dans la valeur SIDX.
- Le document de spécification déclare le SIDX comme un unique champ de valeur brute de largeur restante. On le modifiera quand la règle de largeur sera fixée.

## Exemple {#예시}

| SIDX | Séquence de WORD |
|---|---|
| (non normatif) 64 bits `0x1234 5678 9ABC DEF0`, Identified | `00F4 1234 5678 9ABC DEF0` |

## Politique d'attribution {#배정-방침}

- Le rôle diffère de celui de [GEUL](0x00AL-geul.md). GEUL est un ID d'identité attribué en général dans l'ordre (auto increment) ; GEUL-SIDX est une adresse sémantique qui donne des valeurs proches à des cibles sémantiquement proches.
- Le degré de proximité se détermine statistiquement, en accumulant des données d'usage. Avant que les statistiques soient réunies, on utilise des GEUL ID ; après attribution d'un SIDX, on relie le GEUL et le GEUL-SIDX de la même cible par [SAME-NODE](../edge/0x0A1L-same-node.md).

## Problèmes ouverts {#열린-문제}

- **Largeur.** Elle sera décidée d'après les statistiques. On examine 4 WORD (64 bits) et 16 WORD, entre autres. Le SIDX porte du sens dans ses bits de poids fort, de sorte que la règle de la « largeur la plus courte » des autres Codec de déclaration (WORD `0x0000` en tête interdit) ne s'applique pas telle quelle. Ce sera donc une largeur fixe (ou une largeur fixe par sous-format). D'ici là, le document de spécification déclare le SIDX comme valeur brute de largeur restante.
- **Stabilité de l'attribution.** Une Reference désigne la même cible si sa valeur entière est égale, et un ID attribué n'est pas réutilisé. Pour ne pas déplacer un SIDX déjà attribué quand les statistiques changent, il faut une attribution append-only (attribution éparse qui laisse des places proches en sens). Si les déplacements sont fréquents, on décidera de définir le SIDX non comme un identifiant permanent mais comme un index lié à une édition du registre.
- **Unicité.** Si des SIDX générés d'après le sens de leurs bits peuvent entrer en collision, cela contredit la prémisse « valeur entière égale, même cible ». À l'attribution, on résout les collisions pour garantir l'unicité.
- Format de publication du livre de codes et du registre.

## Pages liées {#관련-페이지}

- [Reference](_index.md), [GEUL](0x00AL-geul.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x000000F0/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

Ce qui précède est le document de Codec de `GEUL-SIDX-IDENTIFIED` (`0x00FL`). Pour les autres membres (`GEUL-SIDX-GENERIC`, `GEUL-SIDX-FREE-CHOICE`, `GEUL-SIDX-UNIVERSAL`, `GEUL-SIDX-VARIABLE`), seuls le Codec ID du DOC-ID, la cible DECLARE et le nom lié (BIND) en `#1` diffèrent.
