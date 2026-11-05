---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR es un Value de tensor que anota el shape y el element format en un descriptor del Payload y almacena un payload C-contiguous row-major."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR es un Value de tensor que anota el shape y el element format en un descriptor del Payload y almacena un payload C-contiguous row-major. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x00000600`, familia NUMERIC.

## Layout {#레이아웃}

```
TAG WORD                  0000 1001 1101 LLLL      Codec 0x09DL
[TAG extendida de Length] si el total es de 15 WORD o más
Issuer                    2 WORD  0x00000002 (ADHOC)
Número de Codec           2 WORD  0x00000600
Payload WORD 1st          [version: 4bit][element-format: 8bit][rank: 4bit]
Payload siguiente         [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload resto             [dense payload]
```

## Interpretación {#해석}

- El rank es un valor de 4bit del descriptor, por lo que estructuralmente solo se puede representar `0..15`. Cada dimension es un uint32 big-endian no negativo.
- Como en las reglas de tensor lógico de ONNX, el shape de rank 0 `[]` es un scalar de un elemento, y si alguna dimension es 0, el número de elementos es 0. En los demás casos, el número de elementos es el producto de todas las dimension.
- El payload se lee con el element format del descriptor y en orden C-contiguous row-major. El número lógico de elementos calculado debe coincidir con el número de elementos del payload que sigue al descriptor.

## Validez {#유효성}

- Una vez fijados la version y el element format admitidos, se recuperan los límites del payload con ese ancho de elemento y se verifica que coincidan con el producto del shape calculado sin overflow.
- El descriptor, todas las dimension y el payload deben caber por completo dentro del Length del registro, y no hay ABI padding arbitrario.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- La regla de que el shape es una lista de dimension no negativas y de que el número de valores es igual al producto de las dimension, y el significado del scalar de rank 0 y de la zero dimension, siguen la [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). El orden lógico C-contiguous row-major se ajusta al orden de la [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- El rank de 4bit, las dimension uint32, los campos version/element-format, el TAG/Length de GEUL y el payload en WORD big-endian son un descriptor propio de GEUL. No son la wire·memory serialization del [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), de ONNX TensorProto ni de la [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Longitud {#길이}

- El total es el número de WORD que suman TAG 1 WORD, TAG extendida de Length (si existe), Issuer 2 WORD, número de Codec 2 WORD y Payload. Hasta 14 WORD se usa longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y la TAG extendida también entra en el total ([Registro y TAG WORD](../../record.md)).
- El descriptor es de 1 WORD, el shape es de `2 × rank` WORD y el resto es el payload.

## Ejemplo {#예시}

- En un profile de rank 2, los 4 WORD que siguen al descriptor son las dos dimension uint32, y todo lo que viene después es el payload row-major. Para saber si realmente se admite y para validar el número de elementos hace falta un profile de version y format ya fijado.

## Problemas abiertos {#열린-문제}

- Aún no se han fijado los valores de los registry de version y element-format, ni el rango de profile que se admitirá entre los rank representables `0..15`.
