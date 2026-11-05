---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indique le nom immuable attribué à une version (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `TAG` (BIND `TAG` du document de spécification) |
| TAG ID | `0x1DAL` |
| Codec ID | `0x00001DA0` |
| Document de spécification | `0x00000000/codecs/0x00001DA0/` (cible du DECLARE `1DA0`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 26 |
| Kind | Meta · classe : lignée |
| TAG WORD | `0001 1101 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Nom immuable attribué à une version. Value TEXT et hachage du contenu (git annotated tag) |
| Côté Hugo | `meta/lineage/tag.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | enregistrement | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | enregistrement | `07C0` SHA-256-DIGEST, `0000` ABSENT (champ facultatif) |  |

Indique le nom immuable attribué à une version (git annotated tag).

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[TAG d'extension Length]
Nom               Value UTF8-TEXT-*
Cible             Value SHA-256-DIGEST, ou marqueur d'omission 0x0000 (champ facultatif). En cas d'omission, cette version
```

- Codec : Meta `0x1DAL`, classe lignée
- Payload : Value intégrée (texte + hachage du contenu facultatif)
- Nombre : plusieurs possibles

## Interprétation et validité {#해석과-유효성}

- Le nom est un [UTF8-TEXT](../value/0x072L-utf8-text.md), la cible un [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md).
- Si l'on omet la cible (ABSENT `0x0000`, champ facultatif de [CODEC](../edge/0x0BEL-codec.md)), le nom est attribué à ce document lui-même. Son propre hachage du contenu ne peut pas être écrit en lui-même. La spécification `0x1DA0` de geul.org est faite de deux champs d'enregistrement : name (`0720`, `0730`) et target (`07C0`, `0000`).
- On ne réemploie pas le même nom pour une autre version.

## Exemple {#예시}

- Nom `v1`, cette version : `1DA3 0721 7631 0000`

## Problèmes ouverts {#열린-문제}

- Le TAG est-il nécessaire alors qu'il existe un ID de version (numéro d'ordre) ?

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001DA0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
