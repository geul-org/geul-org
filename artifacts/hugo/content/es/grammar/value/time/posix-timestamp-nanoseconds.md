---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS es un Value que contiene el número de nanosegundos como signed int64 desde el Unix epoch (formato de Issuer IEEE 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS es el número de nanosegundos con signo desde el Unix epoch `1970-01-01T00:00:00Z`. Como los seconds-since-the-Epoch de POSIX, cuenta cada día como exactamente 86 400 segundos y no cuenta los segundos intercalares.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, número de formato `0x4000`. Familia TIME.
- Para el intercambio de datos industriales se usa el mismo tipo físico de ancho fijo signed int64 que Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD en total
Issuer            1 WORD  0x0040 (IEEE)
Número de formato 1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretación y validez

- Los 4 WORD del Payload se leen como un conteo signed de 64 bits en complemento a dos, con los WORD en orden big-endian.
- El rango válido es de `-2^63` a `2^63-1` ns, y el rango de instant va de `1677-09-21 00:12:43.145224192Z` a `2262-04-11 23:47:16.854775807Z`.
- Los valores pequeños también usan siempre 4 WORD. No se pueden reducir a la representación entera mínima en WORD.
- No contiene zona horaria, UTC offset original, etiqueta de segundo intercalar ni leap-second table.

## Longitud

- El total es exactamente 7 WORD: 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato y 4 WORD de Payload, y usa la longitud directa `LLLL=0110`. No hay TAG de extensión de Length, descriptor ni relleno.
- Se rechaza si el Payload no tiene exactamente 4 WORD.

## Ejemplo

- El epoch es Payload `0000 0000 0000 0000`, 7 WORD en total, `LLLL=0110`.
- 1 ns después del epoch es Payload `0000 0000 0000 0001`.
- 1 ns antes del epoch es Payload `ffff ffff ffff ffff`.

## Fundamento en estándares

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) define los miembros `time_t tv_sec` y `long tv_nsec`, con `0 <= tv_nsec < 10^9`. El ancho concreto y la representación de `time_t` dependen del entorno de implementación, y no define un wire format signed int64 de nanosegundos acumulados que combine ambos miembros.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) cuenta cada día como exactamente 86 400 segundos.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` de [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) almacena los nanosegundos desde el Unix epoch en un único `int64`. GEUL solo añade a este tipo físico el TAG y el framing de WORD de 16 bits en big-endian.
