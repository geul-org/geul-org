---
title: "POSIX-TIMESTAMP-SECONDS (0x06CL)"
weight: 108
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS es el número de segundos con signo desde el epoch de Unix 1970-01-01T00:00:00Z."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `POSIX-TIMESTAMP-SECONDS` (documento de especificación BIND `POSIX-TIMESTAMP-SECONDS`) |
| TAG ID | `0x06CL` |
| Codec ID | `0x000006C0` |
| Documento de especificación | `0x00000000/codecs/0x000006C0/` (destino de DECLARE `06C0`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 12 |
| Kind | Value · familia: TIME |
| TAG WORD | `0000 0110 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | contador de segundos con signo desde el epoch de Unix/POSIX |
| Lado Hugo | `value/time/posix-timestamp-seconds.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | valor en bruto, 4 WORD |  |  |

POSIX-TIMESTAMP-SECONDS es el número de segundos con signo desde el epoch de Unix `1970-01-01T00:00:00Z`. Como en los seconds-since-the-Epoch de POSIX, considera que todos los días tienen exactamente 86,400 segundos y no cuenta los segundos intercalares.

## Layout {#레이아웃}

- Código: código directo de Value `0x06CL`. Familia TIME.
- Para el intercambio de datos industriales usa el mismo tipo físico int64 con signo de ancho fijo que `timestamp[s]` de Arrow.

```
TAG WORD          0x06C4 (0000 0110 1100 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretación y validez {#해석과-유효성}

- Los 4 WORD del Payload se leen como un contador con signo de 64 bits en complemento a dos, en orden de WORD big-endian.
- El rango válido es de `-2^63` a `2^63-1` segundos. Los negativos son instantes anteriores al epoch.
- Incluso los valores pequeños usan siempre 4 WORD. No se debe reducir a la representación entera con el mínimo de WORD.
- No contiene zona horaria, UTC offset original, etiqueta de segundo intercalar ni tabla de segundos intercalares.

## Longitud {#길이}

- El total es exactamente 5 WORD: 1 WORD de TAG más 4 WORD de Payload, y usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni padding.
- Si el Payload no es exactamente 4 WORD, se rechaza.

## Ejemplo {#예시}

- El epoch es el Payload `0000 0000 0000 0000`, total de 5 WORD, `LLLL=0100`.
- 1 segundo después del epoch es el Payload `0000 0000 0000 0001`.
- 1 segundo antes del epoch es el Payload `FFFF FFFF FFFF FFFF`.

## Fundamento normativo {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) solo define los miembros `time_t tv_sec` y `long tv_nsec`; no define un formato de transmisión que serialice los segundos acumulados como int64 con signo. El ancho concreto y la representación de `time_t` dependen del entorno de implementación y no son iguales a la representación del Payload de GEUL.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) define la correspondencia con el calendario de los segundos posteriores al epoch y la regla de 86,400 segundos por día.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) y el [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo definen el timestamp como un entero de 64 bits con signo desde un epoch fijo, y admiten la unidad SECOND y la no contabilización de los segundos intercalares. GEUL solo añade a este tipo físico el TAG y el framing de WORD de 16 bits big-endian.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x000006C0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006C000000000
BODY
#1 DECLARE 0x06C0
#2 FIELD #1 0x0004
#3 BIND #1 "POSIX-TIMESTAMP-SECONDS"
#4 BIND #2 "seconds"
```
