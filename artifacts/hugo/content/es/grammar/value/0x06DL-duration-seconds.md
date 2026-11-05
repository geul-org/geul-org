---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS es un tiempo transcurrido en segundos con signo, sin epoch."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `DURATION-SECONDS` (documento de especificación BIND `DURATION-SECONDS`) |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| Documento de especificación | `0x00000000/codecs/0x000006D0/` (destino de DECLARE `06D0`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 13 |
| Kind | Value · familia: TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | tiempo transcurrido en SI-second con signo, sin epoch |
| Lado Hugo | `value/time/duration-seconds.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | valor en bruto, 4 WORD |  |  |

DURATION-SECONDS es un tiempo transcurrido en segundos con signo, sin epoch. No es un instant ni una duración de meses o años del calendario.

## Layout {#레이아웃}

- Código: código directo de Value `0x06DL`. Familia TIME.
- Usa el mismo tipo físico int64 con signo de ancho fijo que `Duration(SECOND)` de Arrow.

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretación y validez {#해석과-유효성}

- Los 4 WORD del Payload se leen como un contador con signo de 64 bits en complemento a dos, en orden de WORD big-endian.
- El rango válido es de `-2^63` a `2^63-1` segundos. El signo es la dirección del transcurso y no señala el instant de ningún epoch concreto.
- Incluso los valores pequeños usan siempre 4 WORD.

## Longitud {#길이}

- El total es exactamente 5 WORD: 1 WORD de TAG más 4 WORD de Payload, y usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni padding.
- Si el Payload no es exactamente 4 WORD, se rechaza.

## Ejemplo {#예시}

- 0 segundos es el Payload `0000 0000 0000 0000`, total de 5 WORD, `LLLL=0100`.
- 1 segundo es el Payload `0000 0000 0000 0001`.
- -1 segundo es el Payload `FFFF FFFF FFFF FFFF`.

## Fundamento normativo {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designa `Schema.fbs` como la fuente autoritativa de los tipos de datos estándar de Arrow.
- En el [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo de Arrow, `Duration` es un tiempo transcurrido absoluto independiente del calendario, admite la unidad SECOND y siempre se representa como un entero con signo de 8 bytes. GEUL solo añade a esto el TAG y el framing de WORD de 16 bits big-endian.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000006D0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
