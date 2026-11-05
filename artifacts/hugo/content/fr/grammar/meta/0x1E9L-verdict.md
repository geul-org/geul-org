---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Indique le résultat du verdict sur le document entier."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `VERDICT` (BIND `VERDICT` du document de spécification) |
| TAG ID | `0x1E9L` |
| Codec ID | `0x00001E90` |
| Document de spécification | `0x00000000/codecs/0x00001E90/` (cible du DECLARE `1E90`) |
| Section | 15 `1111` (Meta), décalage C dans la section = 9 |
| Kind | Meta · classe : vérification |
| TAG WORD | `0001 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Résultat du verdict sur le document entier. Pass, Review, Fail. Au niveau du nœud ou de l'enregistrement, c'est le `VERDICT` de [TOULMIN](../toulmin/_index.md) (Edge `0x118L`) |
| Côté Hugo | `meta/verification/verdict.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | valeur brute 1 WORD |  | `0x0000` pass, `0x0001` review, `0x0002` fail |

Indique le résultat du verdict sur le document entier. Le verdict au niveau du nœud ou de l'enregistrement relève du `VERDICT` de [TOULMIN](../toulmin/_index.md) (Edge `0x118L`).

## Disposition {#레이아웃}

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[TAG d'extension Length]
Verdict           1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec : Meta `0x1E9L`, classe vérification
- Payload : valeur brute (verdict sur 1 WORD)
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- Étant de la classe vérification, il est exclu du hachage du contenu.
- Un verdict portant sur un autre document se place dans le BODY d'un document différent de celui qui est jugé.

## Problèmes ouverts {#열린-문제}

- Faut-il indiquer aussi l'auteur du verdict et son fondement ?

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001E90/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
