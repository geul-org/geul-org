---
title: "DENSE-BINARY64-VECTOR"
weight: 1010
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY64-VECTOR es un Value de vector unidimensional que contiene elementos binary64 consecutivos, sin descriptor (formato de Issuer ADHOC 0x0509)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY64-VECTOR almacena bit patterns de intercambio IEEE 754 binary64 consecutivos, sin descriptor.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0509`. Familia NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0509
Payload: [binary64 bits 1st: 4 WORD] ... [binary64 bits Nth: 4 WORD]
```

## Reglas de interpretación

- 4 WORD consecutivos forman un elemento y se leen empezando por el WORD alto. Se conserva tal cual el bit pattern, incluidos el payload de NaN y el signed zero.
- El número de elementos es 1/4 del número de WORD del Payload y no hay ABI padding.

## Validez

- El Payload debe tener al menos 4 WORD y ser un múltiplo entero de 4 WORD. Este formato, al no tener descriptor, no admite un vector vacío.

## Fundamento en estándares y estatus del formato

- El interchange format de los elementos binary64 sigue [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- La secuencia unidimensional sin descriptor, el TAG/Length de GEUL y la disposición en WORD big-endian de 16 bits son un formato propio de GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) supone native-endian, por lo que este Payload no es la wire serialization de DLPack, Arrow ni ONNX.

## Longitud

- El total es la suma de 1 WORD de TAG, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Length](/es/grammar/record/)).

## Ejemplo

- Payload `3ff0 0000 0000 0000` son binary64 `[1.0]`, un registro de 7 WORD en total.
