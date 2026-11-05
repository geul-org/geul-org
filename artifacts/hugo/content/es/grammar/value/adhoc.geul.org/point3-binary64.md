---
title: "POINT3-BINARY64"
weight: 1018
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 es un punto tridimensional formado por tres componentes IEEE 754 binary64 en el orden (x, y, z)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 es un punto tridimensional formado por tres componentes IEEE 754 binary64 en el orden `(x, y, z)`.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x0000050B`. Familia NUMERIC.

```
TAG WORD                  0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG extendida de Length   1 WORD  0x0012 (total 18 WORD)
Issuer                    2 WORD  0x00000002 (ADHOC)
Número de Codec           2 WORD  0x0000050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Reglas de interpretación {#해석-규칙}

- Cada componente se lee empezando por el WORD más significativo y se conservan el NaN payload y el bit pattern del cero con signo.
- El CRS, el significado y el orden de los ejes y la unidad son contexto externo. No hay ABI padding.

## Validez {#유효성}

- El Payload es exactamente de 12 WORD, y cada tramo de 4 WORD son interchange bits de un binary64.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- El orden de coordenadas `x, y, z` del punto toma como referencia el axis order de Point/WKB de OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), y cada componente sigue [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Este Payload es un compact profile de GEUL que no incluye el header de type/byte-order de WKB ni el header de GeoPackage, y no es el wire format WKB de OGC. El CRS, el significado de los ejes y la unidad son contexto externo.

## Longitud {#길이}

- El total es exactamente 18 WORD: TAG 1 WORD, TAG extendida de Length 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 12 WORD, con `LLLL=1110`. No hay descriptor ni padding.
- Si el Payload no es exactamente de 12 WORD, se rechaza.

## Ejemplo {#예시}

- Si los tres binary64 del Payload son `1.0, 2.0, 3.0`, es el punto `(1.0, 2.0, 3.0)`.
