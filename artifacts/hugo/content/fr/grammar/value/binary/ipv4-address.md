---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS est un format d'Issuer IETF fixe de 5 WORD qui contient telle quelle, en network byte order, une adresse IPv4 de 32 bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS est une Value de largeur fixe qui contient la valeur de 32 bits d'une adresse IPv4. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, numéro de format `0xC001`, famille BINARY. Le Payload fait exactement 2 WORD (32 bits).

## Disposition

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD au total
Issuer            1 WORD  0x0020 (IETF)
Numéro de format  1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interprétation et validité

- Les octets de l'adresse restent en network byte order. Dans chaque WORD, l'octet qui vient en premier est les 8 bits de poids fort, le suivant les 8 bits de poids faible.
- Le Payload ne contient que les 32 bits d'une seule adresse. Il ne contient ni longueur de préfixe CIDR, ni port, ni protocole de transport.
- Tous les motifs de 32 bits peuvent être représentés. Le sens d'usage et l'utilisabilité de motifs comme non spécifié, spécial, réservé ou multicast se jugent dans le contexte externe et ne limitent pas la validité structurelle.
- IPV4-ADDRESS et IPV6-ADDRESS sont des formats distincts. Une adresse IPv6 IPv4-mapped n'est ni convertie automatiquement dans ce format ni normalisée comme la même valeur.
- On peut employer cette Value comme composant identifiant d'une Reference, mais la politique de référence et la durée de vie ne sont pas dans le motif de bits de l'adresse.
- Si le Payload n'est pas exactement de 2 WORD, on rejette.

## Fondement normatif

- La [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) définit l'adresse IPv4 comme 4 octets (32 bits) de longueur fixe, et définit Source Address et Destination Address comme des champs de 32 bits chacun. On conserve dans le Payload l'ordre de transmission des octets de l'Appendix B et la règle most-significant-bit-first de chaque octet.
- Le TAG GEUL, l'attribution de l'Issuer, le regroupement en WORD de 16 bits et la Length ne font pas partie de la RFC 791 : ce sont des règles de cadrage ajoutées par ce format.

## Longueur

- Le total est exactement de 5 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 2 WORD, avec la longueur directe `LLLL=0100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 2 WORD, on rejette.

## Exemple

Adresse IPv4 `1.2.3.4` :

```
0a7c 0020 c001 0102 0304
```
