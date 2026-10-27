---
title: "POINT3-BINARY64"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 es un Value de punto 3D formado por tres componentes IEEE 754 binary64 en el orden (x, y, z) (formato de Issuer ADHOC 0x050B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 es un punto 3D formado por tres componentes IEEE 754 binary64 en el orden `(x, y, z)`.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x050B`. Familia NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG de extensión de Length   1 WORD  0x0010 (16 WORD en total)
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Reglas de interpretación

- Cada componente se lee empezando por el WORD alto, y se conserva el bit pattern del payload de NaN y del signed zero.
- El CRS, el significado y el orden de los ejes y la unidad son contexto externo. No hay ABI padding.

## Validez

- El Payload tiene exactamente 12 WORD, y cada tramo de 4 WORD son bits de intercambio binary64.

## Fundamento en estándares y estatus del formato

- El orden de coordenadas `x, y, z` del punto toma como referencia el axis order de Point/WKB del [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) de OGC, y cada componente sigue [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Este Payload es un compact profile de GEUL que no incluye el header de type/byte-order de WKB ni el header de GeoPackage, y no es el wire format WKB de OGC. El CRS, el significado de los ejes y la unidad son contexto externo.

## Longitud

- El total es exactamente 16 WORD: 1 WORD de TAG, 1 WORD de TAG de extensión de Length, 1 WORD de Issuer, 1 WORD de número de formato y 12 WORD de Payload, y usa `LLLL=1110`. No hay descriptor ni relleno.
- Se rechaza si el Payload no tiene exactamente 12 WORD.

## Ejemplo

- Si los tres binary64 del Payload son `1.0, 2.0, 3.0`, el punto es `(1.0, 2.0, 3.0)`.
