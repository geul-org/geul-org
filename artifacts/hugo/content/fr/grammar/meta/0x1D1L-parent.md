---
title: "PARENT (0x1D1L)"
weight: 465
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indique le hachage du contenu de la version précédente (git parent)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `PARENT` (BIND `PARENT` du document de spécification) |
| TAG ID | `0x1D1L` |
| Codec ID | `0x00001D10` |
| Document de spécification | `0x00000000/codecs/0x00001D10/` (cible du DECLARE `1D10`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 17 |
| Kind | Meta · classe : lignée |
| TAG WORD | `0001 1101 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Hachage du contenu de la version précédente (git parent). En son absence, c'est la première version ; s'il y en a plusieurs, c'est une fusion (git merge commit). |
| Côté Hugo | `meta/lineage/parent.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | enregistrement | `07C0` SHA-256-DIGEST |  |

Indique le hachage du contenu de la version précédente (git parent).

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 0001 LLLL      Codec 0x1D1L
[TAG d'extension Length]
Payload           Une Value SHA-256-DIGEST (16 WORD)
```

- Codec : Meta `0x1D1L`, classe lignée
- Payload : Value intégrée ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Nombre : plusieurs possibles (fusion)

## Interprétation et validité {#해석과-유효성}

- En son absence, c'est la première version ; s'il y en a plusieurs, c'est une fusion (git merge commit).
- Comme il entre dans le [hachage du contenu](../document.md#내용-해시), tout l'historique forme une chaîne de hachages.
- Un document de liste des versions désigne le document de liste précédent ([PUBLICATION](../edge/0x0B8L-publication.md)).
- Le format du condensat est intégré comme Value, ce qui laisse la possibilité de changer d'algorithme de hachage. Pour l'instant, le hachage du contenu n'est que SHA-256.

## Exemple {#예시}

- `0x1D1E 0x0014 0x07CE 0x0012 <16 WORD>` (Meta 20 WORD = TAG + TAG d'extension Length + Value intégrée 18 WORD)

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001D10/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D1000000000
BODY
#1 DECLARE 0x1D10
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "PARENT"
#4 BIND #2 "digest"
```
