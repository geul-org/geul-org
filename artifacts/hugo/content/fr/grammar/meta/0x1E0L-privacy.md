---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indique le niveau de données personnelles du document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `PRIVACY` (BIND `PRIVACY` du document de spécification) |
| TAG ID | `0x1E0L` |
| Codec ID | `0x00001E00` |
| Document de spécification | `0x00000000/codecs/0x00001E00/` (cible du DECLARE `1E00`) |
| Section | 15 `1111` (Meta), décalage C dans la section = 0 |
| Kind | Meta · classe : politique |
| TAG WORD | `0001 1110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Niveau de données personnelles |
| Côté Hugo | `meta/policy/privacy.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | valeur brute 1 WORD |  |  |

Indique le niveau de données personnelles du document.

## Disposition {#레이아웃}

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[TAG d'extension Length]
Niveau            1 WORD
```

- Codec : Meta `0x1E0L`, classe politique
- Payload : valeur brute (niveau sur 1 WORD)
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- Il ne change pas l'interprétation. Il ne fixe que le traitement.

## Problèmes ouverts {#열린-문제}

- Table des codes de niveau (correspondance avec la classification de la loi sur la protection des données personnelles).

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001E00/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
