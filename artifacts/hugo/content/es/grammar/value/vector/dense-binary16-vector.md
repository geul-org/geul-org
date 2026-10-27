---
title: "DENSE-BINARY16-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR es un Value de vector unidimensional que contiene elementos binary16 consecutivos, sin descriptor (formato de Issuer ADHOC 0x0506)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR almacena bit patterns de intercambio IEEE 754 binary16 consecutivos, sin descriptor.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0506`. Familia NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## Reglas de interpretación

- El número de elementos es el número de WORD del Payload. Se conserva tal cual el bit pattern, incluidos el payload de NaN y el signed zero.
- No hay ABI padding entre los elementos ni al final.

## Validez

- El Payload debe tener al menos 1 WORD. Este formato, al no tener descriptor, no admite un vector vacío.
- El tamaño del Payload debe ser un múltiplo entero del ancho de elemento, 1 WORD.

## Fundamento en estándares y estatus del formato

- El interchange format de los elementos binary16 sigue [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- La secuencia unidimensional sin descriptor, el TAG/Length de GEUL y la disposición en WORD big-endian de 16 bits son un formato propio de GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) supone native-endian, por lo que este Payload no es la wire serialization de DLPack, Arrow ni ONNX.

## Longitud

- El total es la suma de 1 WORD de TAG, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Length](/es/grammar/record/)).

## Ejemplo

- Payload `3c00 8000` son binary16 `1.0` y `-0`, un registro de 5 WORD en total.
