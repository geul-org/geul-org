---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID est une Value fixe de 9 WORD qui contient telle quelle la valeur de 128 bits d'un UUID de la RFC 9562, en 16 octets canoniques."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID est une Value de largeur fixe qui contient la valeur de 128 bits d'un UUID de la RFC 9562. Code direct de Value `0x60`, famille BINARY. Le Payload fait exactement 8 WORD (16 octets, 128 bits).

## Disposition

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  9 WORD au total
Payload           8 WORD (128 bits)  UUID octet 0 → octet 15
```

## Interprétation et validité

- On regroupe deux par deux, dans l'ordre, les octets 0 à 15 de l'UUID canonique de la RFC 9562. L'octet qui vient en premier est les 8 bits de poids fort du WORD. On ne réarrange ni ne ré-encode les champs, les bits de version ni les bits de variant de l'UUID.
- La chaîne hex-et-tirets `8-4-4-4-12` n'est qu'une représentation d'entrée et de sortie. La casse et les tirets n'entrent pas dans le Payload, et l'on ne stocke que les 16 octets obtenus après analyse.
- Cette Value UUID conserve sans perte le motif de 128 bits. Pour le variant `10xx` de la RFC 9562, les versions 1, 3, 4, 5, 6 et 7 ont une disposition standard et la version 8 est un format d'UUID personnalisé. La version 2 est réservée à DCE Security et la RFC n'en fixe pas la disposition, la version 0 est unused et les versions 9 à 15 sont réservées à une définition future. Les autres variants sont aussi réservés pour la compatibilité ou une définition future.
- L'UUID Nil est la valeur spéciale de 128 bits tous à zéro, l'UUID Max celle de 128 bits tous à un. On n'exclut pas structurellement les motifs de 128 bits, y compris ceux des versions et variants réservés ou unused, et le sens et l'interopérabilité de ce motif se jugent selon la norme applicable et le contexte externe.
- L'identité d'un UUID se juge par l'égalité de la valeur de 128 bits du Payload. Le fait que la valeur soit la même ne garantit ni l'authentification de la cible, ni la propriété, ni l'existence actuelle, ni la résolvabilité, ni les droits d'accès.
- En stockant un GUID COM de Microsoft, on ne copie pas telle quelle sa représentation mémoire ou sérialisée mixed-endian. On le convertit d'abord en 16 octets dans l'ordre canonique des champs et octets de la RFC 9562.
- Si le Payload n'est pas exactement de 8 WORD, on rejette.

## Fondement normatif

- La [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) définit l'UUID comme 16 octets (128 bits) et encode les champs most-significant-byte-first, de sorte que le format binaire enchaîne les champs en ordre big-endian. Le variant est dans les bits de poids fort de l'octet 8 et la version dans les 4 bits de poids fort de l'octet 6, et ce format conserve tels quels ces emplacements.
- Les sections 4.1–5.10 de la RFC 9562 distinguent le variant, les versions 1–8, Nil, Max et les plages réservées. La RFC 9562 remplaçant la RFC 4122, la norme en vigueur de ce format est la RFC 9562.
- L'ABNF hex-et-tirets de la RFC 9562 est une représentation textuelle, et elle indique à part la réserve du little-endian des GUID COM. GEUL ne met dans le Payload que les 16 octets canoniques de l'UUID de la RFC.
- Le TAG GEUL, la Length directe et le cadrage en WORD de 16 bits ne font pas partie de la RFC 9562 : ce sont des règles ajoutées par ce format.

## Longueur

- Le total est exactement de 9 WORD, soit le TAG de 1 WORD plus le Payload de 8 WORD, avec la longueur directe `LLLL=1000`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 8 WORD, on rejette.

## Exemple

Vecteur de test UUIDv7 de l'Appendix A.6 de la RFC 9562 `017f22e2-79b0-7cc3-98c4-dc0c0c07398f` :

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`, Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`.
