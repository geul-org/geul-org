---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST est une Value de largeur fixe qui contient le résultat complet de SHA3-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


SHA3-256-DIGEST est une Value de largeur fixe qui contient le résultat complet de SHA3-256. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, numéro de Codec `0x0000C001`, famille BINARY. Le Payload fait exactement 16 WORD (256 bits), et la troncature (truncation) n'est pas permise.

## Disposition {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG d'extension de Length   1 WORD  0x0016 (22 WORD au total)
Issuer            2 WORD  0x00000015 (NIST)
Numéro de Codec   2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## Interprétation et validité {#해석과-유효성}

- Les 32 octets du Payload sont lus dans l'ordre de sortie de SHA3-256. Dans chaque WORD, l'octet de poids fort vient en premier.
- Aucune conversion d'endian de GEUL n'est appliquée au digest bit string. La séquence d'octets de sortie est simplement regroupée par deux octets, dans l'ordre, en WORD big-endian de 16 bits (framing).
- Toute représentation dont le Payload ne fait pas 16 WORD, ou dont le résultat a été tronqué arbitrairement, est rejetée. Il n'y a ni descriptor ni padding.

## Référence normative {#표준-근거}

- L'algorithme SHA3-256 et son résultat de 256 bits suivent la norme NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). Le [projet Hash Functions](https://csrc.nist.gov/Projects/hash-functions) du NIST présente lui aussi la norme SHA-3.
- Le TAG et la Length de GEUL ainsi que le framing en WORD de 16 bits sont des règles ajoutées par ce format ; ils ne font pas partie de l'algorithme SHA-3.

## Length {#길이}

- Le total est de 22 WORD exactement : TAG 1 WORD, TAG d'extension de Length 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 16 WORD ; on utilise `LLLL=1110`. Il n'y a ni descriptor ni padding.
- Si le Payload ne fait pas exactement 16 WORD, on rejette.

## Exemple {#예시}

- Les octets du digest `d[0]` à `d[31]` sont placés dans les 16 WORD du Payload, deux octets par WORD, dans l'ordre de sortie. La Length totale est toujours de 22 WORD.
