---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS es un Value que contiene el número de segundos como signed int64 desde el Unix epoch (Codec 0x22)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS es el número de segundos con signo desde el Unix epoch `1970-01-01T00:00:00Z`. Como los seconds-since-the-Epoch de POSIX, cuenta cada día como exactamente 86 400 segundos y no cuenta los segundos intercalares.

## Layout

- Código: código directo de Value `0x22`. Familia TIME.
- Para el intercambio de datos industriales se usa el mismo tipo físico de ancho fijo signed int64 que Arrow `timestamp[s]`.

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  5 WORD en total
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretación y validez

- Los 4 WORD del Payload se leen como un conteo signed de 64 bits en complemento a dos, con los WORD en orden big-endian.
- El rango válido es de `-2^63` a `2^63-1` segundos. Un valor negativo es un instant anterior al epoch.
- Los valores pequeños también usan siempre 4 WORD. No se pueden reducir a la representación entera mínima en WORD.
- No contiene zona horaria, UTC offset original, etiqueta de segundo intercalar ni leap-second table.

## Longitud

- El total es exactamente 5 WORD: 1 WORD de TAG más 4 WORD de Payload, y usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni relleno.
- Se rechaza si el Payload no tiene exactamente 4 WORD.

## Ejemplo

- El epoch es Payload `0000 0000 0000 0000`, 5 WORD en total, `LLLL=0100`.
- 1 segundo después del epoch es Payload `0000 0000 0000 0001`.
- 1 segundo antes del epoch es Payload `ffff ffff ffff ffff`.

## Fundamento en estándares

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) solo define los miembros `time_t tv_sec` y `long tv_nsec`; no define un wire format que serialice los segundos acumulados como signed int64. El ancho concreto y la representación de `time_t` dependen del entorno de implementación y no coinciden con la representación del Payload de GEUL.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) define la correspondencia calendárica de los segundos posteriores al epoch y la regla de 86 400 segundos por día.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) y el [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo definen timestamp como un entero signed de 64 bits desde un epoch fijo, con unidad SECOND y sin contar los segundos intercalares. GEUL solo añade a este tipo físico el TAG y el framing de WORD de 16 bits en big-endian.
