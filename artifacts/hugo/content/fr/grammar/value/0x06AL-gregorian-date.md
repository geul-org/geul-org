---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE est un nombre de jours signed qui prend le 1970-01-01 du calendrier grégorien proleptique comme jour 0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `GREGORIAN-DATE` (document de spécification BIND `GREGORIAN-DATE`) |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| Document de spécification | `0x00000000/codecs/0x000006A0/` (cible DECLARE `06A0`) |
| Section | 3 `0011` (Value), offset C dans la section = 10 |
| Kind | Value · famille : TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | nombre de jours signed par rapport au `1970-01-01` du calendrier grégorien proleptique |
| Côté Hugo | `value/time/gregorian-date.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | valeur brute 2 WORD |  |  |

GREGORIAN-DATE est un nombre de jours signed qui prend le `1970-01-01` du calendrier grégorien proleptique comme jour 0. Il ne porte ni fuseau horaire ni heure de la journée.

## Disposition {#레이아웃}

- Code : code direct Value `0x06AL`. Famille TIME.
- On utilise le même type physique int32 signed de largeur fixe que Date32 d'Arrow et `DATE` de Parquet.

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  total 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Interprétation et validité {#해석과-유효성}

- Les 2 WORD du Payload sont lus comme un day count signed en complément à deux sur 32 bits, dans l'ordre des WORD big-endian.
- L'intervalle valide va de `-2^31` à `2^31-1` jours. Une valeur négative est une date antérieure à l'epoch.
- Pour retrouver l'année, le mois et le jour à partir du day count, on utilise le calendrier grégorien proleptique, sans transition historique de calendrier.
- Même une petite valeur occupe toujours 2 WORD.

## Longueur {#길이}

- Le total est exactement de 3 WORD, soit 1 WORD de TAG plus 2 WORD de Payload, avec la longueur directe `LLLL=0010`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload n'est pas exactement de 2 WORD, il est rejeté.

## Exemple {#예시}

| Date | Payload | Length totale |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## Relation avec EDTF {#edtf와의-관계}

- Une précision plus grossière que le jour, l'incertain ou l'approximatif, et les intervalles s'écrivent en [EDTF](0x06EL-edtf.md). Une date qui peut s'écrire exactement en GREGORIAN-DATE ne s'écrit pas en EDTF (forme canonique EDTF).

## Fondement normatif {#표준-근거}

- Le `DATE` des [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) est un `int32` qui stocke le nombre de jours depuis l'epoch Unix, le 1970-01-01, avec un ordre signed.
- Date32 de l'[Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) et du [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) faisant autorité stocke le nombre de jours depuis l'epoch Unix dans un entier signed de 32 bits.
- Le calcul inverse dans le calendrier grégorien proleptique est le calendar profile de GEUL adopté par ce format. Le sens int32 day-count d'Arrow/Parquet est conservé tel quel, et l'on n'ajoute que le TAG et le framing en WORD de 16 bits big-endian.

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x000006A0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
