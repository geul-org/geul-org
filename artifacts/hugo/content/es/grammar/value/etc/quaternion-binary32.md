---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 es un formato Issuer ADHOC de 11 WORD fijos que contiene un quaternion con cuatro componentes binary32 en el orden (x, y, z, w)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
QUATERNION-BINARY32 es un Value que representa un quaternion con cuatro componentes IEEE 754 binary32 en el orden `(x, y, z, w)`. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0704`, familia NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD en total
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interpretación y validez

- Cada componente son los interchange bits de un binary32 en orden de WORD big-endian.
- El frame, la handedness, la unit norm y la equivalencia `q/-q` son contexto externo y no forman parte del significado de este formato.
- Se conservan los patrones de bits del NaN payload y del signed zero, y no hay ABI padding.
- El Payload es exactamente de 8 WORD. Este formato no impone la unit norm ni la normalización `q/-q`.

## Base estándar y estatus del formato

- El orden `x, y, z, w` es el mismo que el orden de los componentes del quaternion de [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) de Khronos, y cada componente es un [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- La rotation de un node de glTF exige un unit quaternion con W como escalar. Este formato es un quaternion general que no impone la unit norm ni el sentido de rotation, así que no puede considerarse igual que la rotation de glTF salvo que un profile externo añada esa condición.

## Longitud

- El total es exactamente 11 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 8 WORD, y se usa la longitud directa `LLLL=1010`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Ejemplo

- Los componentes `(0.0, 0.0, 0.0, 1.0)` son un valor válido que almacena los cuatro patrones de bits en orden.
