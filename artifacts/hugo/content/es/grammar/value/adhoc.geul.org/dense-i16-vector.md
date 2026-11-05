---
title: "DENSE-I16-VECTOR"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I16-VECTOR es un Value 1D homogéneo que almacena de forma contigua, sin descriptor, elementos int16 big-endian."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I16-VECTOR es un Value 1D homogéneo que almacena de forma contigua, sin descriptor, elementos int16 big-endian.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x00000500`. Familia NUMERIC.

```
TAG WORD                  0000 1001 1101 LLLL      Codec 0x09DL
[TAG extendida de Length] si el total es de 15 WORD o más
Issuer                    2 WORD  0x00000002 (ADHOC)
Número de Codec           2 WORD  0x00000500
Payload: [int16 1st: 1 WORD] ... [int16 Nth: 1 WORD]
```

## Reglas de interpretación {#해석-규칙}

- Cada WORD se lee como un entero de complemento a dos independiente de 16 bit. El número de elementos es el número de WORD del Payload.
- No hay ABI padding entre los elementos ni al final.

## Validez {#유효성}

- El Payload debe ser de 1 WORD o más. Este formato, que no tiene descriptor, no admite un vector vacío.
- El tamaño del Payload debe ser un múltiplo entero del ancho de elemento, 1 WORD.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- El signo (signed) y el ancho de 16 bit del dtype de entero se ajustan a los dtype de la industria: [tensor element type de ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) y [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- La interpretación en complemento a dos, la secuencia contigua 1D sin descriptor, el TAG/Length de GEUL y la disposición en WORD big-endian son un formato propio de GEUL. DLPack asume que el dtype es native-endian, por lo que este Payload no es la wire serialization de DLPack ni de ONNX.

## Longitud {#길이}

- El total es el número de WORD que suman TAG 1 WORD, TAG extendida de Length (si existe), Issuer 2 WORD, número de Codec 2 WORD y Payload. Hasta 14 WORD se usa longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y la TAG extendida también cuenta en el total ([Length](../../record.md)).

## Ejemplo {#예시}

- El Payload `FFFF 0002` son los elementos `[-1, 2]`, y forma un registro de 7 WORD en total con longitud directa `LLLL=0110`.
