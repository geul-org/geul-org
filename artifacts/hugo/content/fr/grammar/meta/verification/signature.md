---
title: "SIGNATURE"
weight: 66
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNATURE est un Meta de vérification qui consigne la signature du hachage du contenu du document : ID d'algorithme, signataire et signature."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Signature du hachage du contenu du document (équivalent des commits et tags signés de git).

## Disposition

```
TAG WORD          0001 1LLL L100 0001      Codec 0x41
[TAG d'extension de Length]
ID d'algorithme   1 WORD (0x0001 = Ed25519)
signataire        enregistrement Reference ISSUER-POINTER(Issuer)
signature         tout le reste. La largeur est fixée par l'algorithme (Ed25519 : 32 WORD)
```

- Codec : Meta `0x41`, classe de vérification (`100`)
- Payload : ID d'algorithme (valeur brute, 1 WORD) + signataire (Reference intégré) + signature (valeur brute, le reste)
- Nombre : plusieurs possibles

## Interprétation et validité

- Ce qui est signé est le hachage du contenu. Le BODY seul n'est pas signé ([Signature](/fr/grammar/issuer/#signature)).
- Classe de vérification : exclu du hachage du contenu. Le hachage reste identique si l'on ajoute une signature.
- La vérification ne consiste pas à « contrôler s'il existe une signature » mais à exiger « une signature de la clé prescrite ».
- La liste de versions est signée par le lieu de publication.
- Le signataire est un [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/) (Issuer) qui désigne l'Issuer lui-même. Étant un enregistrement Reference qui se termine par sa propre Length, la disposition reste unique même si la largeur de la signature varie selon l'algorithme (champ restant de [DECLARE](/fr/grammar/edge/declare/)).
- Si le nombre de WORD de la signature diffère de la largeur fixée par l'algorithme, le document est invalid.

## Problèmes ouverts

- Faut-il signer aussi l'instant de signature.
