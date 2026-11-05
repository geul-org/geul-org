---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL est une Value qui représente les valeurs logiques false et true."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `BOOL` (document de spécification BIND `BOOL`) |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| Document de spécification | `0x00000000/codecs/0x00000600/` (cible DECLARE `0600`) |
| Section | 3 `0011` (Value), offset C dans la section = 0 |
| Kind | Value · famille : NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | false ou true sur 1 WORD fixe |
| Côté Hugo | `value/numeric/bool.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | valeur brute 1 WORD |  | `0x0000` false, `0x0001` true |

BOOL est une Value qui représente les valeurs logiques false et true. Son code direct Value est `0x060L`, sa famille est NUMERIC. C'est un type distinct de SIGNED-INTEGER et UNSIGNED-INTEGER, qui portent les nombres 0 et 1.

## Disposition {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  total 2 WORD
Payload           1 WORD  Boolean Code
```

## Interprétation et validité {#해석과-유효성}

- Le Payload `0000` est false, `0001` est true.
- Il n'y a ni padding ni descriptor.
- Le Payload vaut exactement `0000` ou `0001`. Toute autre valeur de 16 bits est rejetée comme invalid.
- Toute autre représentation de Length est rejetée comme invalid.

## Longueur {#길이}

- Le total est exactement de 2 WORD, soit 1 WORD de TAG plus 1 WORD de Payload, avec la longueur directe `LLLL=0001`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload n'est pas exactement de 1 WORD, il est rejeté.

## Exemple {#예시}

| Enregistrement complet (TAG + Payload) | Payload | Verdict |
|---|---|---|
| `0601 0000` | `0000` | false, canonique |
| `0601 0001` | `0001` | true, canonique |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| TAG dont la Length n'est pas `0001` + `0000` ou `0001` | `0000` ou `0001` | invalid |

## Statut de format {#형식-지위}

- Cette représentation, qui associe le code word de 16 bits `0000`/`0001` à un TAG GEUL, est un profil scalaire propre à GEUL.
- La valeur logique elle-même est universelle, mais on ne prétend à aucune norme industrielle unique correspondant à cette représentation sur 1 WORD.

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000600/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
