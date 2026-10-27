---
title: "DENSE-I64-VECTOR"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I64-VECTOR es un Value de vector unidimensional que contiene elementos int64 big-endian consecutivos, sin descriptor (formato de Issuer ADHOC 0x0504)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I64-VECTOR es un Value unidimensional homogéneo que almacena elementos int64 big-endian consecutivos, sin descriptor.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0504`. Familia NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0504
Payload: [int64 1st: 4 WORD] ... [int64 Nth: 4 WORD]
```

## Reglas de interpretación

- Se combinan 4 WORD consecutivos, empezando por el WORD alto, y se leen como un entero de 64 bits en complemento a dos.
- El número de elementos es 1/4 del número de WORD del Payload y no hay ABI padding.

## Validez

- El Payload debe tener al menos 4 WORD y ser un múltiplo entero de 4 WORD. Este formato, al no tener descriptor, no admite un vector vacío.

## Fundamento en estándares y estatus del formato

- La signedness del dtype de entero con signo y su ancho de 64 bits se ajustan a los dtypes de la industria de [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) y [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- La interpretación en complemento a dos, la secuencia unidimensional sin descriptor, el TAG/Length de GEUL y la disposición en WORD big-endian son un formato propio de GEUL. DLPack supone que el dtype es native-endian, por lo que este Payload no es la wire serialization de DLPack ni de ONNX.

## Longitud

- El total es la suma de 1 WORD de TAG, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Length](/es/grammar/record/)).

## Ejemplo

- Payload `ffff ffff ffff ffff` son los elementos `[-1]`, un registro de 7 WORD en total.
