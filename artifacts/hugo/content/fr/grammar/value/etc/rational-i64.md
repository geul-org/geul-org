---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 est un format d'Issuer ADHOC fixe de 11 WORD qui contient un nombre rationnel sous forme de fraction irréductible d'un numérateur int64 et d'un dénominateur int64 positif."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 est une Value qui représente un nombre rationnel par une fraction irréductible d'un numerator int64 big-endian et d'un denominator int64. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x0702`, famille NUMERIC.

## Disposition

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD au total
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interprétation et validité

- Chaque int64 est un entier de largeur fixe en complément à deux, concaténé à partir du WORD de poids fort, et la valeur est `numerator / denominator`.
- Il n'y a pas de remplissage ABI.
- Le Payload fait exactement 8 WORD et le denominator doit être positif.
- Seule la forme irréductible avec `gcd(|numerator|, denominator) = 1` est admise. Zéro s'écrit uniquement `0/1`.

## Statut du format

- Les deux int64, le denominator positif, le plus grand commun diviseur égal à 1 et la canonicalisation `0/1` ne reprennent pas une norme wire externe : c'est un format propre à GEUL.
- Cette page définit complètement la représentation, y compris l'interprétation en complément à deux de chaque int64, l'ordre des composantes et le cadrage en WORD big-endian.

## Longueur

- Le total est exactement de 11 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 8 WORD, avec la longueur directe `LLLL=1010`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 8 WORD, on rejette.

## Exemple

- Le numerator `1` et le denominator `2` donnent `1/2`, valide. `2/4`, `0/2` et un denominator `-2` sont invalid.
