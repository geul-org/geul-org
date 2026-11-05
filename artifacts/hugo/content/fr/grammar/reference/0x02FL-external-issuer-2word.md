---
title: "EXTERNAL-ISSUER-2WORD (0x02FL~0x033L)"
weight: 47
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER est une Reference de désignation-déclaration qui cite, sans IMPORT et en un seul enregistrement, le LOCAL ID d'un document publié par un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER est une Reference de désignation-déclaration qui cite, sans IMPORT et en un seul enregistrement, le LOCAL ID d'un document publié par un Issuer.

| Élément | Valeur |
|---|---|
| Nom | `EXTERNAL-ISSUER-2WORD` (groupe 5Q. Noms par code dans le tableau des membres ci-dessous) |
| TAG ID | `0x02FL~0x033L` |
| Section | 1 `0001` (Reference EXTERNAL), offset dans la section C = 15~19 |
| Kind | Reference · classification : désignation-déclaration |
| Côté Hugo | `reference/external-issuer.md` (cette page traite aussi de [EXTERNAL-ISSUER-4WORD](0x034L-external-issuer-4word.md) et [EXTERNAL-ISSUER-16WORD](0x039L-external-issuer-16word.md)) |

## Membres {#구성원}

Cette page traite d'un jeu complet du système 5Q, soit cinq codes. La quantification est l'offset dans la section `C % 5` ([Reference](_index.md#quantifier)). Il y a un document de Codec par code. Les champs des cinq documents de Codec sont identiques ; seuls la cible DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Quantification | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x02FL` | `EXTERNAL-ISSUER-2WORD-IDENTIFIED` | Identified | `0x000002F0` | `0x00000000/codecs/0x000002F0/` | `0000 0010 1111 LLLL` |
| `0x030L` | `EXTERNAL-ISSUER-2WORD-GENERIC` | Generic | `0x00000300` | `0x00000000/codecs/0x00000300/` | `0000 0011 0000 LLLL` |
| `0x031L` | `EXTERNAL-ISSUER-2WORD-FREE-CHOICE` | Free-choice | `0x00000310` | `0x00000000/codecs/0x00000310/` | `0000 0011 0001 LLLL` |
| `0x032L` | `EXTERNAL-ISSUER-2WORD-UNIVERSAL` | Universal | `0x00000320` | `0x00000000/codecs/0x00000320/` | `0000 0011 0010 LLLL` |
| `0x033L` | `EXTERNAL-ISSUER-2WORD-VARIABLE` | Variable | `0x00000330` | `0x00000000/codecs/0x00000330/` | `0000 0011 0011 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valeur brute 2 WORD |  |  |
| 2 | `doc` | #3 | valeur brute 4 WORD |  |  |
| 3 | `target-id` | #4 | valeur brute restante (`0xFFFF`) |  |  |

EXTERNAL-ISSUER est une Reference de désignation-déclaration qui cite, sans IMPORT, le LOCAL ID d'un document publié par un Issuer. Un seul enregistrement suffit à en donner le sens, et elle suit la version la plus récente.

## Disposition {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (section 1)
[TAG d'extension de Length]
Issuer            largeur fixée par le Codec (2/4/16 WORD)
ID de document    4 WORD
ID de cible       tout le reste. LOCAL ID de ce document, sur la largeur la plus courte
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Nom | Largeur de l'Issuer |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (enregistré auprès de geul.org, preuve de domaine) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (enregistré auprès de geul.org, sans preuve) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (calculé à partir de la clé publique) |

- La largeur est fixée par le numéro de système : si système − 9 (`C / 5 − 3`, avec `C` l'offset dans la section) vaut 0, 1, 2, la largeur est 2, 4, 16 WORD. La quantification est `C % 5`.
- L'Issuer ID est une valeur entière. Si la valeur est égale, c'est le même Issuer. L'Issuer s'écrit sur la plus courte largeur où la valeur tient, et l'on choisit le Codec de cette largeur (4 WORD seulement à partir de `2^32`, 16 WORD seulement à partir de `2^64`). Une notation plus large est invalid ([Issuer](../issuer.md)).
- L'enregistrement et la gestion des Issuer relèvent de geul.org.
- La version n'est pas indiquée ; on suit la version la plus récente. Pour fixer la version, on utilise [IMPORT-DOC](../meta/0x1E4L-import-doc.md) et [EXTERNAL-POINTER](0x020L-external-pointer-1word.md).
- L'emplacement se trouve par la règle d'adresse de publication ([adresse de publication et liste des versions](../publishing.md)).
- Pour un même LOCAL ID de ce document, c'est la même cible, qu'on l'écrive en LOCAL dans ce document, en EXTERNAL-ISSUER dans un autre document (ou en EXTERNAL-POINTER après IMPORT).
- Elle ne désigne que le LOCAL d'un document. Le document lui-même se désigne par [DOC-POINTER](0x041L-doc-pointer.md), l'Issuer lui-même par [ISSUER-POINTER](0x040L-issuer-pointer.md). L'ID de cible n'est donc pas `0`. L'ID de document `0` est le document d'index des définitions de termes de l'Issuer.

## Validité {#유효성}

- Si la largeur de l'Issuer ne correspond pas au Codec, ou si la valeur tient dans une largeur plus étroite, c'est invalid.
- Si l'ID de cible vaut `0`, c'est invalid. L'ID de cible `0` (le document lui-même) relève de DOC-POINTER.
- Un WORD `0x0000` en tête de l'ID de cible est interdit.

## Exemple {#예시}

| Cible | Séquence de WORD |
|---|---|
| Issuer `0x00000002`, document `0x…0002`, LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, document `0x…0002`, LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## Pages liées {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer et publication](../issuer.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x000002F0/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000002F000000000
BODY
#1 DECLARE 0x02F0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-2WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

Ce qui précède est le document de Codec de `EXTERNAL-ISSUER-2WORD-IDENTIFIED` (`0x02FL`). Pour les autres membres (`EXTERNAL-ISSUER-2WORD-GENERIC`, `EXTERNAL-ISSUER-2WORD-FREE-CHOICE`, `EXTERNAL-ISSUER-2WORD-UNIVERSAL`, `EXTERNAL-ISSUER-2WORD-VARIABLE`), seuls le Codec ID du DOC-ID, la cible DECLARE et le nom lié (BIND) en `#1` diffèrent.
