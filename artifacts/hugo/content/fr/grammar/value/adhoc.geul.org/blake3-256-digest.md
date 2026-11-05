---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST est une Value de largeur fixe qui contient les 32 premiers octets (256 bits) de la sortie du default hash mode de BLAKE3."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


BLAKE3-256-DIGEST est une Value de largeur fixe qui contient les 32 premiers octets (256 bits) de la sortie du default hash mode de BLAKE3. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x0000C000`, famille BINARY. Le Payload fait exactement 16 WORD ; il ne contient ni keyed hash mode, ni key derivation mode, ni sortie XOF d'une autre longueur.

## Disposition {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG d'extension de Length   1 WORD  0x0016 (22 WORD au total)
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x0000C000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interprétation et validité {#해석과-유효성}

- Le Payload correspond aux 32 premiers octets de l'output stream du default hash mode de BLAKE3. L'ordre de sortie est conservé et, dans chaque WORD, l'octet de poids fort vient en premier.
- Aucune conversion d'endian de GEUL n'est appliquée à la sortie. La séquence d'octets de sortie est regroupée par deux octets, dans l'ordre, en WORD big-endian de 16 bits (framing).
- Toute représentation dont le Payload ne fait pas 16 WORD, ou qui contient un résultat de keyed_hash, de derive_key ou de XOF d'une autre longueur, est rejetée. Il n'y a ni descriptor ni padding.

## Référence normative {#표준-근거}

- L'algorithme et la définition des modes et de la sortie suivent le [dépôt d'implémentation officiel](https://github.com/BLAKE3-team/BLAKE3) de l'équipe BLAKE3 et la [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- Le TAG et la Length de GEUL ainsi que le framing en WORD de 16 bits sont des règles ajoutées par ce format ; ils ne font pas partie de l'algorithme BLAKE3.

## Length {#길이}

- Le total est de 22 WORD exactement : TAG 1 WORD, TAG d'extension de Length 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 16 WORD ; on utilise `LLLL=1110`. Il n'y a ni descriptor ni padding.
- Si le Payload ne fait pas exactement 16 WORD, on rejette.

## Exemple {#예시}

- Les octets de sortie `d[0]` à `d[31]` sont placés dans les 16 WORD du Payload, deux octets par WORD, dans l'ordre de sortie. La Length totale est toujours de 22 WORD.
