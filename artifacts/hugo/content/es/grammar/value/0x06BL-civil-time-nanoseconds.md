---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS representa una hora civil sin fecha como el número de nanosegundos transcurridos desde la medianoche."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `CIVIL-TIME-NANOSECONDS` (documento de especificación BIND `CIVIL-TIME-NANOSECONDS`) |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| Documento de especificación | `0x00000000/codecs/0x000006B0/` (destino de DECLARE `06B0`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 11 |
| Kind | Value · familia: TIME |
| TAG WORD | `0000 0110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | contador unsigned de nanosegundos desde la medianoche del día civil |
| Lado Hugo | `value/time/civil-time-nanoseconds.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | valor en bruto, 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS representa una hora civil sin fecha como el número de nanosegundos transcurridos desde la medianoche.

## Layout {#레이아웃}

- Código: código directo de Value `0x06BL`. Familia TIME.
- Usa el mismo tipo físico int64 con signo de ancho fijo que `TIME(isAdjustedToUTC=false, unit=NANOS)` de Parquet.

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretación y validez {#해석과-유효성}

- Los 4 WORD del Payload se leen como un contador con signo de 64 bits en complemento a dos, en orden de WORD big-endian.
- El tipo físico es int64 con signo, pero el rango válido es `0 <= value < 86,400×10^9` ns. Se rechazan los negativos y los valores iguales o superiores al límite.
- No se permiten `24:00` ni la etiqueta de segundo intercalar. Tampoco contiene fecha, zona horaria ni UTC offset.
- Incluso los valores pequeños usan siempre 4 WORD.

## Longitud {#길이}

- El total es exactamente 5 WORD: 1 WORD de TAG más 4 WORD de Payload, y usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni padding.
- Si el Payload no es exactamente 4 WORD, se rechaza.

## Ejemplo {#예시}

- La medianoche es el Payload `0000 0000 0000 0000`, total de 5 WORD, `LLLL=0100`.
- 1 ns después de la medianoche es el Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns es igual al límite, por lo que no es válido.
- `FFFF FFFF FFFF FFFF` es -1 como int64 con signo, por lo que no es válido.

## Fundamento normativo {#표준-근거}

- `TIME(isAdjustedToUTC=false, unit=NANOS)` de [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) guarda en un `int64` los nanosegundos desde la medianoche de la hora local y usa orden con signo.
- Según [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html), el [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo define Time NANOSECOND como entero de 64 bits con signo, limita el rango válido a desde la medianoche (inclusive) hasta menos de 86,400 segundos y no permite segundos intercalares. GEUL solo añade el TAG y el framing de WORD de 16 bits big-endian.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000006B0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
