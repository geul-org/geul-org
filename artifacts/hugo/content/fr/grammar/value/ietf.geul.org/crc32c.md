---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C est une Value de largeur fixe qui contient un résultat CRC-32C."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


CRC32C est une Value de largeur fixe qui contient un résultat CRC-32C. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, numéro de Codec `0x0000C000`, famille BINARY. Le Payload fait exactement 2 WORD (32 bits).

## Disposition {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  7 WORD au total
Issuer            2 WORD  0x00000007 (IETF)
Numéro de Codec   2 WORD  0x0000C000
Payload           2 WORD  CRC32C 16 bits hauts │ 16 bits bas
```

## Interprétation et validité {#해석과-유효성}

- En notation de paramètres CRC : width 32, polynôme de Castagnoli `0x1EDC6F41`, refin/refout true, init `0xFFFFFFFF`, xorout `0xFFFFFFFF`.
- L'entier unsigned de 32 bits résultant du calcul est stocké en ordre de WORD big-endian. Cette sérialisation n'est ni la disposition du Checksum field SCTP de la RFC 3309 ni le byte mapping du digest iSCSI de la RFC 3720.
- Si le Payload ne fait pas 2 WORD, on rejette.

## Référence normative {#표준-근거}

- Le calcul du CRC-32C ainsi que le polynôme de Castagnoli et les règles de réflexion suivent la définition du CRC32C dans la [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) et la [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- Le TAG et la Length de GEUL ainsi que le framing en WORD big-endian de 16 bits de l'entier de 32 bits calculé sont des règles ajoutées par ce format.

## Length {#길이}

- Le total est de 7 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 2 WORD ; on utilise la longueur directe `LLLL=0110`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 2 WORD, on rejette.

## Exemple {#예시}

Valeur de contrôle CRC-32C `0xE3069283` de l'ASCII `123456789` :

```
09D6 0000 0007 0000 C000 E306 9283
```
