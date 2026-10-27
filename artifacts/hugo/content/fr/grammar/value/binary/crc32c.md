---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C est un format d'Issuer IETF fixe de 5 WORD qui contient le résultat de 32 bits du CRC-32C de Castagnoli."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C est une Value de largeur fixe qui contient le résultat d'un CRC-32C. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, numéro de format `0xC000`, famille BINARY. Le Payload fait exactement 2 WORD (32 bits).

## Disposition

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD au total
Issuer            1 WORD  0x0020 (IETF)
Numéro de format  1 WORD  0xC000
Payload           2 WORD  CRC32C 16 bits de poids fort │ 16 bits de poids faible
```

## Interprétation et validité

- En notation de paramètres CRC : width 32, polynôme de Castagnoli `0x1EDC6F41`, refin/refout true, init `0xffffffff`, xorout `0xffffffff`.
- L'entier unsigned de 32 bits résultat du calcul est stocké en ordre big-endian des WORD. Cette sérialisation n'est pas elle-même la disposition du champ SCTP Checksum de la RFC 3309 ni le byte mapping du digest iSCSI de la RFC 3720.
- Si le Payload n'est pas de 2 WORD, on rejette.

## Fondement normatif

- Le calcul du CRC-32C, le polynôme de Castagnoli et les règles de réflexion suivent la définition du CRC32C de la [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) et de la [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- Le TAG GEUL, la Length et le cadrage en WORD big-endian de 16 bits de l'entier de 32 bits calculé sont des règles ajoutées par ce format.

## Longueur

- Le total est exactement de 5 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 2 WORD, avec la longueur directe `LLLL=0100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 2 WORD, on rejette.

## Exemple

Valeur de contrôle CRC-32C `0xe3069283` de l'ASCII `123456789` :

```
0A7C 0020 C000 e306 9283
```
