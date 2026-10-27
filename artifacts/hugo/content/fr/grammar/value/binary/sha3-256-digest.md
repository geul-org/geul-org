---
title: "SHA3-256-DIGEST"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST est un format d'Issuer NIST fixe de 20 WORD qui contient l'intégralité du résultat SHA3-256 de 256 bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST est une Value de largeur fixe qui contient l'intégralité du résultat de SHA3-256. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, numéro de format `0xC001`, famille BINARY. Le Payload fait exactement 16 WORD (256 bits) et la troncature (truncation) n'est pas admise.

## Disposition

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG d'extension de Length   1 WORD  0x0014 (20 WORD au total)
Issuer            1 WORD  0x0062 (NIST)
Numéro de format  1 WORD  0xC001
Payload           16 WORD  SHA3-256 Digest
```

## Interprétation et validité

- Les 32 octets du Payload se lisent dans l'ordre même de la sortie de SHA3-256. Dans chaque WORD, l'octet de poids fort vient en premier.
- On n'applique pas de conversion d'endian GEUL à la chaîne de bits du digest. On regroupe simplement deux par deux, dans l'ordre, la suite d'octets de sortie, pour la cadrer en WORD big-endian de 16 bits.
- Si le Payload n'est pas de 16 WORD, ou si le résultat a été tronqué arbitrairement, on rejette. Il n'y a ni descriptor ni remplissage.

## Fondement normatif

- L'algorithme SHA3-256 et son résultat de 256 bits suivent le [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final) du NIST. Le [projet Hash Functions](https://csrc.nist.gov/Projects/hash-functions) du NIST présente lui aussi la norme SHA-3.
- Le TAG GEUL, la Length et le cadrage en WORD de 16 bits sont des règles ajoutées par ce format et ne font pas partie de l'algorithme SHA-3.

## Longueur

- Le total est exactement de 20 WORD, soit le TAG de 1 WORD, le TAG d'extension de Length de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 16 WORD, avec `LLLL=1110`. Il n'y a ni descriptor ni remplissage.
- Si le Payload n'est pas exactement de 16 WORD, on rejette.

## Exemple

- Les octets du digest `d[0]` à `d[31]` se placent dans l'ordre de sortie, deux par deux, dans les 16 WORD du Payload. La Length totale est toujours de 20 WORD.
