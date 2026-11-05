---
title: "BBOX2-BINARY64"
weight: 1000
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 es una caja delimitadora bidimensional formada por cuatro componentes IEEE 754 binary64 en el orden (minX, minY, maxX, maxY)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 es una caja delimitadora bidimensional formada por cuatro componentes IEEE 754 binary64 en el orden `(minX, minY, maxX, maxY)`.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x0000050C`. Familia NUMERIC.

```
TAG WORD                  0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG extendida de Length   1 WORD  0x0016 (total 22 WORD)
Issuer                    2 WORD  0x00000002 (ADHOC)
Número de Codec           2 WORD  0x0000050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Reglas de interpretación {#해석-규칙}

- Cada componente es binary64 y se lee empezando por el WORD más significativo. Se conserva el bit pattern del cero con signo.
- El CRS, el significado y el orden de los ejes y la unidad son contexto externo. No hay ABI padding.

## Validez {#유효성}

- El Payload debe ser exactamente de 16 WORD, y debe cumplirse `minX ≤ maxX` y `minY ≤ maxY`.
- NaN no es comparable, así que se rechaza si aparece en cualquier componente.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- El significado de las coordenadas mínima y máxima toma como referencia el bounding envelope de OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), y cada componente sigue [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- El orden del arreglo 2D del envelope de GeoPackage es `[minx, maxx, miny, maxy]`. El orden `(minX, minY, maxX, maxY)` de este formato no es ese wire order, sino una tupla compacta definida por GEUL, y tampoco incluye el header de WKB/GeoPackage. El CRS, el significado de los ejes y la unidad son contexto externo.

## Longitud {#길이}

- El total es exactamente 22 WORD: TAG 1 WORD, TAG extendida de Length 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 16 WORD, con `LLLL=1110`. No hay descriptor ni padding.
- Si el Payload no es exactamente de 16 WORD, se rechaza.

## Ejemplo {#예시}

- Si los componentes son `(0.0, 1.0, 2.0, 3.0)`, es válido; si son `(2.0, 1.0, 0.0, 3.0)`, es invalid.
