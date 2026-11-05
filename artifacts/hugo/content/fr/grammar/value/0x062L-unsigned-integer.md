---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER est une Value qui représente un entier non signé."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `UNSIGNED-INTEGER` (document de spécification BIND `UNSIGNED-INTEGER`) |
| TAG ID | `0x062L` |
| Codec ID | `0x00000620` |
| Document de spécification | `0x00000000/codecs/0x00000620/` (cible DECLARE `0620`) |
| Section | 3 `0011` (Value), offset C dans la section = 2 |
| Kind | Value · famille : NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | entier en unsigned magnitude big-endian sur un nombre minimal de WORD |
| Côté Hugo | `value/numeric/unsigned-integer.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | valeur brute restante (`0xFFFF`) |  |  |

UNSIGNED-INTEGER est une Value qui représente un entier non signé. Son code direct Value est `0x062L`, sa famille est NUMERIC. L'ensemble du Payload est lu comme une unsigned magnitude de précision arbitraire, dans l'ordre des WORD big-endian. Le Payload fait au moins 1 WORD et seule la représentation canonique à nombre minimal de WORD est admise.

## Disposition {#레이아웃}

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1st  (WORD de poids fort)   Unsigned Magnitude 1st
...
Payload WORD Nth  (WORD de poids faible) Unsigned Magnitude Nth
```

## Interprétation {#해석}

- Le premier WORD du Payload occupe la position la plus haute, le dernier WORD la plus basse.
- Si le Payload compte N WORD, il est lu comme une seule unsigned magnitude de `16N` bits.
- Cette largeur n'est pas une largeur de stockage déclarée et il n'y a pas de descriptor de largeur en bits.

## Représentation canonique {#정규-표현}

- 0 est le Payload de 1 WORD `0000`.
- Lorsque le Payload compte 2 WORD ou plus, un premier WORD égal à `0000` est non canonique, car le supprimer ne change pas la valeur.
- Le décodeur doit rejeter les représentations comportant des WORD zéro de tête superflus.

## Longueur {#길이}

- Le total est le nombre de WORD du TAG (1 WORD), du TAG d'extension de Length (s'il existe) et du Payload. Jusqu'à 14 WORD, on utilise la longueur directe ; à partir de 15 WORD, la longueur étendue `1110`·`1111`, et le TAG d'extension compte aussi dans le total ([Enregistrement et TAG WORD](../record.md)).
- Les largeurs déclarées telles que UINT8, UINT16 ou UINT32 ne sont pas conservées, seule la valeur numérique l'est.

## Exemple {#예시}

| Valeur | WORD du Payload | Verdict |
|---:|---|---|
| 0 | `0000` | canonique |
| 1 | `0001` | canonique |
| 65535 | `FFFF` | canonique |
| 65536 | `0001 0000` | canonique |
| 1 | `0000 0001` | non canonique : `0000` de tête superflu |
| Payload de 7 WORD | les 7 WORD après le TAG `0627` (longueur directe `LLLL=0111`, 8 WORD au total) | canonique |
| Payload de 7 WORD | les 7 WORD après un TAG de longueur étendue et la valeur d'extension `0009` | non canonique : jusqu'à 14 WORD, on utilise la longueur directe |

## Statut de format {#형식-지위}

- Cette représentation, qui normalise une unsigned magnitude de précision arbitraire en une suite de WORD de 16 bits au minimum et l'associe à un TAG GEUL, est un profil scalaire propre à GEUL.
- Pour échanger avec des types externes à largeur fixe comme UINT8/16/32/64, un contrôle d'intervalle et une conversion de largeur explicite sont nécessaires.

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000620/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
