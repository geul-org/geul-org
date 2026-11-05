---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Déclare la date d'entrée en vigueur de cette version."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `EFFECTIVE-FROM` (BIND `EFFECTIVE-FROM` du document de spécification) |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| Document de spécification | `0x00000000/codecs/0x00001C80/` (cible du DECLARE `1C80`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 8 |
| Kind | Meta · classe : définition |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Date d'entrée en vigueur de cette version. Value GREGORIAN-DATE ou POSIX-TIMESTAMP. En son absence, l'instant de publication |
| Côté Hugo | `meta/declaration/effective-from.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | enregistrement | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Déclare la date d'entrée en vigueur de cette version. Cette date diffère de l'instant de publication ([révision](../document.md#개정)).

## Disposition {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[TAG d'extension Length]
Payload           Une Value TIME
```

- Codec : Meta `0x1C8L`, classe définition
- Payload : Value intégrée ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) ou [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- En son absence, la version entre en vigueur dès l'instant de publication.
- Si [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) existe, cette date doit lui être antérieure.
- Si la date d'entrée en vigueur diffère selon les articles, on l'indique séparément dans l'Edge de chaque article avec les QUALIFIER P580 (début) et P582 (fin) ([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).
- On lit cette valeur quand on interprète le document à un instant donné.

## Exemple {#예시}

- Entrée en vigueur le 1970-01-02 : `0x1C83 0x06A2 0x0000 0x0001`

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001C80/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
