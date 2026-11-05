---
title: "POINT2-BINARY64"
weight: 1017
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 est un point bidimensionnel formé de deux composantes IEEE 754 binary64, dans l'ordre (x, y)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


POINT2-BINARY64 est un point bidimensionnel formé de deux composantes IEEE 754 binary64, dans l'ordre `(x, y)`.

## Disposition {#레이아웃}

- Code : Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x0000050A`. Famille NUMERIC.

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD au total
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x0000050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## Règles d'interprétation {#해석-규칙}

- Chaque composante est lue à partir du WORD de poids fort, et le NaN payload ainsi que le bit pattern du signed zero sont conservés.
- Le CRS, le sens et l'ordre des axes ainsi que l'unité relèvent du contexte externe. Il n'y a pas de padding ABI.

## Validité {#유효성}

- Le Payload fait exactement 8 WORD, et chaque segment de 4 WORD est constitué des interchange bits binary64.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- L'ordre des coordonnées `x, y` du point s'inspire de l'axis order Point/WKB de l'OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), et chaque composante suit [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Ce Payload est un profil compact de GEUL qui ne contient ni en-tête de type/byte-order WKB ni en-tête GeoPackage ; ce n'est pas le wire format WKB de l'OGC. Le CRS, le sens des axes et l'unité relèvent du contexte externe.

## Length {#길이}

- Le total est de 13 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 8 WORD ; on utilise la longueur directe `LLLL=1100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 8 WORD, on rejette.

## Exemple {#예시}

- Le Payload `3FF0 0000 0000 0000 4000 0000 0000 0000` est `(1.0, 2.0)`.
