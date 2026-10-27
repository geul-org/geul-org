---
title: "DENSE-U16-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U16-VECTOR es un Value de vector unidimensional que contiene elementos uint16 big-endian consecutivos, sin descriptor (formato de Issuer ADHOC 0x0501)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U16-VECTOR es un Value unidimensional homogéneo que almacena elementos uint16 big-endian consecutivos, sin descriptor.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0501`. Familia NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0501
Payload: [uint16 1st: 1 WORD] ... [uint16 Nth: 1 WORD]
```

## Reglas de interpretación

- Cada WORD se lee como un entero unsigned independiente de 16 bits. El número de elementos es el número de WORD del Payload.
- No hay ABI padding entre los elementos ni al final.

## Validez

- El Payload debe tener al menos 1 WORD. Este formato, al no tener descriptor, no admite un vector vacío.
- El tamaño del Payload debe ser un múltiplo entero del ancho de elemento, 1 WORD.

## Fundamento en estándares y estatus del formato

- La interpretación unsigned del dtype de entero sin signo y su ancho de 16 bits se ajustan a los dtypes de la industria de [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) y [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- La secuencia unidimensional sin descriptor, el TAG/Length de GEUL y la disposición en WORD big-endian son un formato propio de GEUL. DLPack supone que el dtype es native-endian, por lo que este Payload no es la wire serialization de DLPack ni de ONNX.

## Longitud

- El total es la suma de 1 WORD de TAG, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Length](/es/grammar/record/)).

## Ejemplo

- Payload `0000 ffff` son los elementos `[0, 65535]`, un registro de 5 WORD en total con longitud directa `LLLL=0100`.
