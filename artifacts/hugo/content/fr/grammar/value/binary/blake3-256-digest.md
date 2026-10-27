---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST est un format d'Issuer fixe de 20 WORD qui contient les 32 premiers octets de la sortie du mode de hachage par défaut de BLAKE3."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST est une Value de largeur fixe qui contient les 32 premiers octets (256 bits) de la sortie du default hash mode de BLAKE3. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0xC000`, famille BINARY. Le Payload fait exactement 16 WORD et ne contient ni keyed hash mode, ni key derivation mode, ni sortie XOF d'une autre longueur.

## Disposition

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG d'extension de Length   1 WORD  0x0014 (20 WORD au total)
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interprétation et validité

- Le Payload est constitué des 32 premiers octets de l'output stream du default hash mode de BLAKE3. L'ordre de sortie est conservé et, dans chaque WORD, l'octet de poids fort vient en premier.
- On n'applique pas de conversion d'endian GEUL à la sortie. On regroupe deux par deux, dans l'ordre, la suite d'octets de sortie, pour la cadrer en WORD big-endian de 16 bits.
- Si le Payload n'est pas de 16 WORD, ou s'il contient un résultat de keyed_hash, de derive_key ou de XOF d'une autre longueur, on rejette. Il n'y a ni descriptor ni remplissage.

## Fondement normatif

- L'algorithme et la définition des modes et de la sortie suivent le [dépôt d'implémentation officiel](https://github.com/BLAKE3-team/BLAKE3) de l'équipe BLAKE3 et la [spécification BLAKE3](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- Le TAG GEUL, la Length et le cadrage en WORD de 16 bits sont des règles ajoutées par ce format et ne font pas partie de l'algorithme BLAKE3.

## Longueur

- Le total est exactement de 20 WORD, soit le TAG de 1 WORD, le TAG d'extension de Length de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 16 WORD, avec `LLLL=1110`. Il n'y a ni descriptor ni remplissage.
- Si le Payload n'est pas exactement de 16 WORD, on rejette.

## Exemple

- Les octets de sortie `d[0]` à `d[31]` se placent dans l'ordre de sortie, deux par deux, dans les 16 WORD du Payload. La Length totale est toujours de 20 WORD.
