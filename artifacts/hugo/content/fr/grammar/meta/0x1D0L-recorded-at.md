---
title: "RECORDED-AT (0x1D0L)"
weight: 464
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Indique l'instant où le document a été consigné (git commit date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `RECORDED-AT` (BIND `RECORDED-AT` du document de spécification) |
| TAG ID | `0x1D0L` |
| Codec ID | `0x00001D00` |
| Document de spécification | `0x00000000/codecs/0x00001D00/` (cible du DECLARE `1D00`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 16 |
| Kind | Meta · classe : provenance |
| TAG WORD | `0001 1101 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Instant de consignation. Value TIME (git commit date) |
| Côté Hugo | `meta/provenance/recorded-at.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | enregistrement | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Indique l'instant où le document a été consigné (git commit date).

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 0000 LLLL      Codec 0x1D0L
[TAG d'extension Length]
Payload           Une Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, etc.)
```

- Codec : Meta `0x1D0L`, classe provenance
- Payload : Value intégrée (famille TIME : [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md), etc.)
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- Le format se choisit parmi les Value de la famille TIME. Si une précision est nécessaire, on emploie un format en nanosecondes défini par un Issuer (par exemple [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).
- Le document de liste des versions ([PUBLICATION](../edge/0x0B8L-publication.md)) emploie cette valeur comme instant de publication, de dépréciation (deprecate) ou de suppression.

## Problèmes ouverts {#열린-문제}

- Les Meta de provenance entrent dans le hachage du contenu. Faut-il admettre que le même contenu consigné à un autre instant donne un hachage différent ?

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001D00/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D0000000000
BODY
#1 DECLARE 0x1D00
#2 FIELD #1 record
#3 BIND #1 "RECORDED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
