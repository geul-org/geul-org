---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 es un Value que representa un quaternion mediante cuatro componentes IEEE 754 binary32 en el orden (x, y, z, w)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 es un Value que representa un quaternion mediante cuatro componentes IEEE 754 binary32 en el orden `(x, y, z, w)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x00000704`, familia NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Número de Codec   2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interpretación y validez {#해석과-유효성}

- Cada componente son los interchange bits de un binary32 en orden de WORD big-endian.
- El frame, la handedness, la unit norm y la equivalencia `q/-q` son contexto externo y no forman parte del significado de este formato.
- Se conservan el NaN payload y el bit pattern del cero con signo, y no hay ABI padding.
- El Payload es exactamente de 8 WORD. Este formato no impone la unit norm ni la normalización `q/-q`.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- El orden `x, y, z, w` coincide con el orden de componentes del quaternion de la [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) de Khronos, y cada componente es [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- La rotation de un node de glTF exige un unit quaternion con W como escalar. Este formato es un quaternion general que no impone la unit norm ni el significado de rotación, por lo que no puede considerarse igual a la rotation de glTF salvo que un profile externo añada esa condición.

## Longitud {#길이}

- El total es exactamente 13 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 8 WORD, con longitud directa `LLLL=1100`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Ejemplo {#예시}

- Los componentes `(0.0, 0.0, 0.0, 1.0)` son un valor válido que almacena los cuatro bit pattern en orden.
