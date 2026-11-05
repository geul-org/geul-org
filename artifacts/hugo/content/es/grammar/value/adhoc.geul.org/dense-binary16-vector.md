---
title: "DENSE-BINARY16-VECTOR"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR almacena de forma contigua, sin descriptor, bit pattern de interchange IEEE 754 binary16."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR almacena de forma contigua, sin descriptor, bit pattern de interchange IEEE 754 binary16.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x00000506`. Familia NUMERIC.

```
TAG WORD                  0000 1001 1101 LLLL      Codec 0x09DL
[TAG extendida de Length] si el total es de 15 WORD o más
Issuer                    2 WORD  0x00000002 (ADHOC)
Número de Codec           2 WORD  0x00000506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## Reglas de interpretación {#해석-규칙}

- El número de elementos es el número de WORD del Payload. Se conserva el bit pattern, incluidos el NaN payload y el cero con signo.
- No hay ABI padding entre los elementos ni al final.

## Validez {#유효성}

- El Payload debe ser de 1 WORD o más. Este formato, que no tiene descriptor, no admite un vector vacío.
- El tamaño del Payload debe ser un múltiplo entero del ancho de elemento, 1 WORD.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- El interchange format de los elementos binary16 sigue [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- La secuencia contigua 1D sin descriptor, el TAG/Length de GEUL y la disposición en WORD big-endian de 16 bit son un formato propio de GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) asume native-endian, por lo que este Payload no es la wire serialization de DLPack, Arrow ni ONNX.

## Longitud {#길이}

- El total es el número de WORD que suman TAG 1 WORD, TAG extendida de Length (si existe), Issuer 2 WORD, número de Codec 2 WORD y Payload. Hasta 14 WORD se usa longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y la TAG extendida también cuenta en el total ([Length](../../record.md)).

## Ejemplo {#예시}

- El Payload `3C00 8000` es binary16 `1.0` y `-0`, y forma un registro de 7 WORD en total.
