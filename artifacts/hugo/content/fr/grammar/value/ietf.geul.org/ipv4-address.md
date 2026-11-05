---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS est une Value de largeur fixe qui contient la valeur de 32 bits d'une adresse IPv4."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


IPV4-ADDRESS est une Value de largeur fixe qui contient la valeur de 32 bits d'une adresse IPv4. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, numéro de Codec `0x0000C001`, famille BINARY. Le Payload fait exactement 2 WORD (32 bits).

## Disposition {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  7 WORD au total
Issuer            2 WORD  0x00000007 (IETF)
Numéro de Codec   2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interprétation et validité {#해석과-유효성}

- Les octets de l'adresse sont conservés en network byte order. Dans chaque WORD, l'octet qui vient en premier occupe les 8 bits hauts et l'octet suivant les 8 bits bas.
- Le Payload ne contient que les 32 bits d'une seule adresse. Il ne contient ni CIDR prefix length, ni port, ni protocole de transport.
- Tous les bit patterns de 32 bits sont représentables. La signification opérationnelle et la possibilité d'emploi de patterns tels que unspecified, spéciaux, réservés ou multicast se jugent dans le contexte externe et ne limitent pas la validité structurelle.
- IPV4-ADDRESS et IPV6-ADDRESS sont des formats distincts. Une adresse IPv6 IPv4-mapped n'est ni convertie automatiquement vers ce format ni normalisée comme la même valeur.
- Cette Value peut servir de composant d'identifiant d'une Reference, mais la politique de référence et la durée de vie ne figurent pas dans le bit pattern de l'adresse.
- Si le Payload ne fait pas exactement 2 WORD, on rejette.

## Référence normative {#표준-근거}

- La [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) définit l'adresse IPv4 comme une longueur fixe de 4 octets (32 bits), avec le Source Address et le Destination Address comme champs de 32 bits. L'ordre de transmission des octets de l'Appendix B et la règle most-significant-bit-first de chaque octet sont conservés dans le Payload.
- Le TAG de GEUL, l'attribution d'Issuer, le regroupement en WORD de 16 bits et la Length ne font pas partie de la RFC 791 : ce sont des règles de framing ajoutées par ce format.

## Length {#길이}

- Le total est de 7 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 2 WORD ; on utilise la longueur directe `LLLL=0110`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 2 WORD, on rejette.

## Exemple {#예시}

Adresse IPv4 `1.2.3.4` :

```
09D6 0000 0007 0000 C001 0102 0304
```
