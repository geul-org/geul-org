---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 est une Value qui représente un nombre rationnel par une fraction irréductible d'un numerator int64 et d'un denominator int64 big-endian."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


RATIONAL-I64 est une Value qui représente un nombre rationnel par une fraction irréductible d'un numerator int64 et d'un denominator int64 big-endian. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x00000702`, famille NUMERIC.

## Disposition {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD au total
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interprétation et validité {#해석과-유효성}

- Chaque int64 est un entier en complément à deux de largeur fixe, obtenu en concaténant les WORD à partir du WORD de poids fort ; la valeur est `numerator / denominator`.
- Il n'y a pas de padding ABI.
- Le Payload fait exactement 8 WORD et le denominator doit être positif.
- Seule la forme irréductible, avec `gcd(|numerator|, denominator) = 1`, est admise. Zéro s'écrit uniquement `0/1`.

## Statut du format {#형식-지위}

- Les deux int64, le denominator positif, le plus grand commun diviseur égal à 1 et la canonicalization `0/1` ne sont pas l'adoption d'un standard wire externe : c'est un format propre à GEUL.
- Cette page définit entièrement la représentation, y compris l'interprétation en complément à deux de chaque int64, l'ordre des composantes et le framing en WORD big-endian.

## Length {#길이}

- Le total est de 13 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 8 WORD ; on utilise la longueur directe `LLLL=1100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 8 WORD, on rejette.

## Exemple {#예시}

- Le numerator `1` et le denominator `2` donnent `1/2`, valide. `2/4`, `0/2` et un denominator `-2` sont invalid.
