---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER es el Value que representa un entero sin signo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `UNSIGNED-INTEGER` (documento de especificación BIND `UNSIGNED-INTEGER`) |
| TAG ID | `0x062L` |
| Codec ID | `0x00000620` |
| Documento de especificación | `0x00000000/codecs/0x00000620/` (destino de DECLARE `0620`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 2 |
| Kind | Value · familia: NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | entero unsigned magnitude big-endian con el mínimo de WORD |
| Lado Hugo | `value/numeric/unsigned-integer.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | resto en bruto (`0xFFFF`) |  |  |

UNSIGNED-INTEGER es el Value que representa un entero sin signo. Su código directo de Value es `0x062L` y su familia es NUMERIC. Todo el Payload se lee como una unsigned magnitude de precisión arbitraria en orden de WORD big-endian. El Payload tiene como mínimo 1 WORD y solo se admite la representación canónica con el mínimo de WORD.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st  (WORD superior)   Unsigned Magnitude 1st
...
Payload WORD Nth  (WORD inferior)   Unsigned Magnitude Nth
```

## Interpretación {#해석}

- El primer WORD del Payload es la posición más alta y el último WORD la más baja.
- Si el Payload tiene N WORD, se lee como una única unsigned magnitude de `16N` bit.
- Este ancho no es un ancho de almacenamiento declarado y no hay descriptor de ancho en bits.

## Representación canónica {#정규-표현}

- El 0 es el Payload de 1 WORD `0000`.
- Cuando el Payload tiene 2 WORD o más, un primer WORD `0000` no es canónico, porque suprimirlo no cambia el valor.
- El decodificador debe rechazar las representaciones con WORD cero iniciales innecesarios.

## Longitud {#길이}

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa la longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también cuenta en el total ([registro y TAG WORD](../record.md)).
- No se conserva el ancho declarado como UINT8, UINT16 o UINT32; solo se conserva el valor numérico.

## Ejemplo {#예시}

| Valor | Payload WORD | Veredicto |
|---:|---|---|
| 0 | `0000` | canónico |
| 1 | `0001` | canónico |
| 65535 | `FFFF` | canónico |
| 65536 | `0001 0000` | canónico |
| 1 | `0000 0001` | no canónico: `0000` inicial innecesario |
| Payload de 7 WORD | los 7 WORD que siguen al TAG `0627` (longitud directa `LLLL=0111`, total de 8 WORD) | canónico |
| Payload de 7 WORD | los 7 WORD que siguen al TAG de longitud extendida y al valor de extensión `0009` | no canónico: hasta 14 WORD se usa la longitud directa |

## Estatus del formato {#형식-지위}

- Esta representación, que normaliza una unsigned magnitude de precisión arbitraria a una secuencia de WORD de al menos 16 bits y la une a un TAG de GEUL, es un perfil escalar propio de GEUL.
- Para intercambiar datos con tipos externos de ancho fijo como UINT8/16/32/64 hacen falta una comprobación de rango y una conversión de ancho explícita.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000620/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
