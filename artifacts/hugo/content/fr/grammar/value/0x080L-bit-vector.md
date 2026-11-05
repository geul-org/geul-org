---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR est une raw bit sequence dont la longueur est indiquée."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR est une raw bit sequence dont la longueur est indiquée. C'est le code direct de Value `0x080L`, famille BINARY. Les 2 premiers WORD du Payload forment le bit count unsigned de 32 bits `N`, suivi de `ceil(N/16)` WORD.

| Élément | Valeur |
|---|---|
| Nom | `BIT-VECTOR` (BIND `BIT-VECTOR` du document de spécification) |
| TAG ID | `0x080L` |
| Codec ID | `0x00000800` |
| Document de spécification | `0x00000000/codecs/0x00000800/` (cible de DECLARE `0800`) |
| Section | 4 `0100` (Value), décalage dans la section C = 0 |
| Kind | Value · famille : BINARY |
| TAG WORD | `0000 1000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description de l'index | N bits stockés en MSB-first après le bit-count |
| Côté Hugo | `value/binary/bit-vector.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | valeur brute de 2 WORD |  |  |
| 2 | `bits` | #3 | reste de valeur brute (`0xFFFF`) |  |  |

## Disposition {#레이아웃}

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[TAG d'extension Length] si le total atteint 15 WORD ou plus
Payload WORD 1st–2nd       Bit Count N (16 bits de poids fort │ 16 bits de poids faible)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Interprétation et validité {#해석과-유효성}

- `N` est la valeur obtenue en lisant les 2 premiers WORD du Payload comme un entier unsigned de 32 bits en big-endian.
- Les payload bit se remplissent à partir du bit de poids le plus fort de chaque WORD.
- Le nombre de WORD du payload est exactement `ceil(N/16)`, et les bits de poids faible inutilisés du dernier WORD doivent tous être 0.
- Si `N=0`, il n'y a aucun WORD de payload. Les deux WORD de count constituent déjà le Payload, ce qui n'entre pas en conflit avec la règle du Payload minimal de 1 WORD.

## Statut du format {#형식-지위}

- Le bit count unsigned de 32 bits, la disposition MSB-first et le zero padding du dernier WORD ne citent aucune norme industrielle externe ; c'est un framing propre à GEUL.
- Cette page définit la représentation, y compris les règles de TAG, de Length et de WORD de 16 bits de GEUL.

## Longueur {#길이}

- Le total est le nombre de WORD : TAG 1 WORD, plus le TAG d'extension Length (s'il existe) et le Payload. Jusqu'à 14 WORD, la longueur est directe ; à partir de 15 WORD, on utilise la longueur étendue `1110`·`1111`, et le TAG d'extension est aussi compté dans le total ([Enregistrement et TAG WORD](../record.md)).

## Exemple {#예시}

- Un bit vector vide a le count `0000 0000`, aucun payload, un total de 3 WORD et `LLLL=0010`. Le total est `0802 0000 0000`.
- La bit sequence `101` a le count `0000 0003`, le payload `A000`, un total de 4 WORD et `LLLL=0011`. Le total est `0803 0000 0003 A000`.

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00000800/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
