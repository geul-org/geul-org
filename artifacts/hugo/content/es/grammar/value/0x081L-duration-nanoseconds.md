---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS es un tiempo transcurrido en nanosegundos con signo y sin epoch."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS es un tiempo transcurrido en nanosegundos con signo y sin epoch. No es un instant ni un período de meses o años del calendario.

| Elemento | Valor |
|---|---|
| Nombre | `DURATION-NANOSECONDS` (BIND del documento de especificación `DURATION-NANOSECONDS`) |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| Documento de especificación | `0x00000000/codecs/0x00000810/` (destino de DECLARE `0810`) |
| Sección | 4 `0100` (Value), desplazamiento C dentro de la sección = 1 |
| Kind | Value · familia: TIME |
| TAG WORD | `0000 1000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Tiempo transcurrido en nanosegundos con signo y sin epoch |
| Lado Hugo | `value/time/duration-nanoseconds.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato que recibe (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | valor en bruto de 4 WORD |  |  |

## Layout {#레이아웃}

- Código: código directo de Value `0x081L`. Familia TIME.
- Usa el mismo tipo físico signed int64 de ancho fijo que `Duration(NANOSECOND)` de Arrow.

```
TAG WORD          0x0814 (0000 1000 0001 0100)  5 WORD en total
Payload WORD 1st (bits 63..48)     Signed Nanoseconds 16 bits superiores
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds 16 bits inferiores
```

## Interpretación y validez {#해석과-유효성}

- Los 4 WORD de Payload completos se leen como un count con signo en complemento a dos de 64 bits, en orden de WORD big-endian.
- El rango válido es de `-2^63` a `2^63-1` ns. El signo es la dirección del transcurso y no apunta al instant de ningún epoch concreto.
- Incluso los valores pequeños usan siempre 4 WORD.

## Longitud {#길이}

- El total son exactamente 5 WORD, la suma de 1 WORD de TAG y 4 WORD de Payload, y usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni padding.
- Si el Payload no es exactamente 4 WORD, se rechaza.

## Ejemplo {#예시}

- 0 ns tiene Payload `0000 0000 0000 0000`, 5 WORD en total y `LLLL=0100`. El total es `0814 0000 0000 0000 0000`.
- 1 ns tiene Payload `0000 0000 0000 0001`.
- -1 ns tiene Payload `FFFF FFFF FFFF FFFF`.

## Fundamento normativo {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designa `Schema.fbs` como fuente autorizada de los tipos de datos estándar de Arrow.
- En el [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autorizado de Arrow, `Duration` es un tiempo transcurrido absoluto independiente del calendario, admite la unidad NANOSECOND y se representa siempre como un entero con signo de 8 bytes. GEUL solo añade a esto el TAG y el framing de WORD de 16 bits big-endian.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000810/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
