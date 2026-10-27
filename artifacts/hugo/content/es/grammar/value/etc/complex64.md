---
title: "COMPLEX64"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 es un formato Issuer ADHOC de 7 WORD fijos que contiene un número complejo con dos componentes binary32, parte real e imaginaria."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
COMPLEX64 es un Value que representa un número complejo con dos componentes IEEE 754 binary32 en el orden `(real, imag)`. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0700`, familia NUMERIC.

## Layout

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD en total
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Interpretación y validez

- Cada componente son los interchange bits de un binary32 en orden de WORD big-endian.
- Se conservan tal cual los patrones de bits, incluidos el NaN payload y el signed zero, y no hay ABI padding.
- El Payload es exactamente de 4 WORD. Se conservan todos los patrones de bits de interchange de los dos componentes binary32.

## Base estándar y estatus del formato

- Que `complex64` conste de un componente real de 32 bits y un componente imaginario de 32 bits sigue [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), y el orden real primero es el mismo que el complex raw-data mapping del [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial. El patrón de bits de cada componente sigue [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Los raw data de ONNX son little-endian de ancho fijo, pero este formato usa el framing en WORD big-endian de GEUL, por lo que no es la propia serialización wire de ONNX TensorProto.

## Longitud

- El total es exactamente 7 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 4 WORD, y se usa la longitud directa `LLLL=0110`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 4 WORD, se rechaza.

## Ejemplo

- El Payload `3f80 0000 4000 0000` es `1.0 + 2.0i`.
