---
title: "UNSIGNED-DECIMAL (0x069L)"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL est une Value de nombre décimal exact (exact decimal) dont le coefficient est non signé."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `UNSIGNED-DECIMAL` (document de spécification BIND `UNSIGNED-DECIMAL`) |
| TAG ID | `0x069L` |
| Codec ID | `0x00000690` |
| Document de spécification | `0x00000000/codecs/0x00000690/` (cible DECLARE `0690`) |
| Section | 3 `0011` (Value), offset C dans la section = 9 |
| Kind | Value · famille : DECIMAL |
| TAG WORD | `0000 0110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | `C×10^E` avec un signed exponent `E` et un coefficient `C` unsigned sur un nombre minimal de WORD |
| Côté Hugo | `value/decimal/unsigned-decimal.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | valeur brute 2 WORD |  |  |
| 2 | `coefficient` | #3 | valeur brute restante (`0xFFFF`) |  |  |

UNSIGNED-DECIMAL est une Value de nombre décimal exact (exact decimal) dont le coefficient est non signé. Son code direct Value est `0x069L`, sa famille est DECIMAL. Les 2 premiers WORD du Payload sont l'exposant décimal signed 32 bits `E`, le reste est le coefficient `C` unsigned sur un nombre minimal de WORD, et la valeur est `C×10^E`.

## Disposition {#레이아웃}

```
TAG WORD          0000 0110 1001 LLLL      Codec 0x069L
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1st–2nd (32 bits)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD ou plus) Unsigned Coefficient C
```

## Interprétation {#해석}

- `E` est un entier signed 32 bits big-endian en complément à deux, enregistré à partir du WORD de poids fort.
- `C` est une unsigned magnitude de précision arbitraire obtenue en lisant tous les WORD restants à partir du WORD de poids fort.
- `C` suit la même règle de nombre minimal de WORD que [UNSIGNED-INTEGER](0x062L-unsigned-integer.md). 0 est `0000`, et à partir de 2 WORD un premier WORD `0000` est interdit.

## Longueur et validité {#길이와-유효성}

- Le total est le nombre de WORD du TAG (1 WORD), du TAG d'extension de Length (s'il existe) et du Payload. Jusqu'à 14 WORD, on utilise la longueur directe ; à partir de 15 WORD, la longueur étendue `1110`·`1111`, et le TAG d'extension compte aussi dans le total ([Enregistrement et TAG WORD](../record.md)).
- Le Payload comprend l'exposant de 2 WORD et un coefficient de 1 WORD ou plus ; il fait donc au moins 3 WORD.
- Pour la canonicité de la représentation en octets, on ne vérifie que la représentation à nombre minimal de WORD du coefficient.

## Exemple {#예시}

| Représentation de la valeur | Payload (`E` + `C`) | Verdict |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | représentation en octets canonique |
| `10×10^-1` | `FFFF FFFF 000A` | représentation en octets canonique ; sa relation canonique avec la représentation ci-dessus est un problème ouvert |
| `1×10^0` | `0000 0000 0000 0001` | non canonique : `0000` de tête du coefficient superflu |
| coefficient négatif | sans objet | invalid |

## Statut de format {#형식-지위}

- Cette disposition, qui associe un exposant `E` signed 32 bits et un coefficient `C` unsigned à nombre minimal de WORD, est un format propre à GEUL, qui n'est ni l'échange décimal IEEE 754 ni le `DECIMAL` d'Apache Parquet.
- Le `DECIMAL` de Parquet utilise une signed unscaled value, `unscaledValue × 10^(-scale)` et des métadonnées precision/scale obligatoires ; son type physique byte-array est en complément à deux big-endian et scale est supérieur ou égal à 0. Le présent format n'est pas le même, car `C` est unsigned, `E` est signed et il n'y a pas de métadonnées de precision.
- Pour échanger avec l'IEEE 754 decimal ou le `DECIMAL` de Parquet, une conversion explicite qui fixe le signe, l'intervalle, la precision/scale, le quantum et la politique des valeurs spéciales est nécessaire.
- Références de comparaison : [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Problèmes ouverts {#열린-문제}

- Il existe plusieurs paires exposant/coefficient qui représentent le même nombre, comme `10×10^-1` et `1×10^0`.
- On n'a pas encore fixé si ce format conserve le quantum, comment juger l'égalité de valeurs, ni comment normaliser l'exposant canonique.
- Une implémentation ne doit donc pas imposer arbitrairement une normalisation de l'exposant et du coefficient en dehors de la règle du nombre minimal de WORD du coefficient.

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000690/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000069000000000
BODY
#1 DECLARE 0x0690
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "UNSIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
