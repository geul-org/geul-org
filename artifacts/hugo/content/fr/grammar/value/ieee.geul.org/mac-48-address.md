---
title: "MAC-48-ADDRESS"
weight: 1031
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS est une Value de largeur fixe qui contient une adresse MAC IEEE 802 de 48 bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


MAC-48-ADDRESS est une Value de largeur fixe qui contient une adresse MAC IEEE 802 de 48 bits. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, numéro de Codec `0x0000C000`, famille BINARY. Le Payload fait exactement 3 WORD (6 octets, 48 bits).

## Disposition {#레이아웃}

```
TAG WORD          0x09D7 (0000 1001 1101 0111)  8 WORD au total
Issuer            2 WORD  0x0000000D (IEEE)
Numéro de Codec   2 WORD  0x0000C000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interprétation et validité {#해석과-유효성}

- Les six octets de l'adresse MAC de 48 bits sont conservés dans l'ordre des octets de la chaîne de notation et de la transmission LAN. Les octets 0–1, 2–3 et 4–5 sont regroupés chacun dans un WORD, de l'octet de poids fort à l'octet de poids faible.
- Sur les supports IEEE 802, le least-significant bit de chaque octet est transmis en premier, mais on n'inverse pas pour autant les bits à l'intérieur d'un octet. I/G et U/L restent tels quels dans le least-significant bit de l'octet 0 et le bit suivant.
- I/G=0 est une adresse individual, utilisée comme unicast en destination ; I/G=1 est une adresse group, utilisée comme multicast ou broadcast. U/L=0 est une adresse universally administered, U/L=1 une adresse locally administered.
- Aucun pattern n'est structurellement exclu en raison des valeurs de I/G ou de U/L. Les adresses universally/locally administered et individual/group sont toutes représentables, de même que les adresses MAC locally administered, randomized, spoofed et virtuelles, en tant que valeurs de 48 bits.
- Cette valeur ne conserve que les 48 bits de l'adresse observée ou présentée. Elle ne garantit ni une adresse permanente d'un appareil donné, ni l'unicité mondiale, ni l'authentification de l'appareil ou de l'utilisateur, ni la propriété, ni un lien durable avec un même appareil.
- Ce format ne traite que les adresses MAC IEEE 802 d'exactement 48 bits. Il ne contient ni EUI-64 ni d'autres adresses MAC de 64 bits. L'IEEE RA décrit le terme historique `MAC-48` comme obsolete, mais toutes les adresses MAC de 48 bits ne pouvant pas être appelées EUI-48, ce format n'est pas automatiquement assimilé à EUI-48.
- Si le Payload ne fait pas exactement 3 WORD, on rejette.

## Référence normative {#표준-근거}

- Le document [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) de l'IEEE Registration Authority note l'adresse MAC LAN de 48 bits en six octets dans l'ordre de transmission, explique que chaque octet est transmis à partir du least-significant bit, et que I/G et U/L sont les deux least-significant bits du premier octet. Ce format conserve telles quelles les positions des octets et des bits.
- Les [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) de l'IEEE Registration Authority définissent I/G=0/1 comme individual/group et U/L=0/1 comme universal/local administration, et expliquent que les adresses locales ne sont pas globalement uniques. Elles expliquent aussi la relation historique et la différence entre `MAC-48` et EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) explique que EUI-48 et EUI-64 peuvent servir d'adresses MAC, entre autres. Cela ne signifie pas que l'EUI-64 est placé dans cet enregistrement de 48 bits.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) et [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) consignent que des appareils réels peuvent générer et changer aléatoirement des adresses MAC locally administered. On n'infère donc pas d'identity permanente d'appareil à partir de la seule valeur MAC.
- Le TAG de GEUL, l'attribution d'Issuer, la Length directe et le framing en WORD de 16 bits ne font partie ni d'IEEE 802 ni des documents ci-dessus : ce sont des règles ajoutées par ce format.

## Length {#길이}

- Le total est de 8 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 3 WORD ; on utilise la longueur directe `LLLL=0111`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 3 WORD, on rejette.

## Exemple {#예시}

Adresse locally administered individual (unicast) `02:00:5e:10:00:00` (I/G=0 et U/L=1 du premier octet `0x02`) :

```
09D7 0000 000D 0000 C000 0200 5E10 0000
```
