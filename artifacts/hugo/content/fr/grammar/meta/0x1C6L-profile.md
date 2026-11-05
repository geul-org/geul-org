---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Déclare le profil appliqué au document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `PROFILE` (BIND `PROFILE` du document de spécification) |
| TAG ID | `0x1C6L` |
| Codec ID | `0x00001C60` |
| Document de spécification | `0x00000000/codecs/0x00001C60/` (cible du DECLARE `1C60`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 6 |
| Kind | Meta · classe : définition |
| TAG WORD | `0001 1100 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Profil appliqué |
| Côté Hugo | `meta/declaration/profile.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | enregistrement | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

Déclare le profil appliqué au document. Les mêmes enregistrements sont interprétés selon les documents de Codec que fixe le profil (par exemple, avec `tangeul-1.0`, [TOULMIN](../toulmin/_index.md)).

## Disposition {#레이아웃}

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[TAG d'extension Length]
Payload           Value UTF8-TEXT "<nom>-<major>.<minor>"
```

- Codec : Meta `0x1C6L`, classe définition
- Payload : Value intégré ([UTF8-TEXT](../value/0x072L-utf8-text.md))
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- Un profil dont le major diffère est rejeté. Une différence de minor est admise (modifications additives seulement).
- Sans profil, on lit avec la seule grammaire de base de GEUL et les spécifications de codes directs.

## Exemple {#예시}

- `tangeul-1.0` : `0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## Problèmes ouverts {#열린-문제}

- Registre des noms de profil (geul.org) et règles de nommage.
- Désigner le profil par un ID de document (IMPORT) ou le placer sous forme de texte.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001C60/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
