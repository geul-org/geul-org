---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Déclare la version de la spécification GEUL que suit le document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `SPEC-VERSION` (BIND `SPEC-VERSION` du document de spécification) |
| TAG ID | `0x1C5L` |
| Codec ID | `0x00001C50` |
| Document de spécification | `0x00000000/codecs/0x00001C50/` (cible du DECLARE `1C50`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 5 |
| Kind | Meta · classe : définition |
| TAG WORD | `0001 1100 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Version de la spécification GEUL suivie. Le Payload est directement un entier non signé de la largeur la plus courte. v1 est `0x0001` (enregistrement `0x1C51 0x0001`) |
| Côté Hugo | `meta/declaration/spec-version.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | valeur brute du reste (`0xFFFF`) |  |  |

Déclare la version de la spécification GEUL que suit le document. C'est cette valeur qui détermine comment lire les autres enregistrements.

## Disposition {#레이아웃}

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[TAG d'extension Length]
Payload           Version de la spécification. v1 = 0x0001
```

- Codec : Meta `0x1C5L`, classe définition
- Payload : valeur brute (entier non signé de la largeur la plus courte)
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- Ne s'appuie pas sur un code Value. Pour que le décodeur de n'importe quelle version puisse le lire, on place un simple entier, sans Value intégré.
- Si la version est inconnue, le décodeur la rejette ou émet un avertissement.
- En son absence, le décodeur lit selon la version qu'il connaît. Un document publié l'indique.

## Exemple {#예시}

- `0x1C51 0x0001` : GEUL v1

## Problèmes ouverts {#열린-문제}

- Correspondance avec la version du document du livre de codes ([document de spécification](../codec-spec.md)).

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001C50/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
