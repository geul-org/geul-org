---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS est une Value de largeur fixe qui contient la valeur de 128 bits d'une adresse IPv6."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


IPV6-ADDRESS est une Value de largeur fixe qui contient la valeur de 128 bits d'une adresse IPv6. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, numéro de Codec `0x0000C002`, famille BINARY. Le Payload fait exactement 8 WORD (128 bits).

## Disposition {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD au total
Issuer            2 WORD  0x00000007 (IETF)
Numéro de Codec   2 WORD  0x0000C002
Payload           8 WORD (128 bits)  IPv6 address, high-order bit → low-order bit
```

## Interprétation et validité {#해석과-유효성}

- Les huit WORD du Payload sont concaténés à partir du WORD de poids fort, et les 128 bits du champ d'adresse IPv6 sont lus dans l'ordre. Dans chaque WORD, l'octet qui vient en premier correspond aux 8 bits hauts.
- Le Payload ne contient que les 128 bits d'une seule adresse. Il ne contient ni CIDR prefix length, ni port, ni protocole de transport.
- Le zone identifier ne figurant pas dans les 128 bits de l'adresse, il n'est pas placé dans le Payload. Une scoped address qui nécessite une zone est fournie par un contexte externe tel qu'une interface, un Edge, une Reference ou un Profile.
- Tous les bit patterns de 128 bits sont représentables. La signification opérationnelle et la possibilité d'emploi de patterns unspecified, loopback, multicast, spéciaux ou réservés se jugent dans le contexte externe et ne limitent pas la validité structurelle.
- IPV4-ADDRESS et IPV6-ADDRESS sont des formats distincts. Une adresse IPv6 IPv4-mapped est elle aussi conservée comme valeur IPv6 de 128 bits ; elle n'est ni assimilée automatiquement à IPV4-ADDRESS ni normalisée vers lui, et inversement.
- Cette Value peut servir de composant d'identifiant d'une Reference, mais le scope et la politique de référence ne figurent pas dans le bit pattern de l'adresse.

## Référence normative {#표준-근거}

- La [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) définit l'adresse IPv6 comme un identifier de 128 bits et fixe le bit format des adresses, y compris unicast, anycast, multicast et IPv4-mapped IPv6. Ce format conserve ces 128 bits sans les réinterpréter.
- La [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) définit le Source Address et le Destination Address d'un paquet IPv6 comme des champs de 128 bits. Les WORD du Payload conservent l'ordre du high-order bit au low-order bit de ce champ d'adresse.
- La [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) indique que la zone d'une non-global address n'est pas encodée dans l'adresse elle-même mais déterminée par le contexte. Le zone identifier est donc laissé hors du Payload.
- La notation en chaîne de la RFC 4291 ne peut servir qu'à l'explication et aux entrées/sorties. La [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) ne fixant pas de format de stockage interne, sa canonicalization de chaîne n'est pas utilisée comme canonicalization de cet enregistrement binary.
- Le TAG de GEUL, l'attribution d'Issuer, la Length directe et le framing en WORD de 16 bits ne font pas partie de ces RFC : ce sont des règles ajoutées par ce format.

## Length {#길이}

- Le total est de 13 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 8 WORD ; on utilise la longueur directe `LLLL=1100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 8 WORD, on rejette.

## Exemple {#예시}

Adresse IPv6 `2001:db8::1` :

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- La notation abrégée de la chaîne n'a pas d'effet sur le Payload.
