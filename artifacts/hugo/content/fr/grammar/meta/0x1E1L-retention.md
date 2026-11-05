---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indique la durée de conservation du document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `RETENTION` (BIND `RETENTION` du document de spécification) |
| TAG ID | `0x1E1L` |
| Codec ID | `0x00001E10` |
| Document de spécification | `0x00000000/codecs/0x00001E10/` (cible du DECLARE `1E10`) |
| Section | 15 `1111` (Meta), décalage C dans la section = 1 |
| Kind | Meta · classe : politique |
| TAG WORD | `0001 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Durée de conservation |
| Côté Hugo | `meta/policy/retention.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | enregistrement | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE, `06D0` DURATION-SECONDS |  |

Indique la durée de conservation du document.

## Disposition {#레이아웃}

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[TAG d'extension Length]
Payload           Instant d'expiration (GREGORIAN-DATE, etc.) ou durée (DURATION-SECONDS)
```

- Codec : Meta `0x1E1L`, classe politique
- Payload : Value intégrée (famille TIME : [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), etc., ou [DURATION-SECONDS](../value/0x06DL-duration-seconds.md))
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- S'il s'agit d'une durée, on la compte à partir de [RECORDED-AT](0x1D0L-recorded-at.md).

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001E10/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
