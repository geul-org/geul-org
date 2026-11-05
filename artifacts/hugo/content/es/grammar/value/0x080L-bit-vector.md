---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR es una raw bit sequence con su longitud declarada."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR es una raw bit sequence con su longitud declarada. Es el código directo de Value `0x080L`, de la familia BINARY. Los dos primeros WORD de Payload son el bit count `N` unsigned de 32 bits, y a continuación vienen `ceil(N/16)` WORD.

| Elemento | Valor |
|---|---|
| Nombre | `BIT-VECTOR` (BIND del documento de especificación `BIT-VECTOR`) |
| TAG ID | `0x080L` |
| Codec ID | `0x00000800` |
| Documento de especificación | `0x00000000/codecs/0x00000800/` (destino de DECLARE `0800`) |
| Sección | 4 `0100` (Value), desplazamiento C dentro de la sección = 0 |
| Kind | Value · familia: BINARY |
| TAG WORD | `0000 1000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | N bits almacenados MSB-first tras el bit-count |
| Lado Hugo | `value/binary/bit-vector.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | valor en bruto de 2 WORD |  |  |
| 2 | `bits` | #3 | resto de valor en bruto (`0xFFFF`) |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[TAG de extensión de Length] cuando el total es de 15 WORD o más
Payload WORD 1st–2nd       Bit Count N (16 bits superiores │ 16 bits inferiores)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Interpretación y validez {#해석과-유효성}

- `N` es el valor que resulta de leer los dos primeros WORD de Payload como un entero unsigned de 32 bits big-endian.
- Los bits del payload se rellenan en orden desde el bit más significativo de cada WORD.
- El número de WORD de payload es exactamente `ceil(N/16)`, y los bits inferiores no usados del último WORD deben ser todos 0.
- Si `N=0`, no hay WORD de payload. Los dos WORD de count ya forman el Payload, por lo que no entra en conflicto con la regla de un mínimo de 1 WORD de Payload.

## Estatus del formato {#형식-지위}

- El bit count unsigned de 32 bits, la disposición MSB-first y el zero padding del último WORD no citan un estándar industrial externo, sino que son un framing propio de GEUL.
- Esta página define la representación, incluidas las reglas de TAG, Length y WORD de 16 bits de GEUL.

## Longitud {#길이}

- El total es el número de WORD que suman 1 WORD de TAG, el TAG de extensión de Length (si lo hay) y el Payload. Hasta 14 WORD se usa longitud directa; desde 15 WORD se usa la longitud extendida `1110`·`1111`, y el TAG de extensión también entra en el total ([Registro y TAG WORD](../record.md)).

## Ejemplo {#예시}

- Un bit vector vacío tiene count `0000 0000`, sin payload, 3 WORD en total y `LLLL=0010`. El total es `0802 0000 0000`.
- La bit sequence `101` tiene count `0000 0003`, payload `A000`, 4 WORD en total y `LLLL=0011`. El total es `0803 0000 0003 A000`.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000800/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
