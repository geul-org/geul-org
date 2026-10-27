---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY est un Meta de vérification qui déclare l'ID de l'algorithme de signature et la clé publique d'un Issuer auto-émis (16 WORD)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Déclare la clé publique d'un Issuer auto-émis (16 WORD). ID de l'Issuer = SHA-256("GEUL-ISSUER-v1" ‖ ID d'algorithme ‖ clé publique) ([Issuer de 16 WORD](/fr/grammar/issuer/#issuer-de-16-word)).

## Disposition

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[TAG d'extension de Length]
ID d'algorithme   1 WORD (0x0001 = Ed25519)
clé publique      largeur fixée par l'algorithme (Ed25519 : 16 WORD)
```

- Codec : Meta `0x40`, classe de vérification (`100`)
- Payload : valeur brute (ID d'algorithme + clé publique)
- Nombre : plusieurs possibles (rotation de clés)

## Interprétation et validité

- Classe de vérification : exclu du hachage du contenu.
- Les Issuers de 1, 2 et 4 WORD utilisent les clés enregistrées auprès de geul.org ; il n'est donc pas nécessaire.
