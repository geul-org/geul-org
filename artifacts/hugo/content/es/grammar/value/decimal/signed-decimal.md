---
title: "SIGNED-DECIMAL"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL es un Value que contiene el decimal exacto C×10^E con un exponente E de 32 bits con signo y un coeficiente C en complemento a dos de WORD mínimos."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
SIGNED-DECIMAL es un Value de decimal exacto (exact decimal) con coeficiente con signo. Es el código directo de Value `0x10`, familia DECIMAL. Los primeros 2 WORD del Payload son el exponente decimal `E` de 32 bits con signo, el resto es el coeficiente `C` en complemento a dos de WORD mínimos, y el valor es `C×10^E`.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x10
[TAG de extensión de Length] si el total es de 15 WORD o más
Payload WORD 1.º–2.º (32 bits)       Signed Base-10 Exponent E
Payload WORD 3.º–N-ésimo (1 WORD o más)  Signed Two's-complement Coefficient C
```

## Interpretación

- `E` es un entero en complemento a dos big-endian de 32 bits con signo, escrito empezando por el WORD superior.
- `C` es un entero de precisión arbitraria en complemento a dos que resulta de concatenar todos los WORD restantes empezando por el WORD superior.
- `C` sigue la misma regla de WORD mínimos que [SIGNED-INTEGER](/es/grammar/value/numeric/signed-integer/). Se prohíben los WORD iniciales `0000` o `ffff` que se puedan quitar.

## Longitud y validez

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa longitud directa y desde 15 WORD longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([Registro y TAG WORD](/es/grammar/record/)).
- El Payload tiene como mínimo 3 WORD, porque lleva 2 WORD de exponente y 1 WORD o más de coeficiente.
- La canonicidad de la representación en bytes solo comprueba la representación de WORD mínimos del coeficiente.

## Ejemplo

| Representación del valor | Payload (`E` + `C`) | Veredicto |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | Representación en bytes canónica |
| `10×10^-1` | `ffff ffff 000a` | Representación en bytes canónica; su relación canónica con la anterior es un problema abierto |
| `1×10^0` | `0000 0000 0000 0001` | No canónica: sobra el `0000` inicial del coeficiente |
| Payload de 7 WORD | longitud directa `LLLL=0111`, 8 WORD en total | Estructura de longitud canónica |

## Estatus del formato

- Esta disposición, que une el exponente `E` de 32 bits con signo y el coeficiente `C` de WORD mínimos, no es el interchange decimal de IEEE 754 ni el `DECIMAL` de Apache Parquet, sino un formato propio de GEUL.
- El `DECIMAL` de Parquet usa `unscaledValue × 10^(-scale)` y metadatos obligatorios de precision/scale, almacena el unscaled value del tipo físico byte-array en complemento a dos big-endian, y su scale es 0 o mayor. Este formato pone el `E` con signo en el cuerpo y no tiene metadatos de precision, por lo que no es el mismo formato.
- Para intercambiar con decimales IEEE 754 o con el `DECIMAL` de Parquet hace falta una conversión explícita que fije el rango, precision/scale, quantum y la política de valores especiales.
- Fuentes de comparación: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Problemas abiertos

- Hay varios pares exponente/coeficiente que representan el mismo número, como `10×10^-1` y `1×10^0`.
- Aún no se ha fijado si este formato conserva el quantum, cómo se juzga la equivalencia de valor ni cómo se normaliza el exponente canónico.
- Por eso, una implementación no debe imponer arbitrariamente una normalización de exponente/coeficiente más allá de la regla de WORD mínimos del coeficiente.
