---
title: "COMPLEX128"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 es un Value que representa un número complejo mediante dos componentes IEEE 754 binary64 en el orden (real, imag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 es un Value que representa un número complejo mediante dos componentes IEEE 754 binary64 en el orden `(real, imag)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x00000701`, familia NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Número de Codec   2 WORD  0x00000701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## Interpretación y validez {#해석과-유효성}

- Cada componente son los interchange bits de un binary64 en orden de WORD big-endian.
- Se conserva tal cual el bit pattern, incluidos el NaN payload y el cero con signo, y no hay ABI padding.
- El Payload es exactamente de 8 WORD. Se conservan todos los interchange bit pattern de los dos componentes binary64.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- Que `complex128` consta de un componente real de 64bit y un componente imaginario de 64bit sigue [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), y el orden real primero coincide con el complex raw-data mapping del [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial. El bit pattern de cada componente sigue [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- El raw data de ONNX es fixed-width little-endian, pero este formato usa el framing en WORD big-endian de GEUL, por lo que no es la wire serialization de ONNX TensorProto en sí.

## Longitud {#길이}

- El total es exactamente 13 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 8 WORD, con longitud directa `LLLL=1100`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Ejemplo {#예시}

- Si los dos binary64 del Payload son `1.0, -0.0`, el valor tiene parte real 1.0 y parte imaginaria -0.0.
