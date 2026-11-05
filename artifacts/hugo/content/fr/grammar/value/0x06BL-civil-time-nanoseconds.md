---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS représente une heure civile sans date par le nombre de nanosecondes écoulées depuis minuit."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `CIVIL-TIME-NANOSECONDS` (document de spécification BIND `CIVIL-TIME-NANOSECONDS`) |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| Document de spécification | `0x00000000/codecs/0x000006B0/` (cible DECLARE `06B0`) |
| Section | 3 `0011` (Value), offset C dans la section = 11 |
| Kind | Value · famille : TIME |
| TAG WORD | `0000 0110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | compte unsigned de nanosecondes depuis minuit du jour civil |
| Côté Hugo | `value/time/civil-time-nanoseconds.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | valeur brute 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS représente une heure civile sans date par le nombre de nanosecondes écoulées depuis minuit.

## Disposition {#레이아웃}

- Code : code direct Value `0x06BL`. Famille TIME.
- On utilise le même type physique int64 signed de largeur fixe que `TIME(isAdjustedToUTC=false, unit=NANOS)` de Parquet.

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interprétation et validité {#해석과-유효성}

- Les 4 WORD du Payload sont lus comme un compte signed en complément à deux sur 64 bits, dans l'ordre des WORD big-endian.
- Le type physique est un int64 signed, mais l'intervalle valide est `0 <= value < 86,400×10^9` ns. Une valeur négative ou supérieure ou égale à la borne haute est rejetée.
- `24:00` et le label de seconde intercalaire ne sont pas admis. Ni date, ni fuseau horaire, ni décalage UTC ne sont portés.
- Même une petite valeur occupe toujours 4 WORD.

## Longueur {#길이}

- Le total est exactement de 5 WORD, soit 1 WORD de TAG plus 4 WORD de Payload, avec la longueur directe `LLLL=0100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload n'est pas exactement de 4 WORD, il est rejeté.

## Exemple {#예시}

- Minuit est le Payload `0000 0000 0000 0000`, 5 WORD au total, `LLLL=0100`.
- 1 ns après minuit est le Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns est égal à la borne haute et n'est donc pas valide.
- `FFFF FFFF FFFF FFFF` vaut -1 en int64 signed et n'est donc pas valide.

## Fondement normatif {#표준-근거}

- Le `TIME(isAdjustedToUTC=false, unit=NANOS)` des [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) stocke dans un `int64` les nanosecondes écoulées depuis minuit de l'heure locale, avec un ordre signed.
- Le [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html), dans son [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) faisant autorité, définit Time NANOSECOND comme un entier signed de 64 bits, limite l'intervalle valide à moins de 86 400 secondes à partir de minuit inclus et n'admet pas de seconde intercalaire. GEUL n'ajoute que le TAG et le framing en WORD de 16 bits big-endian.

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x000006B0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
