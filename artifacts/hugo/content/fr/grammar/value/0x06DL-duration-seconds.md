---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS est une durée écoulée en secondes signed, sans epoch."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `DURATION-SECONDS` (document de spécification BIND `DURATION-SECONDS`) |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| Document de spécification | `0x00000000/codecs/0x000006D0/` (cible DECLARE `06D0`) |
| Section | 3 `0011` (Value), offset C dans la section = 13 |
| Kind | Value · famille : TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | durée écoulée signed en SI-second, sans epoch |
| Côté Hugo | `value/time/duration-seconds.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | valeur brute 4 WORD |  |  |

DURATION-SECONDS est une durée écoulée en secondes signed, sans epoch. Ce n'est ni un instant ni une durée calendaire en mois ou en années.

## Disposition {#레이아웃}

- Code : code direct Value `0x06DL`. Famille TIME.
- On utilise le même type physique int64 signed de largeur fixe que `Duration(SECOND)` d'Arrow.

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interprétation et validité {#해석과-유효성}

- Les 4 WORD du Payload sont lus comme un compte signed en complément à deux sur 64 bits, dans l'ordre des WORD big-endian.
- L'intervalle valide va de `-2^63` à `2^63-1` secondes. Le signe est le sens de l'écoulement et ne désigne pas un instant d'une epoch donnée.
- Même une petite valeur occupe toujours 4 WORD.

## Longueur {#길이}

- Le total est exactement de 5 WORD, soit 1 WORD de TAG plus 4 WORD de Payload, avec la longueur directe `LLLL=0100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload n'est pas exactement de 4 WORD, il est rejeté.

## Exemple {#예시}

- 0 seconde est le Payload `0000 0000 0000 0000`, 5 WORD au total, `LLLL=0100`.
- 1 seconde est le Payload `0000 0000 0000 0001`.
- -1 seconde est le Payload `FFFF FFFF FFFF FFFF`.

## Fondement normatif {#표준-근거}

- L'[Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) désigne `Schema.fbs` comme la source faisant autorité des types de données standard d'Arrow.
- Dans le [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) faisant autorité d'Arrow, `Duration` est un temps écoulé absolu indépendant du calendrier, qui prend en charge l'unité SECOND et est toujours représenté par un entier signed de 8 octets. GEUL n'y ajoute que le TAG et le framing en WORD de 16 bits big-endian.

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x000006D0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
