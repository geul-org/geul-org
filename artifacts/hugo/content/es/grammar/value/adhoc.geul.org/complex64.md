---
title: "COMPLEX64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 es un Value que representa un número complejo mediante dos componentes IEEE 754 binary32 en el orden (real, imag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 es un Value que representa un número complejo mediante dos componentes IEEE 754 binary32 en el orden `(real, imag)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x00000700`, familia NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total 9 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Número de Codec   2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Interpretación y validez {#해석과-유효성}

- Cada componente son los interchange bits de un binary32 en orden de WORD big-endian.
- Se conserva tal cual el bit pattern, incluidos el NaN payload y el cero con signo, y no hay ABI padding.
- El Payload es exactamente de 4 WORD. Se conservan todos los interchange bit pattern de los dos componentes binary32.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- Que `complex64` consta de un componente real de 32bit y un componente imaginario de 32bit sigue [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), y el orden real primero coincide con el complex raw-data mapping del [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial. El bit pattern de cada componente sigue [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- El raw data de ONNX es fixed-width little-endian, pero este formato usa el framing en WORD big-endian de GEUL, por lo que no es la wire serialization de ONNX TensorProto en sí.

## Longitud {#길이}

- El total es exactamente 9 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 4 WORD, con longitud directa `LLLL=1000`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 4 WORD, se rechaza.

## Ejemplo {#예시}

- El Payload `3F80 0000 4000 0000` es `1.0 + 2.0i`.
