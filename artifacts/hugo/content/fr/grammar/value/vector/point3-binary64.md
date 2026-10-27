---
title: "POINT3-BINARY64"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 est une Value de point 3D à trois composantes IEEE 754 binary64 dans l'ordre (x, y, z) (format d'Issuer ADHOC 0x050B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 est un point 3D à trois composantes IEEE 754 binary64 dans l'ordre `(x, y, z)`.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x050B`. Famille NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG d'extension de Length   1 WORD  0x0010 (16 WORD au total)
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Règles d'interprétation

- Chaque composante se lit à partir du WORD de poids fort, et les motifs de bits du payload des NaN et du zéro signé sont conservés.
- Le CRS, le sens et l'ordre des axes et l'unité relèvent du contexte externe. Il n'y a pas de remplissage ABI.

## Validité

- Le Payload fait exactement 12 WORD, et chaque intervalle de 4 WORD est un binary64 en bits d'interchange.

## Fondement normatif et statut du format

- L'ordre des coordonnées `x, y, z` du point se réfère à l'axis order de Point/WKB du [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) de l'OGC, et chaque composante suit [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Ce Payload est un compact profile de GEUL qui ne contient ni en-tête type/byte-order de WKB ni en-tête GeoPackage, et n'est pas le wire format WKB de l'OGC. Le CRS, le sens des axes et l'unité relèvent du contexte externe.

## Longueur

- Le total est exactement de 16 WORD, soit le TAG de 1 WORD, le TAG d'extension de Length de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 12 WORD, avec `LLLL=1110`. Il n'y a ni descriptor ni remplissage.
- Si le Payload n'est pas exactement de 12 WORD, on rejette.

## Exemple

- Si les trois binary64 du Payload sont `1.0, 2.0, 3.0`, c'est le point `(1.0, 2.0, 3.0)`.
