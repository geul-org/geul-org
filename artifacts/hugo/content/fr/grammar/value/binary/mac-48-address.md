---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS est un format d'Issuer IEEE fixe de 6 WORD qui contient telle quelle, dans l'ordre des octets, une adresse MAC IEEE 802 de 48 bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS est une Value de largeur fixe qui contient la valeur d'une adresse MAC IEEE 802 de 48 bits. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, numéro de format `0xC000`, famille BINARY. Le Payload fait exactement 3 WORD (6 octets, 48 bits).

## Disposition

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  6 WORD au total
Issuer            1 WORD  0x0040 (IEEE)
Numéro de format  1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interprétation et validité

- Les six octets de l'adresse MAC de 48 bits restent dans l'ordre des octets de la chaîne de notation et de la transmission LAN. Les octets 0–1, 2–3 et 4–5 sont regroupés chacun dans l'ordre de l'octet de poids fort à l'octet de poids faible d'un WORD.
- Sur les supports IEEE 802, le bit de poids faible de chaque octet est transmis en premier, mais on n'inverse pas pour autant les bits à l'intérieur d'un octet. I/G et U/L restent dans le bit de poids faible de l'octet 0 et le bit suivant.
- I/G=0 est une adresse individual, employée en unicast à la destination ; I/G=1 est une adresse group, employée en multicast ou broadcast. U/L=0 est une adresse universally administered, U/L=1 une adresse locally administered.
- Aucun motif n'est structurellement exclu à cause des valeurs de I/G ou U/L. Les adresses universally/locally administered, individual/group peuvent toutes être représentées, et les adresses MAC locally administered, randomisées, usurpées ou virtuelles peuvent aussi se représenter comme valeur de 48 bits.
- Cette valeur ne conserve que les 48 bits d'une adresse observée ou présentée. Elle ne garantit ni l'adresse permanente d'un appareil précis, ni l'unicité mondiale, ni l'authentification d'un appareil ou d'un utilisateur, ni la propriété, ni une liaison durable avec le même appareil.
- Ce format ne traite que les adresses MAC IEEE 802 d'exactement 48 bits. Il ne contient ni EUI-64 ni d'autres adresses MAC de 64 bits. L'IEEE RA décrit le terme historique `MAC-48` comme obsolete, mais toutes les adresses MAC de 48 bits ne peuvent pas s'appeler EUI-48, donc ce format n'est pas automatiquement identifié à EUI-48.
- Si le Payload n'est pas exactement de 3 WORD, on rejette.

## Fondement normatif

- Les [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) de l'IEEE Registration Authority notent l'adresse MAC LAN de 48 bits comme six octets dans l'ordre de transmission, expliquent que chaque octet est transmis à partir du bit de poids faible et que I/G et U/L sont les deux bits de poids faible du premier octet. Ce format conserve telles quelles les positions des octets et des bits.
- Les [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) de l'IEEE Registration Authority définissent I/G=0/1 comme individual/group et U/L=0/1 comme administration universal/local, et expliquent que les adresses locales ne sont pas uniques mondialement. Elles expliquent aussi la relation et la différence historiques entre `MAC-48` et EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) explique que EUI-48 et EUI-64 peuvent servir d'adresses MAC, etc. Cela ne signifie pas qu'on met un EUI-64 dans cet enregistrement de 48 bits.
- La [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) et la [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) consignent que des appareils réels peuvent générer et changer aléatoirement des adresses MAC locally administered. On ne déduit donc pas une identité permanente d'appareil de la seule valeur MAC.
- Le TAG GEUL, l'attribution de l'Issuer, la Length directe et le cadrage en WORD de 16 bits ne font pas partie d'IEEE 802 ni des documents ci-dessus : ce sont des règles ajoutées par ce format.

## Longueur

- Le total est exactement de 6 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 3 WORD, avec la longueur directe `LLLL=0101`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 3 WORD, on rejette.

## Exemple

Adresse locally administered individual (unicast) `02:00:5e:10:00:00` (I/G=0 et U/L=1 du premier octet `0x02`) :

```
0afc 0040 c000 0200 5e10 0000
```
