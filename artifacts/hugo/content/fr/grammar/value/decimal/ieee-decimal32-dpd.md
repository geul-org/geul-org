---
title: "IEEE-DECIMAL32-DPD"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD est une Value fixe de 5 WORD qui contient telle quelle la suite de bits d'interchange IEEE 754 decimal32 DPD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD est une Value qui représente l'encodage d'interchange IEEE 754 decimal32 DPD. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, numéro de format `0x2000`, famille DECIMAL. Le motif de bits DPD est conservé tel quel et se distingue de BID.

## Disposition

```
TAG WORD          0x0A7C  5 WORD au total
Issuer            1 WORD  0x0040 (IEEE)
Numéro de format  1 WORD  0x2000
Payload           2 WORD (32 bits)  IEEE decimal32 DPD Interchange
```

## Interprétation

- Les deux WORD du Payload, concaténés à partir du WORD de poids fort, se lisent comme la suite de bits d'interchange IEEE 754 decimal32 DPD.
- Le motif de bits est conservé et n'est pas réinterprété arbitrairement comme BID ou SIGNED-DECIMAL.
- Les valeurs spéciales et les payload ne sont pas normalisés arbitrairement.

## Validité et longueur

- Le total est exactement de 5 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 2 WORD, avec la longueur directe `LLLL=0100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 2 WORD, on rejette.
- La validité sémantique de la suite de bits suit les règles d'interchange IEEE DPD.

## Exemple

| Structure | Verdict |
|---|---|
| `0A7C 0040 2000` + 2 WORD DPD (suite de bits) | structure de longueur canonique |
| `0A7C 0040 2000` + 4 WORD | invalid : largeur de Payload incohérente |
| Même 32 bits avec le numéro de format `0x2003` | format BID, ce n'est pas ce type |

## Fondement normatif

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/) : on applique l'encodage décimal du coefficient (DPD) du format d'interchange decimal32. On conserve l'encodage de 32 bits choisi sans conversion numérique vers l'alternative BID admise par IEEE, et GEUL n'ajoute que le TAG et le cadrage big-endian en WORD.
