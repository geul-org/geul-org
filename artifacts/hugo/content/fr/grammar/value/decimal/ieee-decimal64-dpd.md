---
title: "IEEE-DECIMAL64-DPD"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-DPD est une Value fixe de 7 WORD qui contient telle quelle la suite de bits d'interchange IEEE 754 decimal64 DPD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-DPD est une Value qui représente l'encodage d'interchange IEEE 754 decimal64 DPD. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, numéro de format `0x2001`, famille DECIMAL. Le motif de bits DPD est conservé tel quel et se distingue de BID.

## Disposition

```
TAG WORD          0x0B7C  7 WORD au total
Issuer            1 WORD  0x0040 (IEEE)
Numéro de format  1 WORD  0x2001
Payload           4 WORD (64 bits)  IEEE decimal64 DPD Interchange
```

## Interprétation

- Les quatre WORD du Payload, concaténés à partir du WORD de poids fort, se lisent comme la suite de bits d'interchange IEEE 754 decimal64 DPD.
- Le motif de bits est conservé et n'est pas réinterprété arbitrairement comme BID ou un format décimal exact.
- Les valeurs spéciales et les payload ne sont pas normalisés arbitrairement.

## Validité et longueur

- Le total est exactement de 7 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 4 WORD, avec la longueur directe `LLLL=0110`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 4 WORD, on rejette.
- La validité sémantique de la suite de bits suit les règles d'interchange IEEE DPD.

## Exemple

| Structure | Verdict |
|---|---|
| `0B7C 0040 2001` + 4 WORD DPD (suite de bits) | structure de longueur canonique |
| `0B7C 0040 2001` + 2 WORD | invalid : largeur de Payload incohérente |
| Même 64 bits avec le numéro de format `0x2004` | format BID, ce n'est pas ce type |

## Fondement normatif

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/) : on applique l'encodage décimal du coefficient (DPD) du format d'interchange decimal64. On conserve l'encodage de 64 bits choisi sans conversion numérique vers l'alternative BID admise par IEEE, et GEUL n'ajoute que le TAG et le cadrage big-endian en WORD.
