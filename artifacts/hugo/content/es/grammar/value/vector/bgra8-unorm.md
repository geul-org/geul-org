---
title: "BGRA8-UNORM"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM es un Value de píxel que contiene en 2 WORD de Payload cuatro componentes UNORM8 en el orden B, G, R, A (formato de Issuer KHRONOS 0x0001)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM es un Value que almacena de forma packed cuatro componentes UNORM8, B, G, R y A, en un Payload fijo de 2 WORD.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0041` KHRONOS, número de formato `0x0001`. Familia NUMERIC.

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD en total
Issuer            1 WORD  0x0041 (KHRONOS)
Número de formato 1 WORD  0x0001
Payload WORD 1st: [B: 8 bits altos][G: 8 bits bajos]
Payload WORD 2nd: [R: 8 bits altos][A: 8 bits bajos]
```

## Reglas de interpretación

- El orden de bytes serializado es `B, G, R, A`, y el valor de cada byte de componente `b` es `b / 255`.
- Esto corresponde al orden de componentes de los bytes 0 a 3 y al mapping numérico UNORM de `VK_FORMAT_B8G8R8A8_UNORM` de Vulkan.
- No es un formato `_SRGB`, por lo que no implica sRGB ni otro espacio de color ni transfer function. El alpha también es un valor numérico UNORM, pero si es straight o premultiplied y su significado de compositing son contexto externo. No hay ABI padding.

## Validez

- Todos los patrones de 8 bits son válidos. El Payload debe tener exactamente 2 WORD.

## Fundamento en estándares y estatus del formato

- El component memory order y el significado de UNORM se ajustan a `VK_FORMAT_B8G8R8A8_UNORM` de la [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) y del [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) de Khronos.
- El TAG/Length de GEUL y el framing de dos WORD big-endian de 16 bits son reglas propias de GEUL, y no definen la serialization de la propia imagen de Vulkan.

## Longitud

- El total es exactamente 5 WORD: 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato y 2 WORD de Payload, y usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni relleno.
- Se rechaza si el Payload no tiene exactamente 2 WORD.

## Ejemplo

- Payload `0000 ff80` son los bytes `B=00, G=00, R=ff, A=80`.
