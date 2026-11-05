---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indique l'étendue de diffusion du document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `ACCESS` (BIND `ACCESS` du document de spécification) |
| TAG ID | `0x1DFL` |
| Codec ID | `0x00001DF0` |
| Document de spécification | `0x00000000/codecs/0x00001DF0/` (cible du DECLARE `1DF0`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 31 |
| Kind | Meta · classe : politique |
| TAG WORD | `0001 1101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Étendue de diffusion |
| Côté Hugo | `meta/policy/access.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | valeur brute 1 WORD |  | `0x0000` public, `0x0001` internal, `0x0002` confidential |

Indique l'étendue de diffusion du document.

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[TAG d'extension Length]
Niveau            1 WORD (0 public, 1 interne, 2 confidentiel, autres Reserved)
```

- Codec : Meta `0x1DFL`, classe politique
- Payload : valeur brute (niveau sur 1 WORD)
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- Un document confidentiel n'est pas publié ([Issuer](../issuer.md)).
- Il ne change pas l'interprétation. Il ne fixe que le traitement.

## Problèmes ouverts {#열린-문제}

- Table des codes de niveau.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001DF0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
