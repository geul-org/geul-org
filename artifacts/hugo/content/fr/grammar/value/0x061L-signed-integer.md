---
title: "SIGNED-INTEGER (0x061L)"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER est une Value qui représente un entier signé."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `SIGNED-INTEGER` (document de spécification BIND `SIGNED-INTEGER`) |
| TAG ID | `0x061L` |
| Codec ID | `0x00000610` |
| Document de spécification | `0x00000000/codecs/0x00000610/` (cible DECLARE `0610`) |
| Section | 3 `0011` (Value), offset C dans la section = 1 |
| Kind | Value · famille : NUMERIC |
| TAG WORD | `0000 0110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | entier signé en complément à deux sur un nombre minimal de WORD |
| Côté Hugo | `value/numeric/signed-integer.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `integer` | #2 | valeur brute restante (`0xFFFF`) |  |  |

SIGNED-INTEGER est une Value qui représente un entier signé. Son code direct Value est `0x061L`, sa famille est NUMERIC. L'ensemble du Payload est lu comme un entier en complément à deux de précision arbitraire, dans l'ordre des WORD big-endian. Le Payload fait au moins 1 WORD et seule la représentation canonique à nombre minimal de WORD est admise.

## Disposition {#레이아웃}

```
TAG WORD          0000 0110 0001 LLLL      Codec 0x061L
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1st  (WORD de poids fort)   Integer 1st
...
Payload WORD Nth  (WORD de poids faible) Integer Nth
```

## Interprétation {#해석}

- Le bit de poids fort du premier WORD du Payload est le bit de signe de l'entier complet.
- Tous les WORD du Payload sont lus comme une seule suite de bits en complément à deux. Le premier WORD occupe les positions les plus hautes, le dernier les plus basses.
- Si le Payload compte N WORD, la largeur d'interprétation est de `16N` bits. Cette largeur n'est pas une largeur de stockage déclarée, c'est la largeur de représentation de la valeur, déterminée par la représentation canonique.
- Il n'y a ni Byte Count ni descriptor de largeur en bits.

## Représentation canonique {#정규-표현}

- 0 est le Payload de 1 WORD `0000`.
- Les WORD d'extension de signe en tête qui ne changent pas la valeur sont interdits.
- Lorsque le Payload compte 2 WORD ou plus, les cas suivants sont non canoniques.
  - Le premier WORD est `0000` et le bit de poids fort du WORD suivant est 0
  - Le premier WORD est `FFFF` et le bit de poids fort du WORD suivant est 1
- Le `0000` de tête qui préserve le signe d'un nombre positif est admis lorsque le bit de poids fort du WORD suivant est 1.
- Le `FFFF` de tête qui préserve le signe d'un nombre négatif est admis lorsque le bit de poids fort du WORD suivant est 0.
- Le décodeur doit rejeter les représentations non canoniques.

## Longueur {#길이}

- Le total est le nombre de WORD du TAG (1 WORD), du TAG d'extension de Length (s'il existe) et du Payload. Jusqu'à 14 WORD, on utilise la longueur directe ; à partir de 15 WORD, la longueur étendue `1110`·`1111`, et le TAG d'extension compte aussi dans le total ([Enregistrement et TAG WORD](../record.md)).
- Les largeurs déclarées telles que INT8, INT16 ou INT32 ne sont pas conservées, seule la valeur numérique l'est. De `-32768` à `32767`, c'est 1 WORD ; hors de cet intervalle, on ajoute autant de WORD que nécessaire. Il n'existe pas de format SIGNED-INT8 distinct.

## Exemple {#예시}

| Valeur | WORD du Payload | Verdict |
|---:|---|---|
| 0 | `0000` | canonique |
| 1 | `0001` | canonique |
| 32767 | `7FFF` | canonique |
| 32768 | `0000 8000` | canonique : `0000` est nécessaire pour préserver le signe positif |
| -1 | `FFFF` | canonique |
| -32768 | `8000` | canonique |
| -32769 | `FFFF 7FFF` | canonique : `FFFF` est nécessaire pour préserver le signe négatif |
| 1 | `0000 0001` | non canonique : `0000` de tête superflu |
| -1 | `FFFF FFFF` | non canonique : `FFFF` de tête superflu |

## Statut de format {#형식-지위}

- Le complément à deux est une convention répandue, mais cette représentation, qui normalise une valeur de précision arbitraire en une suite de WORD de 16 bits au minimum et l'associe à un TAG GEUL, est un profil scalaire propre à GEUL.
- Pour échanger avec des types externes à largeur fixe comme INT8/16/32/64, un contrôle d'intervalle et une conversion de largeur explicite sont nécessaires.

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000610/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000061000000000
BODY
#1 DECLARE 0x0610
#2 FIELD #1 rest
#3 BIND #1 "SIGNED-INTEGER"
#4 BIND #2 "integer"
```
