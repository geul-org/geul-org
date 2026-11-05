---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS est un temps écoulé en nanosecondes signées, sans epoch."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS est un temps écoulé en nanosecondes signées, sans epoch. Ce n'est ni un instant ni une durée calendaire en mois ou en années.

| Élément | Valeur |
|---|---|
| Nom | `DURATION-NANOSECONDS` (BIND `DURATION-NANOSECONDS` du document de spécification) |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| Document de spécification | `0x00000000/codecs/0x00000810/` (cible de DECLARE `0810`) |
| Section | 4 `0100` (Value), décalage dans la section C = 1 |
| Kind | Value · famille : TIME |
| TAG WORD | `0000 1000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description de l'index | Temps écoulé en nanosecondes signées, sans epoch |
| Côté Hugo | `value/time/duration-nanoseconds.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | valeur brute de 4 WORD |  |  |

## Disposition {#레이아웃}

- Code : code direct de Value `0x081L`. Famille TIME.
- Il utilise le même type physique à largeur fixe, int64 signé, que `Duration(NANOSECOND)` d'Arrow.

```
TAG WORD          0x0814 (0000 1000 0001 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds 16 bits de poids fort
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds 16 bits de poids faible
```

## Interprétation et validité {#해석과-유효성}

- On lit l'ensemble des 4 WORD du Payload comme un compte signé en complément à deux sur 64 bits, dans l'ordre des WORD big-endian.
- La plage valide est `-2^63`~`2^63-1` ns. Le signe est le sens du temps écoulé et ne désigne pas l'instant d'un epoch particulier.
- Même une petite valeur utilise toujours 4 WORD.

## Longueur {#길이}

- Le total est exactement 5 WORD, TAG 1 WORD plus Payload 4 WORD, avec la longueur directe `LLLL=0100`. Il n'y a ni TAG d'extension Length, ni descriptor, ni padding.
- On rejette si le Payload n'est pas exactement 4 WORD.

## Exemple {#예시}

- 0 ns a pour Payload `0000 0000 0000 0000`, un total de 5 WORD et `LLLL=0100`. Le total est `0814 0000 0000 0000 0000`.
- 1 ns a pour Payload `0000 0000 0000 0001`.
- -1 ns a pour Payload `FFFF FFFF FFFF FFFF`.

## Fondement normatif {#표준-근거}

- Le [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) désigne `Schema.fbs` comme la source authoritative des types de données standard d'Arrow.
- Dans le [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) authoritative d'Arrow, `Duration` est un temps écoulé absolu indépendant du calendrier ; il prend en charge l'unité NANOSECOND et se représente toujours par un entier signé de 8 octets. GEUL n'y ajoute que le TAG et le framing en WORD big-endian de 16 bits.

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00000810/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
