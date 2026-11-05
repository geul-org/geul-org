---
title: "BGRA8-UNORM"
weight: 1037
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM es un Value que almacena de forma packed cuatro componentes UNORM8 (B, G, R, A) en un Payload fijo de 2 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM es un Value que almacena de forma packed cuatro componentes UNORM8 (B, G, R, A) en un Payload fijo de 2 WORD.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000E` KHRONOS, número de Codec `0x00000001`. Familia NUMERIC.

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  total 7 WORD
Issuer            2 WORD  0x0000000E (KHRONOS)
Número de Codec   2 WORD  0x00000001
Payload WORD 1st: [B: 8bit superiores][G: 8bit inferiores]
Payload WORD 2nd: [R: 8bit superiores][A: 8bit inferiores]
```

## Reglas de interpretación {#해석-규칙}

- El orden de byte serializado es `B, G, R, A`, y el valor de cada byte de componente `b` es `b / 255`.
- Corresponde al orden de componentes de los byte 0~3 y al mapeo numérico UNORM de `VK_FORMAT_B8G8R8A8_UNORM` de Vulkan.
- Como no es un formato `_SRGB`, no implica sRGB ni otro espacio de color o transfer function. Alpha también es un valor numérico UNORM, pero si es straight o premultiplied y su significado de compositing son contexto externo. No hay ABI padding.

## Validez {#유효성}

- Todos los patterns de 8 bit son válidos. El Payload debe ser exactamente de 2 WORD.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- El component memory order y el significado de UNORM se ajustan a `VK_FORMAT_B8G8R8A8_UNORM` de la [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) y del [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) de Khronos.
- El TAG/Length de GEUL y el framing en dos WORD big-endian de 16 bit son reglas propias de GEUL, y no definen la serialization de la propia imagen de Vulkan.

## Longitud {#길이}

- El total es exactamente 7 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 2 WORD, con longitud directa `LLLL=0110`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 2 WORD, se rechaza.

## Ejemplo {#예시}

- El Payload `0000 FF80` son los bytes `B=00, G=00, R=FF, A=80`.
