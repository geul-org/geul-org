---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST est une Value fixe de 18 WORD qui contient l'intégralité du résultat SHA-256 de 256 bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-256-DIGEST est une Value de largeur fixe qui contient l'intégralité du résultat de SHA-256 de la famille SHA-2. Code direct de Value `0x61`, famille BINARY. Le Payload fait exactement 16 WORD (256 bits) et la troncature (truncation) n'est pas admise.

## Disposition

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
TAG d'extension de Length   1 WORD  0x0012 (18 WORD au total)
Payload           16 WORD  SHA-256 Digest
```

## Interprétation et validité

- Les 32 octets du Payload se lisent dans l'ordre même de la sortie de SHA-256. Dans chaque WORD, l'octet de poids fort vient en premier.
- On n'applique pas de conversion d'endian GEUL à la chaîne de bits du digest. On regroupe simplement deux par deux, dans l'ordre, la suite d'octets de sortie, pour la cadrer en WORD big-endian de 16 bits.
- Si le Payload n'est pas de 16 WORD, ou si le résultat a été tronqué arbitrairement, on rejette. Il n'y a ni descriptor ni remplissage.

## Fondement normatif

- L'algorithme SHA-256 et son résultat de 256 bits suivent le [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) du NIST.
- Le TAG GEUL, la Length et le cadrage en WORD de 16 bits sont des règles ajoutées par ce format et ne font pas partie de l'algorithme SHA-2.

## Longueur

- Le total est exactement de 18 WORD, soit le TAG de 1 WORD, le TAG d'extension de Length de 1 WORD et le Payload de 16 WORD, avec `LLLL=1110`. Il n'y a ni descriptor ni remplissage.
- Si le Payload n'est pas exactement de 16 WORD, on rejette.

## Exemple

- Les octets du digest `d[0]` à `d[31]` se placent dans l'ordre, de `(d[0]<<8)|d[1]` à `(d[30]<<8)|d[31]`, comme WORD du Payload. La Length totale est toujours de 18 WORD.
