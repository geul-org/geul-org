---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR es un formato de Issuer ADHOC que contiene, tras un descriptor de packed format, rank y shape, elementos menores que un WORD rellenados en low-bit-first."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR es un Value de tensor que escribe el shape y el packed format en el descriptor del Payload y almacena de forma packed elementos menores que un WORD. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0601`, de la familia NUMERIC.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload siguiente [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload restante  [packed payload octet stream, low-bit-first]
```

## Interpretación

- El rank es un valor de 4 bits del descriptor, por lo que estructuralmente solo puede representar `0..15`. Cada dimension es un uint32 big-endian no negativo. El orden lógico es C-contiguous row-major.
- Como en las reglas de tensor lógico de ONNX, el shape de rank 0, `[]`, es un scalar de un elemento, y si alguna dimension es 0, el número de elementos es 0. En los demás casos el número de elementos es el producto de todas las dimension.
- El packed-format fija el encoding del elemento y su bit width, como int2/int4, FP4/FP6 o ciertas variantes de FP8.
- Sea `p[0], p[1], ...` la secuencia de octets del payload y `P = Σ(p[j] << (8j))` el entero little-bit-endian; el elemento lógico `i` de ancho `w` es `(P >> (i × w)) & ((1 << w) - 1)`. Es decir, se coloca desde el primer elemento en los bits más bajos.
- En los WORD, `p[0]` va en el octet alto del primer WORD, `p[1]` en el octet bajo, y así sucesivamente. Los bits altos de cola sin usar del último octet utilizado deben ser 0, y si el número de octets del payload es impar, todo el octet bajo sin usar del último WORD debe ser `00`.

## Validez

- Aplicando el bit width del formato admitido, el producto de las dimension del shape calculado sin overflow debe coincidir con el número de elementos del payload.
- Se rechaza si algún bit de cola alto o algún octet de relleno posterior a los bits de payload necesarios es 1. El descriptor, el shape y el payload deben caber por completo dentro del Length del registro.

## Fundamento en estándares y estatus del formato

- El significado lógico del shape, del scalar de rank 0 y de la dimension cero sigue el [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). La regla de colocar los elementos sub-byte empezando por los bits bajos sigue el packing int2/int4 del [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial y el packing little bit-endian de [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- El rank de 4 bits, las dimension uint32, los campos version/packed-format, la forma de agrupar los octets en WORD big-endian y el TAG/Length de GEUL son un descriptor propio de GEUL. No es la wire o memory serialization de ONNX, de [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) ni de DLPack.

## Longitud

- El total es la suma de 1 WORD de TAG, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Registros y TAG WORD](/es/grammar/record/)).
- El descriptor es 1 WORD, el shape son `2 × rank` WORD y el resto es el packed payload.
- Si el número lógico de elementos es `N` y el ancho del elemento es `w`, el número de octets del payload es `ceil(N × w / 8)` y el número de WORD del payload es `ceil(número de octets del payload / 2)`.

## Ejemplo

- En un profile de rank 2, los 4 WORD que siguen al descriptor son el shape y lo que viene después es la secuencia de octets del payload low-bit-first. El ancho del elemento y si realmente se admite se determinan con un format profile ya fijado.
- La secuencia de octets del payload de los elementos de 4 bits `[1, 2, 3]` es `21 03`, y el WORD del payload es `2103`. El primer elemento está en el nibble bajo del primer octet, y el nibble alto sin usar del último octet es 0.

## Problemas abiertos

- Aún no se han decidido los valores del registry de version y packed-format, ni el rango de profiles que se admitirá dentro de los rank `0..15` representables.
