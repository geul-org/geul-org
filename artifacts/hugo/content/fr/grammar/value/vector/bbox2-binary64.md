---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 est une Value de boîte englobante 2D à quatre composantes IEEE 754 binary64 dans l'ordre (minX, minY, maxX, maxY) (format d'Issuer ADHOC 0x050C)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 est une boîte englobante 2D à quatre composantes IEEE 754 binary64 dans l'ordre `(minX, minY, maxX, maxY)`.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x050C`. Famille NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG d'extension de Length   1 WORD  0x0014 (20 WORD au total)
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Règles d'interprétation

- Chaque composante est un binary64 lu à partir du WORD de poids fort. Le motif de bits du zéro signé est conservé.
- Le CRS, le sens et l'ordre des axes et l'unité relèvent du contexte externe. Il n'y a pas de remplissage ABI.

## Validité

- Le Payload doit faire exactement 16 WORD et l'on doit avoir `minX ≤ maxX` et `minY ≤ maxY`.
- Un NaN n'étant pas comparable, on rejette s'il y en a dans n'importe quelle composante.

## Fondement normatif et statut du format

- Le sens des coordonnées minimale et maximale se réfère à la bounding envelope du [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) de l'OGC, et chaque composante suit [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- L'ordre du tableau 2D de l'envelope GeoPackage est `[minx, maxx, miny, maxy]`. L'ordre `(minX, minY, maxX, maxY)` de ce format n'est pas cet ordre wire mais un compact tuple fixé par GEUL, et il ne contient pas non plus d'en-tête WKB/GeoPackage. Le CRS, le sens des axes et l'unité relèvent du contexte externe.

## Longueur

- Le total est exactement de 20 WORD, soit le TAG de 1 WORD, le TAG d'extension de Length de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 16 WORD, avec `LLLL=1110`. Il n'y a ni descriptor ni remplissage.
- Si le Payload n'est pas exactement de 16 WORD, on rejette.

## Exemple

- Si les composantes sont `(0.0, 1.0, 2.0, 3.0)`, c'est valide, et si elles sont `(2.0, 1.0, 0.0, 3.0)`, c'est invalid.
