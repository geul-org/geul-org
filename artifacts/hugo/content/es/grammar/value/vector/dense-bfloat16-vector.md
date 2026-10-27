---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR es un Value de vector unidimensional que contiene elementos BF16 consecutivos, sin descriptor (formato de Issuer ADHOC 0x0507)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR almacena bit patterns de elementos bfloat16 de 16 bits consecutivos, sin descriptor. Es un formato distinto de binary16.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0507`. Familia NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## Reglas de interpretación

- El número de elementos es el número de WORD del Payload. Se conserva tal cual el bit pattern, incluidos el payload de NaN y el signed zero.
- No hay ABI padding entre los elementos ni al final.

## Validez

- El Payload debe tener al menos 1 WORD. Este formato, al no tener descriptor, no admite un vector vacío.
- El tamaño del Payload debe ser un múltiplo entero del ancho de elemento, 1 WORD.

## Fundamento en estándares y estatus del formato

- La distinción de un dtype de 16 bits propio, bfloat16, respecto de binary16 se ajusta a [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) y a [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html).
- La secuencia unidimensional de bit patterns sin descriptor, el TAG/Length de GEUL y la disposición en WORD big-endian de 16 bits son un formato propio de GEUL. DLPack supone native-endian, por lo que este Payload no es la wire serialization de DLPack, Arrow ni ONNX.

## Longitud

- El total es la suma de 1 WORD de TAG, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Length](/es/grammar/record/)).

## Ejemplo

- Payload `3f80 8000` son BF16 `1.0` y `-0`, un registro de 5 WORD en total.
