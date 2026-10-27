---
title: "SPEC-VERSION"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "SPEC-VERSION est un Meta de définition qui déclare par un seul entier l'édition de la spécification GEUL suivie par le document. GEUL v1 vaut 0x0001."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Déclare l'édition de la spécification GEUL suivie par le document. Cette valeur détermine comment lire les autres enregistrements.

## Disposition

```
TAG WORD          0001 1LLL L001 0000      Codec 0x10
[TAG d'extension de Length]
Payload           édition de la spécification. v1 = 0x0001
```

- Codec : Meta `0x10`, classe de définition (`001`)
- Payload : valeur brute (entier non signé de la largeur la plus courte)
- Nombre : au plus un

## Interprétation et validité

- Ne s'appuie sur aucun code de Value. Pour que le décodeur de n'importe quelle édition puisse le lire, il ne contient qu'un entier, sans Value intégré.
- Si l'édition est inconnue, le décodeur rejette le document ou émet un avertissement.
- S'il est absent, le document est lu selon l'édition que connaît le décodeur. Un document publié l'indique.

## Exemple

- `0x1890 0x0001` : GEUL v1

## Problèmes ouverts

- Correspondance avec les versions du document de codebook ([Documents de spécification](/fr/grammar/codec-spec/)).
