---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 es un Value de cuadro delimitador 2D formado por cuatro componentes IEEE 754 binary64 en el orden (minX, minY, maxX, maxY) (formato de Issuer ADHOC 0x050C)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 es un cuadro delimitador 2D formado por cuatro componentes IEEE 754 binary64 en el orden `(minX, minY, maxX, maxY)`.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x050C`. Familia NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG de extensión de Length   1 WORD  0x0014 (20 WORD en total)
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Reglas de interpretación

- Cada componente es un binary64 y se lee empezando por el WORD alto. Se conserva el bit pattern del signed zero.
- El CRS, el significado y el orden de los ejes y la unidad son contexto externo. No hay ABI padding.

## Validez

- El Payload debe tener exactamente 16 WORD, y debe cumplirse `minX ≤ maxX` y `minY ≤ maxY`.
- NaN no es comparable, por lo que se rechaza si aparece en cualquier componente.

## Fundamento en estándares y estatus del formato

- El significado de las coordenadas mínima y máxima toma como referencia el bounding envelope del [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) de OGC, y cada componente sigue [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- El orden del arreglo 2D del envelope de GeoPackage es `[minx, maxx, miny, maxy]`. El orden `(minX, minY, maxX, maxY)` de este formato no es ese wire order, sino una compact tuple definida por GEUL, y tampoco incluye el header de WKB/GeoPackage. El CRS, el significado de los ejes y la unidad son contexto externo.

## Longitud

- El total es exactamente 20 WORD: 1 WORD de TAG, 1 WORD de TAG de extensión de Length, 1 WORD de Issuer, 1 WORD de número de formato y 16 WORD de Payload, y usa `LLLL=1110`. No hay descriptor ni relleno.
- Se rechaza si el Payload no tiene exactamente 16 WORD.

## Ejemplo

- Si los componentes son `(0.0, 1.0, 2.0, 3.0)` es válido, y si son `(2.0, 1.0, 0.0, 3.0)` es invalid.
