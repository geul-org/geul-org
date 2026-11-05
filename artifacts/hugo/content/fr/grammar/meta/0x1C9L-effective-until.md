---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Déclare la fin de la période de validité de cette version (loi temporaire)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `EFFECTIVE-UNTIL` (BIND `EFFECTIVE-UNTIL` du document de spécification) |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| Document de spécification | `0x00000000/codecs/0x00001C90/` (cible du DECLARE `1C90`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 9 |
| Kind | Meta · classe : définition |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Fin de la période de validité de cette version (loi temporaire). En son absence, jusqu'à l'entrée en vigueur de la version suivante |
| Côté Hugo | `meta/declaration/effective-until.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | enregistrement | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Déclare la fin de la période de validité de cette version (loi temporaire). À partir de cet instant, cette version n'est plus en vigueur.

## Disposition {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[TAG d'extension Length]
Payload           Une Value TIME
```

- Codec : Meta `0x1C9L`, classe définition
- Payload : Value intégrée ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) ou [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- En son absence, la version reste valide jusqu'à l'entrée en vigueur de la version suivante.
- Une fois la période de validité écoulée, aucune édition n'est en vigueur. Les anciennes éditions ne reviennent pas à la vie.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001C90/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
