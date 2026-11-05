---
title: "TAI-TIMESTAMP-SECONDS"
weight: 1022
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-SECONDS es el número de SI-second con signo desde 1970-01-01T00:00:00 TAI."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-SECONDS es el número de SI-second con signo desde `1970-01-01T00:00:00 TAI`. Esta representación de count acumulado no es un wire format estándar de BIPM, sino un profile propio de GEUL que asigna la escala de tiempo TAI a un int64 con signo de ancho fijo.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000013` BIPM, número de Codec `0x00004000`. Familia TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total 9 WORD
Issuer            2 WORD  0x00000013 (BIPM)
Número de Codec   2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed SI Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed SI Seconds
Payload WORD 3rd (bits 31..16)     Signed SI Seconds
Payload WORD 4th (bits 15..0)      Signed SI Seconds low 16bit
```

## Interpretación y validez {#해석과-유효성}

- Los 4 WORD del Payload se leen en conjunto como un count con signo de 64 bit en complemento a dos, en orden de WORD big-endian.
- El rango válido es de `-2^63` a `2^63-1` segundos. Un valor negativo es un instant TAI anterior al epoch fijado por GEUL.
- Los valores pequeños también usan siempre 4 WORD. No se almacenan el UTC offset ni la leap-second table.

## Longitud {#길이}

- El total es exactamente 9 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 4 WORD, con longitud directa `LLLL=1000`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 4 WORD, se rechaza.

## Ejemplo {#예시}

- El TAI epoch de GEUL es el Payload `0000 0000 0000 0000`, 9 WORD en total, `LLLL=1000`.
- 1 segundo después del epoch es el Payload `0000 0000 0000 0001`.
- 1 segundo antes del epoch es el Payload `FFFF FFFF FFFF FFFF`.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- El [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) define el SI second y la escala de tiempo International Atomic Time (TAI).
- BIPM no define un count acumulado en int64 con signo desde el epoch `1970-01-01 TAI` ni su wire encoding. El epoch, el int64 con signo y la disposición en WORD big-endian de GEUL son un mapeo propio de GEUL.
- El int64 de ancho fijo se eligió por coherencia de intercambio con otros profile de count TIME, y no significa que se reproduzca tal cual un formato de BIPM.
