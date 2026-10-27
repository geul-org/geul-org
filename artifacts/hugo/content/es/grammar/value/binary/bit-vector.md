---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR es un formato Issuer de GEUL que contiene, tras un número de bits N de 32 bits, N bits en orden MSB-first."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
BIT-VECTOR es una secuencia de bits en bruto con su longitud declarada. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, número de formato `0xC002`, familia BINARY. Los primeros 2 WORD del Payload son el bit count `N` unsigned de 32 bits, y detrás vienen `ceil(N/16)` WORD.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG de extensión de Length] si el total es de 15 WORD o más
Issuer            1 WORD  0x0000 (GEUL)
Número de formato 1 WORD  0xC002
Payload WORD 1.º–2.º       Bit Count N (16 bits superiores │ 16 bits inferiores)
Payload WORD 3.º ... N-ésimo   Payload bits, MSB-first
```

## Interpretación y validez

- `N` es el valor de leer los primeros 2 WORD del Payload como un entero unsigned de 32 bits big-endian.
- Los bits del payload se rellenan en orden empezando por el bit más significativo de cada WORD.
- El número de WORD del payload es exactamente `ceil(N/16)`, y los bits inferiores no usados del último WORD deben ser todos 0.
- Si `N=0`, no hay WORD de payload. Los dos WORD de count ya forman el Payload, por lo que no choca con la regla de Payload mínimo de 1 WORD.

## Estatus del formato

- El bit count unsigned de 32 bits, la disposición MSB-first y el relleno de ceros del último WORD no citan un estándar industrial externo, sino que son framing propio de GEUL.
- Esta página define la representación, incluidas las reglas de TAG, Length y WORD de 16 bits de GEUL.

## Longitud

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay), 1 WORD de Issuer, 1 WORD de número de formato y el Payload. Hasta 14 WORD se usa longitud directa y desde 15 WORD longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Registro y TAG WORD](/es/grammar/record/)).

## Ejemplo

- Un bit vector vacío es count `0000 0000`, sin payload, 5 WORD en total, `LLLL=0100`.
- La secuencia de bits `101` es count `0000 0003`, payload `a000`, 6 WORD en total, `LLLL=0101`.
