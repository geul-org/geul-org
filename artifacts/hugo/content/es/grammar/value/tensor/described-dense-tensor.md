---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR es un formato de Issuer ADHOC que contiene, tras un descriptor de element format, rank y shape, los elementos C-contiguous en row-major."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR es un Value de tensor que escribe el shape y el element format en el descriptor del Payload y almacena un payload C-contiguous en row-major. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0600`, de la familia NUMERIC.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload siguiente [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload restante  [dense payload]
```

## Interpretación

- El rank es un valor de 4 bits del descriptor, por lo que estructuralmente solo puede representar `0..15`. Cada dimension es un uint32 big-endian no negativo.
- Como en las reglas de tensor lógico de ONNX, el shape de rank 0, `[]`, es un scalar de un elemento, y si alguna dimension es 0, el número de elementos es 0. En los demás casos el número de elementos es el producto de todas las dimension.
- El payload se lee con el element format del descriptor, en orden C-contiguous row-major. El número lógico de elementos calculado debe coincidir con el número de elementos del payload que sigue al descriptor.

## Validez

- Una vez fijados la version y el element format admitidos, se recupera el límite del payload con el ancho de ese elemento y se verifica que coincida con el producto del shape calculado sin overflow.
- El descriptor, todas las dimension y el payload deben caber por completo dentro del Length del registro, y no hay ABI padding arbitrario.

## Fundamento en estándares y estatus del formato

- La regla de que el shape es una lista de dimension no negativas y de que el número de valores es igual al producto de las dimension, así como el significado del scalar de rank 0 y de la dimension cero, siguen el [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). El orden lógico C-contiguous row-major se ajusta al orden de la [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- El rank de 4 bits, las dimension uint32, los campos version/element-format, el TAG/Length de GEUL y el payload en WORD big-endian son un descriptor propio de GEUL. No es la wire o memory serialization del [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), de ONNX TensorProto ni de la [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Longitud

- El total es la suma de 1 WORD de TAG, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Registros y TAG WORD](/es/grammar/record/)).
- El descriptor es 1 WORD, el shape son `2 × rank` WORD y el resto es el payload.

## Ejemplo

- En un profile de rank 2, los 4 WORD que siguen al descriptor son las dos dimension uint32, y todo lo que viene después es el payload row-major. Para saber si realmente se admite y para validar el número de elementos hace falta un profile de version y formato ya fijado.

## Problemas abiertos

- Aún no se han decidido los valores del registry de version y element-format, ni el rango de profiles que se admitirá dentro de los rank `0..15` representables.
