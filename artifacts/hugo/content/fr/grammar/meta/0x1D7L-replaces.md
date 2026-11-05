---
title: "REPLACES (0x1D7L)"
weight: 471
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indique le hachage du contenu de la version remplacée par une réécriture (git amend, rebase)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `REPLACES` (BIND `REPLACES` du document de spécification) |
| TAG ID | `0x1D7L` |
| Codec ID | `0x00001D70` |
| Document de spécification | `0x00000000/codecs/0x00001D70/` (cible du DECLARE `1D70`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 23 |
| Kind | Meta · classe : lignée |
| TAG WORD | `0001 1101 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Hachage du contenu de la version remplacée par une réécriture (git amend, rebase). La version d'origine n'est pas effacée. |
| Côté Hugo | `meta/lineage/replaces.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | enregistrement | `07C0` SHA-256-DIGEST |  |

Indique le hachage du contenu de la version remplacée par une réécriture (git amend, rebase).

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 0111 LLLL      Codec 0x1D7L
[TAG d'extension Length]
Payload           Une Value SHA-256-DIGEST (16 WORD)
```

- Codec : Meta `0x1D7L`, classe lignée
- Payload : Value intégrée ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Nombre : plusieurs possibles

## Interprétation et validité {#해석과-유효성}

- La version d'origine n'est pas effacée (conservation de l'ancienne loi).
- Le format du condensat est intégré comme Value, ce qui laisse la possibilité de changer d'algorithme de hachage. Pour l'instant, le hachage du contenu n'est que SHA-256.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001D70/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D7000000000
BODY
#1 DECLARE 0x1D70
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "REPLACES"
#4 BIND #2 "digest"
```
