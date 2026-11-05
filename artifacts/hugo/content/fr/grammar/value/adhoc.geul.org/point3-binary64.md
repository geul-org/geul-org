---
title: "POINT3-BINARY64"
weight: 1018
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 est un point tridimensionnel formé de trois composantes IEEE 754 binary64, dans l'ordre (x, y, z)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


POINT3-BINARY64 est un point tridimensionnel formé de trois composantes IEEE 754 binary64, dans l'ordre `(x, y, z)`.

## Disposition {#레이아웃}

- Code : Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x0000050B`. Famille NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG d'extension de Length   1 WORD  0x0012 (18 WORD au total)
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x0000050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Règles d'interprétation {#해석-규칙}

- Chaque composante est lue à partir du WORD de poids fort, et le NaN payload ainsi que le bit pattern du signed zero sont conservés.
- Le CRS, le sens et l'ordre des axes ainsi que l'unité relèvent du contexte externe. Il n'y a pas de padding ABI.

## Validité {#유효성}

- Le Payload fait exactement 12 WORD, et chaque segment de 4 WORD est constitué des interchange bits binary64.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- L'ordre des coordonnées `x, y, z` du point s'inspire de l'axis order Point/WKB de l'OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), et chaque composante suit [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Ce Payload est un profil compact de GEUL qui ne contient ni en-tête de type/byte-order WKB ni en-tête GeoPackage ; ce n'est pas le wire format WKB de l'OGC. Le CRS, le sens des axes et l'unité relèvent du contexte externe.

## Length {#길이}

- Le total est de 18 WORD exactement : TAG 1 WORD, TAG d'extension de Length 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 12 WORD ; on utilise `LLLL=1110`. Il n'y a ni descriptor ni padding.
- Si le Payload ne fait pas exactement 12 WORD, on rejette.

## Exemple {#예시}

- Si les trois binary64 du Payload sont `1.0, 2.0, 3.0`, le point est `(1.0, 2.0, 3.0)`.
