---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS es un Value que contiene el número de nanosegundos con signo desde 1970-01-01T00:00:00 TAI (formato de Issuer BIPM 0x4001)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS es el número de nanosegundos con signo desde el mismo epoch TAI, `1970-01-01T00:00:00 TAI`. Esta representación de conteo acumulado no es un wire format estándar de BIPM, sino un profile propio de GEUL que mapea la escala de tiempo TAI a un signed int64 de ancho fijo.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0060` BIPM, número de formato `0x4001`. Familia TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD en total
Issuer            1 WORD  0x0060 (BIPM)
Número de formato 1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretación y validez

- Los 4 WORD del Payload se leen como un conteo signed de 64 bits en complemento a dos, con los WORD en orden big-endian.
- El rango válido es de `-2^63` a `2^63-1` ns. Un valor negativo es un instant TAI anterior al epoch fijado por GEUL.
- Los valores pequeños también usan siempre 4 WORD. No se almacenan UTC offset ni leap-second table.

## Longitud

- El total es exactamente 7 WORD: 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato y 4 WORD de Payload, y usa la longitud directa `LLLL=0110`. No hay TAG de extensión de Length, descriptor ni relleno.
- Se rechaza si el Payload no tiene exactamente 4 WORD.

## Ejemplo

- El epoch TAI de GEUL es Payload `0000 0000 0000 0000`, 7 WORD en total, `LLLL=0110`.
- 1 ns después del epoch es Payload `0000 0000 0000 0001`.
- 1 ns antes del epoch es Payload `ffff ffff ffff ffff`.

## Fundamento en estándares y estatus del formato

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) establece el segundo SI y la escala de tiempo International Atomic Time (TAI).
- BIPM no define un conteo acumulado signed int64 de nanosegundos desde el epoch `1970-01-01 TAI` ni su wire encoding. El epoch, el conteo por unidad, el signed int64 y la disposición en WORD big-endian de GEUL son un mapeo propio de GEUL.
- El int64 de ancho fijo se eligió por coherencia de intercambio con otros profiles de conteo TIME; no significa que se reproduzca tal cual un formato de BIPM.
