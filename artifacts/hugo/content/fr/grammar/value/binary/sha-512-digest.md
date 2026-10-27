---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST est un format d'Issuer NIST fixe de 36 WORD qui contient l'intégralité du résultat SHA-512 de 512 bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST est une Value de largeur fixe qui contient l'intégralité du résultat de SHA-512 de la famille SHA-2. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, numéro de format `0xC000`, famille BINARY. Le Payload fait exactement 32 WORD (512 bits) et la troncature (truncation) n'est pas admise.

## Disposition

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG d'extension de Length   1 WORD  0x0024 (36 WORD au total)
Issuer            1 WORD  0x0062 (NIST)
Numéro de format  1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## Interprétation et validité

- Les 64 octets du Payload se lisent dans l'ordre même de la sortie de SHA-512. Dans chaque WORD, l'octet de poids fort vient en premier.
- On n'applique pas de conversion d'endian GEUL à la chaîne de bits du digest. On regroupe simplement deux par deux, dans l'ordre, la suite d'octets de sortie, pour la cadrer en WORD big-endian de 16 bits.
- Si le Payload n'est pas de 32 WORD, ou si le résultat a été tronqué arbitrairement, on rejette. Il n'y a ni descriptor ni remplissage.

## Fondement normatif

- L'algorithme SHA-512 et son résultat de 512 bits suivent le [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) du NIST.
- Le TAG GEUL, la Length et le cadrage en WORD de 16 bits sont des règles ajoutées par ce format et ne font pas partie de l'algorithme SHA-2.

## Longueur

- Le total est exactement de 36 WORD, soit le TAG de 1 WORD, le TAG d'extension de Length de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 32 WORD, avec `LLLL=1110`. Il n'y a ni descriptor ni remplissage.
- Si le Payload n'est pas exactement de 32 WORD, on rejette.

## Exemple

- Les octets du digest `d[0]` à `d[63]` se placent dans l'ordre, de `(d[0]<<8)|d[1]` à `(d[62]<<8)|d[63]`, comme WORD du Payload. La Length totale est toujours de 36 WORD.
