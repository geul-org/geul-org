---
title: "DENSE-I16-VECTOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I16-VECTOR es un Value de vector unidimensional que contiene elementos int16 big-endian consecutivos, sin descriptor (formato de Issuer ADHOC 0x0500)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I16-VECTOR es un Value unidimensional homogéneo que almacena elementos int16 big-endian consecutivos, sin descriptor.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0500`. Familia NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0500
Payload: [int16 1st: 1 WORD] ... [int16 Nth: 1 WORD]
```

## Reglas de interpretación

- Cada WORD se lee como un entero independiente de 16 bits en complemento a dos. El número de elementos es el número de WORD del Payload.
- No hay ABI padding entre los elementos ni al final.

## Validez

- El Payload debe tener al menos 1 WORD. Este formato, al no tener descriptor, no admite un vector vacío.
- El tamaño del Payload debe ser un múltiplo entero del ancho de elemento, 1 WORD.

## Fundamento en estándares y estatus del formato

- La signedness del dtype de entero con signo y su ancho de 16 bits se ajustan a los dtypes de la industria de [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) y [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- La interpretación en complemento a dos, la secuencia unidimensional sin descriptor, el TAG/Length de GEUL y la disposición en WORD big-endian son un formato propio de GEUL. DLPack supone que el dtype es native-endian, por lo que este Payload no es la wire serialization de DLPack ni de ONNX.

## Longitud

- El total es la suma de 1 WORD de TAG, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Length](/es/grammar/record/)).

## Ejemplo

- Payload `ffff 0002` son los elementos `[-1, 2]`, un registro de 5 WORD en total con longitud directa `LLLL=0100`.
