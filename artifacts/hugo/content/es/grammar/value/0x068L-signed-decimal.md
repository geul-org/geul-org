---
title: "SIGNED-DECIMAL (0x068L)"
weight: 104
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL es el Value de decimal exacto (exact decimal) con un coefficient con signo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `SIGNED-DECIMAL` (documento de especificación BIND `SIGNED-DECIMAL`) |
| TAG ID | `0x068L` |
| Codec ID | `0x00000680` |
| Documento de especificación | `0x00000000/codecs/0x00000680/` (destino de DECLARE `0680`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 8 |
| Kind | Value · familia: DECIMAL |
| TAG WORD | `0000 0110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | `C×10^E` con un exponent con signo `E` y un coefficient `C` en complemento a dos con el mínimo de WORD |
| Lado Hugo | `value/decimal/signed-decimal.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | valor en bruto, 2 WORD |  |  |
| 2 | `coefficient` | #3 | resto en bruto (`0xFFFF`) |  |  |

SIGNED-DECIMAL es el Value de decimal exacto (exact decimal) con un coefficient con signo. Su código directo de Value es `0x068L` y su familia es DECIMAL. Los 2 primeros WORD del Payload son el exponent decimal `E` de 32 bit con signo, el resto es el coefficient `C` en complemento a dos con el mínimo de WORD, y el valor es `C×10^E`.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 1000 LLLL      Codec 0x068L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st–2nd (32 bits)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD o más)  Signed Two's-complement Coefficient C
```

## Interpretación {#해석}

- `E` es un entero en complemento a dos big-endian con signo de 32 bit, registrado desde el WORD superior.
- `C` es un entero en complemento a dos de precisión arbitraria formado al concatenar todos los WORD restantes desde el WORD superior.
- `C` sigue la misma regla de mínimo de WORD que [SIGNED-INTEGER](0x061L-signed-integer.md). Se prohíben los WORD `0000` o `FFFF` iniciales que se pueden suprimir.

## Longitud y validez {#길이와-유효성}

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([registro y TAG WORD](../record.md)).
- El Payload tiene como mínimo 3 WORD, porque son 2 WORD de exponent y 1 WORD o más de coefficient.
- La canonicidad de la representación en bytes solo comprueba la representación con el mínimo de WORD del coefficient.

## Ejemplo {#예시}

| Representación del valor | Payload (`E` + `C`) | Veredicto |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | representación en bytes canónica |
| `10×10^-1` | `FFFF FFFF 000A` | representación en bytes canónica; su relación canonical con la anterior es un problema abierto |
| `1×10^0` | `0000 0000 0000 0001` | no canónico: `0000` inicial del coefficient innecesario |
| Payload de 7 WORD | longitud directa `LLLL=0111`, total de 8 WORD | estructura de longitud canónica |

## Estatus del formato {#형식-지위}

- Esta disposición, que une un exponent `E` de 32 bit con signo y un coefficient `C` con el mínimo de WORD, es un formato propio de GEUL, distinto del decimal de intercambio de IEEE 754 y del `DECIMAL` de Apache Parquet.
- El `DECIMAL` de Parquet usa `unscaledValue × 10^(-scale)` y metadatos obligatorios de precision/scale, guarda el unscaled value del tipo físico byte-array en complemento a dos big-endian, y el scale es mayor o igual que 0. Este formato pone `E` con signo en el cuerpo y no tiene metadatos de precision, por lo que no es el mismo formato.
- Para intercambiar datos con el decimal de IEEE 754 o el `DECIMAL` de Parquet hace falta una conversión explícita que fije el rango, la precision/scale, el quantum y la política de valores especiales.
- Fundamento de la comparación: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Problemas abiertos {#열린-문제}

- Hay varios pares exponent/coefficient que representan el mismo número, como `10×10^-1` y `1×10^0`.
- Aún no se ha decidido si este formato conserva el quantum, cómo se juzga la equivalencia de valores ni cómo se normaliza el canonical exponent.
- Por ello, una implementación no debe imponer arbitrariamente una normalización de exponent/coefficient más allá de la regla de mínimo de WORD del coefficient.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000680/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000068000000000
BODY
#1 DECLARE 0x0680
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "SIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
