---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Signature portant sur le hachage du contenu du document (commit ou tag signé de git)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `SIGNATURE` (BIND `SIGNATURE` du document de spécification) |
| TAG ID | `0x1E6L` |
| Codec ID | `0x00001E60` |
| Document de spécification | `0x00000000/codecs/0x00001E60/` (cible du DECLARE `1E60`) |
| Section | 15 `1111` (Meta), décalage C dans la section = 6 |
| Kind | Meta · classe : vérification |
| TAG WORD | `0001 1110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Signature d'un objet. La signature d'un document porte sur son hachage du contenu (commit ou tag signé de git) |
| Côté Hugo | `meta/verification/signature.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | valeur brute 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | enregistrement | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | valeur brute du reste (`0xFFFF`) |  |  |

Signature portant sur le hachage du contenu du document (commit ou tag signé de git).

## Disposition {#레이아웃}

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[TAG d'extension Length]
ID d'algorithme   1 WORD (0x0001 = Ed25519)
Signataire        Enregistrement Reference ISSUER-POINTER (Issuer)
Signature         Tout le reste. La largeur est fixée par l'algorithme (Ed25519 32 WORD)
```

- Codec : Meta `0x1E6L`, classe vérification
- Payload : ID d'algorithme (valeur brute 1 WORD) + signataire (Reference intégrée) + signature (valeur brute, le reste)
- Nombre : plusieurs possibles

## Interprétation et validité {#해석과-유효성}

- L'objet signé est le hachage du contenu. On ne signe pas le BODY seul ([signature](../issuer.md#서명)).
- Étant de la classe vérification, elle est exclue du hachage du contenu. Ajouter une signature ne change pas le hachage.
- On vérifie non pas « s'il y a une signature, on contrôle » mais « il doit y avoir la signature d'une clé déterminée ».
- Le document de liste des versions est signé par l'instance de publication.
- Le signataire est un [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) (Issuer) qui désigne l'Issuer lui-même. Comme c'est un enregistrement Reference qui se termine par sa propre Length, la disposition reste unique même si la largeur de la signature varie selon l'algorithme (champ du reste de [DECLARE](../edge/0x0BBL-declare.md)).
- Si le nombre de WORD de la signature diffère de la largeur fixée par l'algorithme, c'est invalid.

## Problèmes ouverts {#열린-문제}

- Faut-il signer aussi l'instant de la signature ?

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001E60/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
