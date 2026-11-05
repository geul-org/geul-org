---
title: "DOC-1WORD (0x1C0L)"
weight: 448
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD et DOC-4WORD sont des Meta de structure qui ouvrent un document en indiquant son nombre total de WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD, DOC-2WORD et DOC-4WORD sont des Meta de structure qui ouvrent un document en indiquant son nombre total de WORD.

| Élément | Valeur |
|---|---|
| Nom | `DOC-1WORD` (BIND `DOC-1WORD` du document de spécification) |
| TAG ID | `0x1C0L` |
| Codec ID | `0x00001C00` |
| Document de spécification | `0x00000000/codecs/0x00001C00/` (cible du DECLARE `1C00`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 0 |
| Kind | Meta · classe : structure |
| TAG WORD | `0001 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Début de document dont la longueur totale est indiquée sur 1 WORD de Payload |
| Côté Hugo | `meta/structure/doc.md` (cette page traite aussi de [DOC-2WORD](0x1C1L-doc-2word.md) et [DOC-4WORD](0x1C2L-doc-4word.md)) |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | valeur brute 1 WORD |  |  |

C'est l'enregistrement qui ouvre le document. Il indique dans le Payload le nombre total de WORD du document. Cette page traite ensemble `DOC-1WORD` (`0x1C0L`), `DOC-2WORD` (`0x1C1L`) et `DOC-4WORD` (`0x1C2L`).

## Disposition {#레이아웃}

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[TAG d'extension Length]
Payload           Nombre total de WORD. Le Codec fixe la largeur : DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec : Meta `0x1C0L~0x1C2L`, classe structure
- Payload : valeur brute (nombre total de WORD du document, non signé)
- Nombre : un par document, tout au début

## Interprétation et validité {#해석과-유효성}

- La longueur va du début de l'enregistrement d'ouverture jusqu'à la fin de [END](0x1C4L-end.md).
- On emploie la largeur la plus étroite qui contienne la valeur. Un encodage dans une largeur supérieure est rejeté comme encodage non canonique.
- La longueur doit être égale à celle de l'entrée entière. Un document constitue une entrée.
- Le décodeur peut sauter tout le document grâce à cette longueur. Aucun Codec d'ouverture ne laisse la longueur inconnue.
- Pour calculer le hachage du contenu, on réécrit le document avec la longueur calculée sans les Meta de la classe vérification, dans la largeur qui lui correspond ([hachage du contenu](../document.md#내용-해시)).

## Exemple {#예시}

- `0x1C01 0x0017` : DOC-1WORD, 23 WORD au total

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001C00/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C0000000000
BODY
#1 DECLARE 0x1C00
#2 FIELD #1 0x0001
#3 BIND #1 "DOC-1WORD"
#4 BIND #2 "count"
```
