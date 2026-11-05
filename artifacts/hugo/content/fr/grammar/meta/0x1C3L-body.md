---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Enregistrement qui termine le HEAD et ouvre le BODY."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `BODY` (BIND `BODY` du document de spécification) |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| Document de spécification | `0x00000000/codecs/0x00001C30/` (cible du DECLARE `1C30`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 3 |
| Kind | Meta · classe : structure |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | 1 WORD. Termine le HEAD du document et ouvre le BODY. |
| Côté Hugo | `meta/structure/body.md` |

## Champs (document de spécification) {#필드-규격-문서}

Le document de spécification ne contient aucun FIELD. Aucun champ de Payload n'est déclaré.

C'est l'enregistrement qui termine le HEAD et ouvre le BODY.

## Disposition {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[TAG d'extension Length]
```

- Codec : Meta `0x1C3L`, classe structure
- Payload : aucun (1 WORD)
- Nombre : au plus un par document

## Interprétation et validité {#해석과-유효성}

- Si le HEAD est vide, on l'omet. Un document sans `BODY` est entièrement BODY. Si le HEAD contient des Meta ou des Edge de HEAD (le [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) du document entier et son QUALIFIER), on place `BODY`.
- Il n'y a pas de Payload. Le total est de 1 WORD.

## Exemple {#예시}

- `0x1C30`

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001C30/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
