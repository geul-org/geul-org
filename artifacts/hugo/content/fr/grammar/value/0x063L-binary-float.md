---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT est une Value qui représente un scalaire d'échange binaire IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `BINARY-FLOAT` (document de spécification BIND `BINARY-FLOAT`) |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| Document de spécification | `0x00000000/codecs/0x00000630/` (cible DECLARE `0630`) |
| Section | 3 `0011` (Value), offset C dans la section = 3 |
| Kind | Value · famille : NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | scalaire IEEE 754 binary16/32/64/128 avec un Payload de 1/2/4/8 WORD |
| Côté Hugo | `value/numeric/binary-float.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | valeur brute restante (`0xFFFF`) |  |  |

BINARY-FLOAT est une Value qui représente un scalaire d'échange binaire IEEE 754. Son code direct Value est `0x063L`, sa famille est NUMERIC. Un Payload de 1/2/4/8 WORD correspond respectivement à binary16/32/64/128. La suite de bits d'échange est conservée telle quelle, et les autres tailles de Payload ne sont pas admises.

## Disposition {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1st  (WORD de poids fort)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (WORD de poids faible) IEEE Binary Interchange Nth
```

## Interprétation {#해석}

- Les WORD du Payload, mis bout à bout dans l'ordre big-endian, sont lus comme la suite de bits d'échange binaire IEEE 754 de la largeur correspondante.
- Les motifs de bits d'échange sont conservés, y compris le payload de NaN et le zéro signé.
- Le décodeur ne doit ni remplacer un NaN par un NaN canonique quelconque, ni effacer le signe d'un zéro signé.
- Le mode d'arrondi et le comportement arithmétique ne sont pas définis par ce format de sérialisation.

## Longueur {#길이}

Le total est le nombre de WORD du TAG (1 WORD), du TAG d'extension de Length (s'il existe) et du Payload ([Enregistrement et TAG WORD](../record.md)).

| Format | Payload | Code de Length | TAG d'extension de Length | Length totale |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | aucun | 2 WORD |
| binary32 | 2 WORD | `0010` | aucun | 3 WORD |
| binary64 | 4 WORD | `0100` | aucun | 5 WORD |
| binary128 | 8 WORD | `1000` | aucun | 9 WORD |

binary128 se situe lui aussi dans l'intervalle direct de 1 à 14 WORD ; il n'utilise donc pas de TAG d'extension de Length.

## Validité {#유효성}

- Le Payload fait exactement 1, 2, 4 ou 8 WORD.
- Chaque taille de Payload doit correspondre exactement à la représentation de Length du tableau ci-dessus.
- Un ré-encodage qui change la largeur ou des WORD de padding avant ou après le Payload ne sont pas admis.

## Exemple {#예시}

| Format | TAG | TAG d'extension de Length | Exemple de Payload | Verdict |
|---|---|---|---|---|
| binary16 | `0631` | aucun | `0000` | canonique |
| binary32 | `0632` | aucun | `0000 0000` | canonique |
| binary64 | `0634` | aucun | `0000 0000 0000 0000` | canonique |
| binary128 | `0638` | aucun | suite de bits de 8 WORD | canonique |
| quelconque | taille différente de celle qu'indique la Length | quelconque | quelconque | invalid |

## Fondement normatif {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/) : on applique les encodages d'échange binary16, binary32, binary64 et binary128. GEUL n'ajoute à cette suite de bits que le TAG et le framing en WORD de 16 bits big-endian.

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000630/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
