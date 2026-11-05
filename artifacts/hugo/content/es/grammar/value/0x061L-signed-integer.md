---
title: "SIGNED-INTEGER (0x061L)"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER es el Value que representa un entero con signo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `SIGNED-INTEGER` (documento de especificación BIND `SIGNED-INTEGER`) |
| TAG ID | `0x061L` |
| Codec ID | `0x00000610` |
| Documento de especificación | `0x00000000/codecs/0x00000610/` (destino de DECLARE `0610`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 1 |
| Kind | Value · familia: NUMERIC |
| TAG WORD | `0000 0110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | entero con signo en complemento a dos con el mínimo de WORD |
| Lado Hugo | `value/numeric/signed-integer.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `integer` | #2 | resto en bruto (`0xFFFF`) |  |  |

SIGNED-INTEGER es el Value que representa un entero con signo. Su código directo de Value es `0x061L` y su familia es NUMERIC. Todo el Payload se lee como un entero en complemento a dos de precisión arbitraria, en orden de WORD big-endian. El Payload tiene como mínimo 1 WORD y solo se admite la representación canónica con el mínimo de WORD.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0001 LLLL      Codec 0x061L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st  (WORD superior)   Integer 1st
...
Payload WORD Nth  (WORD inferior)   Integer Nth
```

## Interpretación {#해석}

- El bit más significativo del primer WORD del Payload es el bit de signo de todo el entero.
- Todos los WORD del Payload se leen como una única cadena continua de bits en complemento a dos. El primer WORD es la posición más alta y el último WORD la más baja.
- Si el Payload tiene N WORD, el ancho de interpretación es de `16N` bit. Este ancho no es un ancho de almacenamiento declarado, sino el ancho de representación del valor, fijado por la representación canónica.
- No hay Byte Count ni descriptor de ancho en bits.

## Representación canónica {#정규-표현}

- El 0 es el Payload de 1 WORD `0000`.
- Se prohíben los WORD de extensión de signo iniciales que no cambian el valor.
- Cuando el Payload tiene 2 WORD o más, los siguientes casos no son canónicos.
  - El primer WORD es `0000` y el bit más significativo del WORD siguiente es 0.
  - El primer WORD es `FFFF` y el bit más significativo del WORD siguiente es 1.
- Un `0000` inicial que preserva el signo de un positivo se admite cuando el bit más significativo del WORD siguiente es 1.
- Un `FFFF` inicial que preserva el signo de un negativo se admite cuando el bit más significativo del WORD siguiente es 0.
- El decodificador debe rechazar las representaciones no canónicas.

## Longitud {#길이}

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([registro y TAG WORD](../record.md)).
- No se conserva el ancho declarado como INT8, INT16 o INT32; solo se conserva el valor numérico. De `-32768` a `32767` ocupa 1 WORD, y fuera de ese rango se añaden los WORD necesarios. No existe un formato SIGNED-INT8 aparte.

## Ejemplo {#예시}

| Valor | Payload WORD | Veredicto |
|---:|---|---|
| 0 | `0000` | canónico |
| 1 | `0001` | canónico |
| 32767 | `7FFF` | canónico |
| 32768 | `0000 8000` | canónico: se necesita `0000` para preservar el signo positivo |
| -1 | `FFFF` | canónico |
| -32768 | `8000` | canónico |
| -32769 | `FFFF 7FFF` | canónico: se necesita `FFFF` para preservar el signo negativo |
| 1 | `0000 0001` | no canónico: `0000` inicial innecesario |
| -1 | `FFFF FFFF` | no canónico: `FFFF` inicial innecesario |

## Estatus del formato {#형식-지위}

- El complemento a dos es una convención muy extendida, pero esta representación, que normaliza un valor de precisión arbitraria a una secuencia de WORD de al menos 16 bits y la une a un TAG de GEUL, es un perfil escalar propio de GEUL.
- Para intercambiar datos con tipos externos de ancho fijo como INT8/16/32/64 hacen falta una comprobación de rango y una conversión de ancho explícita.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000610/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000061000000000
BODY
#1 DECLARE 0x0610
#2 FIELD #1 rest
#3 BIND #1 "SIGNED-INTEGER"
#4 BIND #2 "integer"
```
