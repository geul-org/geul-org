---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT es el Value que representa un escalar de intercambio binario IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `BINARY-FLOAT` (documento de especificación BIND `BINARY-FLOAT`) |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| Documento de especificación | `0x00000000/codecs/0x00000630/` (destino de DECLARE `0630`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 3 |
| Kind | Value · familia: NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | escalar IEEE 754 binary16/32/64/128 con Payload de 1/2/4/8 WORD |
| Lado Hugo | `value/numeric/binary-float.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | resto en bruto (`0xFFFF`) |  |  |

BINARY-FLOAT es el Value que representa un escalar de intercambio binario IEEE 754. Su código directo de Value es `0x063L` y su familia es NUMERIC. Un Payload de 1/2/4/8 WORD es, respectivamente, binary16/32/64/128. Se conserva tal cual la cadena de bits de intercambio y no se admite ningún otro tamaño de Payload.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st  (WORD superior)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (WORD inferior)   IEEE Binary Interchange Nth
```

## Interpretación {#해석}

- Los WORD del Payload se concatenan en orden big-endian y se leen como la cadena de bits de intercambio binario IEEE 754 del ancho correspondiente.
- Se conserva el patrón de bits de intercambio, incluidos el payload de NaN y el cero con signo.
- El decodificador no debe reemplazar un NaN por un NaN canónico cualquiera ni borrar el signo de un cero con signo.
- Este formato de serialización no define el modo de redondeo ni el comportamiento aritmético.

## Longitud {#길이}

El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay) y el Payload ([registro y TAG WORD](../record.md)).

| Formato | Payload | Código de Length | TAG de extensión de Length | Length total |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | ninguno | 2 WORD |
| binary32 | 2 WORD | `0010` | ninguno | 3 WORD |
| binary64 | 4 WORD | `0100` | ninguno | 5 WORD |
| binary128 | 8 WORD | `1000` | ninguno | 9 WORD |

binary128 también está dentro del rango directo de 1 a 14 WORD, por lo que no usa TAG de extensión de Length.

## Validez {#유효성}

- El Payload es exactamente de 1, 2, 4 u 8 WORD.
- Cada tamaño de Payload debe coincidir exactamente con la representación de Length de la tabla anterior.
- No se admiten la recodificación que cambie el ancho ni los WORD de padding antes o después del Payload.

## Ejemplo {#예시}

| Formato | TAG | TAG de extensión de Length | Payload de ejemplo | Veredicto |
|---|---|---|---|---|
| binary16 | `0631` | ninguno | `0000` | canónico |
| binary32 | `0632` | ninguno | `0000 0000` | canónico |
| binary64 | `0634` | ninguno | `0000 0000 0000 0000` | canónico |
| binary128 | `0638` | ninguno | cadena de bits de 8 WORD | canónico |
| cualquiera | no coincide con el tamaño que indica Length | cualquiera | cualquiera | invalid |

## Fundamento normativo {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): se aplican las codificaciones de intercambio binary16, binary32, binary64 y binary128. GEUL solo añade a esa cadena de bits el TAG y el framing big-endian de WORD de 16 bits.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000630/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
