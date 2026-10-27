---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS est un format d'Issuer IETF fixe de 11 WORD qui contient dans l'ordre une adresse IPv6 de 128 bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS est une Value de largeur fixe qui contient la valeur de 128 bits d'une adresse IPv6. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, numéro de format `0xC002`, famille BINARY. Le Payload fait exactement 8 WORD (128 bits).

## Disposition

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD au total
Issuer            1 WORD  0x0020 (IETF)
Numéro de format  1 WORD  0xC002
Payload           8 WORD (128 bits)  IPv6 address, high-order bit → low-order bit
```

## Interprétation et validité

- On concatène les huit WORD du Payload à partir du WORD de poids fort et l'on lit dans l'ordre les 128 bits du champ d'adresse IPv6. Dans chaque WORD, l'octet qui vient en premier est les 8 bits de poids fort.
- Le Payload ne contient que les 128 bits d'une seule adresse. Il ne contient ni longueur de préfixe CIDR, ni port, ni protocole de transport.
- L'identifiant de zone n'étant pas dans les 128 bits de l'adresse, on ne le met pas dans le Payload. Pour une adresse scoped qui exige une zone, on la fournit par un contexte externe comme l'interface, un Edge, une Reference ou un Profile.
- Tous les motifs de 128 bits peuvent être représentés. Le sens d'usage et l'utilisabilité de motifs non spécifié, loopback, multicast, spécial ou réservé se jugent dans le contexte externe et ne limitent pas la validité structurelle.
- IPV4-ADDRESS et IPV6-ADDRESS sont des formats distincts. Une adresse IPv6 IPv4-mapped est elle aussi conservée comme valeur IPv6 de 128 bits et n'est ni identifiée automatiquement à IPV4-ADDRESS ni normalisée l'une dans l'autre.
- On peut employer cette Value comme composant identifiant d'une Reference, mais le scope et la politique de référence ne sont pas dans le motif de bits de l'adresse.

## Fondement normatif

- La [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) définit l'adresse IPv6 comme un identifiant de 128 bits et fixe le format de bits des adresses, y compris unicast, anycast, multicast et IPv4-mapped IPv6. Ce format conserve ces 128 bits sans les réinterpréter.
- La [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) définit Source Address et Destination Address d'un paquet IPv6 comme des champs de 128 bits chacun. Les WORD du Payload conservent l'ordre du bit de poids fort au bit de poids faible de ce champ d'adresse.
- La [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) précise que la zone d'une adresse non globale n'est pas encodée dans l'adresse elle-même mais fixée par le contexte. C'est pourquoi l'identifiant de zone reste hors du Payload.
- La notation en chaîne de la RFC 4291 ne peut servir qu'à l'explication et à l'entrée et sortie. La [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) ne fixe pas de format de stockage interne : on n'emploie donc pas sa canonicalisation de chaîne comme canonicalisation de cet enregistrement binary.
- Le TAG GEUL, l'attribution de l'Issuer, la Length directe et le cadrage en WORD de 16 bits ne font pas partie de ces RFC : ce sont des règles ajoutées par ce format.

## Longueur

- Le total est exactement de 11 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 8 WORD, avec la longueur directe `LLLL=1010`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 8 WORD, on rejette.

## Exemple

Adresse IPv6 `2001:db8::1` :

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- La notation abrégée de la chaîne n'a pas d'effet sur le Payload.
