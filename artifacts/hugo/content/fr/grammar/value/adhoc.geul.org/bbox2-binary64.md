---
title: "BBOX2-BINARY64"
weight: 1000
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 est une boîte englobante bidimensionnelle formée de quatre composantes IEEE 754 binary64, dans l'ordre (minX, minY, maxX, maxY)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 est une boîte englobante bidimensionnelle formée de quatre composantes IEEE 754 binary64, dans l'ordre `(minX, minY, maxX, maxY)`.

## Disposition {#레이아웃}

- Code : Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x0000050C`. Famille NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG d'extension de Length   1 WORD  0x0016 (22 WORD au total)
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x0000050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Règles d'interprétation {#해석-규칙}

- Chaque composante est un binary64, lu à partir du WORD de poids fort. Le bit pattern du signed zero est conservé.
- Le CRS, le sens et l'ordre des axes ainsi que l'unité relèvent du contexte externe. Il n'y a pas de padding ABI.

## Validité {#유효성}

- Le Payload doit faire exactement 16 WORD, avec `minX ≤ maxX` et `minY ≤ maxY`.
- NaN n'étant pas comparable, sa présence dans une composante quelconque entraîne le rejet.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- Le sens des coordonnées minimale et maximale s'inspire du bounding envelope de l'OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), et chaque composante suit [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- L'ordre du tableau 2D de l'envelope GeoPackage est `[minx, maxx, miny, maxy]`. L'ordre `(minX, minY, maxX, maxY)` de ce format n'est pas cet ordre wire : c'est un tuple compact défini par GEUL, et il ne contient pas non plus d'en-tête WKB/GeoPackage. Le CRS, le sens des axes et l'unité relèvent du contexte externe.

## Length {#길이}

- Le total est de 22 WORD exactement : TAG 1 WORD, TAG d'extension de Length 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 16 WORD ; on utilise `LLLL=1110`. Il n'y a ni descriptor ni padding.
- Si le Payload ne fait pas exactement 16 WORD, on rejette.

## Exemple {#예시}

- Si les composantes sont `(0.0, 1.0, 2.0, 3.0)`, la valeur est valide ; avec `(2.0, 1.0, 0.0, 3.0)`, elle est invalid.
