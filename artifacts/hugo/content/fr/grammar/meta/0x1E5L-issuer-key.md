---
title: "ISSUER-KEY (0x1E5L)"
weight: 485
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Déclare la clé publique d'un Issuer à émission autonome (16 WORD)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `ISSUER-KEY` (BIND `ISSUER-KEY` du document de spécification) |
| TAG ID | `0x1E5L` |
| Codec ID | `0x00001E50` |
| Document de spécification | `0x00000000/codecs/0x00001E50/` (cible du DECLARE `1E50`) |
| Section | 15 `1111` (Meta), décalage C dans la section = 5 |
| Kind | Meta · classe : vérification |
| TAG WORD | `0001 1110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Déclaration de l'ID d'algorithme de signature et de la clé publique d'un Issuer à émission autonome |
| Côté Hugo | `meta/verification/issuer-key.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | valeur brute 1 WORD |  | `0x0001` ed25519 |
| 2 | `key` | #3 | valeur brute du reste (`0xFFFF`) |  |  |

Déclare la clé publique d'un Issuer à émission autonome (16 WORD). Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID d'algorithme ‖ clé publique) ([Issuer de 16 WORD](../issuer.md#16-word-issuer)).

## Disposition {#레이아웃}

```
TAG WORD          0001 1110 0101 LLLL      Codec 0x1E5L
[TAG d'extension Length]
ID d'algorithme   1 WORD (0x0001 = Ed25519)
Clé publique      Largeur fixée par l'algorithme (Ed25519 16 WORD)
```

- Codec : Meta `0x1E5L`, classe vérification
- Payload : valeur brute (ID d'algorithme + clé publique)
- Nombre : plusieurs possibles (rotation de clés)

## Interprétation et validité {#해석과-유효성}

- Étant de la classe vérification, il est exclu du hachage du contenu.
- Les Issuer de 2 et 4 WORD emploient la clé enregistrée sur geul.org, donc il n'est pas nécessaire.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001E50/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E5000000000
BODY
#1 DECLARE 0x1E50
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 ENUM #2 0x0001
#5 BIND #1 "ISSUER-KEY"
#6 BIND #2 "algorithm"
#7 BIND #3 "key"
#8 BIND #4 "ed25519"
```
