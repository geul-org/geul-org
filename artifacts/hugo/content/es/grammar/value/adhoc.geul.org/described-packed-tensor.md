---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR es un Value de tensor que anota el shape y el packed format en un descriptor del Payload y almacena en forma packed elementos más pequeños que un WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR es un Value de tensor que anota el shape y el packed format en un descriptor del Payload y almacena en forma packed elementos más pequeños que un WORD. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x00000601`, familia NUMERIC.

## Layout {#레이아웃}

```
TAG WORD                  0000 1001 1101 LLLL      Codec 0x09DL
[TAG extendida de Length] si el total es de 15 WORD o más
Issuer                    2 WORD  0x00000002 (ADHOC)
Número de Codec           2 WORD  0x00000601
Payload WORD 1st          [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload siguiente         [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload resto             [packed payload octet stream, low-bit-first]
```

## Interpretación {#해석}

- El rank es un valor de 4bit del descriptor, por lo que estructuralmente solo se puede representar `0..15`. Cada dimension es un uint32 big-endian no negativo. El orden lógico es C-contiguous row-major.
- Como en las reglas de tensor lógico de ONNX, el shape de rank 0 `[]` es un scalar de un elemento, y si alguna dimension es 0, el número de elementos es 0. En los demás casos, el número de elementos es el producto de todas las dimension.
- El packed-format fija el encoding del elemento y el ancho en bit, como int2/int4, FP4/FP6 o ciertas variantes de FP8.
- Si la secuencia de octet del payload es `p[0], p[1], ...` y se considera el entero little-bit-endian `P = Σ(p[j] << (8j))`, el elemento lógico `i` de ancho `w` es `(P >> (i × w)) & ((1 << w) - 1)`. Es decir, se coloca desde el primer elemento empezando por el bit más bajo.
- En los WORD, `p[0]` va en el octet superior del primer WORD y `p[1]` en el octet inferior, y así sucesivamente. Los tail bit superiores no usados del último octet usado deben ser 0, y si el número de octet del payload es impar, todo el octet inferior no usado del último WORD debe ser `00`.

## Validez {#유효성}

- Aplicando el ancho en bit del format admitido, el producto de las dimension del shape calculado sin overflow debe coincidir con el número de elementos del payload.
- Se rechaza si algún high tail bit u octet padding posterior a los bit de payload necesarios es 1. El descriptor, el shape y el payload deben caber por completo dentro del Length del registro.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- El significado lógico del shape, del scalar de rank 0 y de la zero dimension sigue la [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). La regla de colocar los elementos sub-byte empezando por el bit más bajo sigue el packing int2/int4 del [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial y el little bit-endian packing de [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- El rank de 4bit, las dimension uint32, los campos version/packed-format, la forma de agrupar los octet en WORD big-endian y el TAG/Length de GEUL son un descriptor propio de GEUL. No son la wire·memory serialization de ONNX, del [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) ni de DLPack.

## Longitud {#길이}

- El total es el número de WORD que suman TAG 1 WORD, TAG extendida de Length (si existe), Issuer 2 WORD, número de Codec 2 WORD y Payload. Hasta 14 WORD se usa longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y la TAG extendida también entra en el total ([Registro y TAG WORD](../../record.md)).
- El descriptor es de 1 WORD, el shape es de `2 × rank` WORD y el resto es el packed payload.
- Si el número de elementos lógicos es `N` y el ancho del elemento es `w`, el número de octet del payload es `ceil(N × w / 8)` y el número de WORD del payload es `ceil(número de octet del payload / 2)`.

## Ejemplo {#예시}

- En un profile de rank 2, los 4 WORD que siguen al descriptor son el shape, y lo que viene después es la secuencia de octet del payload low-bit-first. El ancho del elemento y si realmente se admite se juzgan con el format profile ya fijado.
- La secuencia de octet del payload de los elementos de 4bit `[1, 2, 3]` es `21 03` y el WORD del payload es `2103`. El primer elemento está en el nibble bajo del primer octet, y el nibble alto no usado del último octet es 0.

## Problemas abiertos {#열린-문제}

- Aún no se han fijado los valores de los registry de version y packed-format, ni el rango de profile que se admitirá entre los rank representables `0..15`.
