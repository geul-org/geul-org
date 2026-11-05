---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1023
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS es el número de nanosecond con signo desde el GPS epoch 1980-01-06T00:00:00 GPS."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS es el número de nanosecond con signo desde el GPS epoch `1980-01-06T00:00:00 GPS`. No se divide por el número de GPS week ni se trunca al ancho de week rollover del broadcast field.

Esta representación de count acumulado no es el broadcast wire format de IS-GPS-200, sino un profile propio de GEUL que asigna la escala de tiempo GPS a un int64 con signo de ancho fijo.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000016` GPS, número de Codec `0x00004001`. Familia TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total 9 WORD
Issuer            2 WORD  0x00000016 (GPS)
Número de Codec   2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretación y validez {#해석과-유효성}

- Los 4 WORD del Payload se leen en conjunto como un count con signo de 64 bit en complemento a dos, en orden de WORD big-endian.
- El rango válido es de `-2^63` a `2^63-1` ns. Un valor negativo es un instant de GPS-time anterior al GPS epoch.
- El count es un valor continuo a partir del epoch. No se aplican la truncation ni el rollover del week-number field del broadcast.
- Los valores pequeños también usan siempre 4 WORD. No se incluyen los parámetros de conversión a UTC.

## Longitud {#길이}

- El total es exactamente 9 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 4 WORD, con longitud directa `LLLL=1000`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 4 WORD, se rechaza.

## Ejemplo {#예시}

- El GPS epoch es el Payload `0000 0000 0000 0000`, 9 WORD en total, `LLLL=1000`.
- 1 ns después del epoch es el Payload `0000 0000 0000 0001`.
- 1 ns antes del epoch es el Payload `FFFF FFFF FFFF FFFF`.

## Base normativa y estatus del formato {#표준-근거와-형식-지위}

- La [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) es el lugar oficial de distribución de las especificaciones de interfaz de GPS.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) establece que GPS time es una escala de tiempo continua y que la week 0 comienza a la medianoche del 1980-01-06, y define el GPS week number y los broadcast field de time-of-week/Z-count.
- IS-GPS-200 no define una wire representation int64 con signo del nanosecond acumulado desde el epoch. El count continuo en nanosecond sin rollover, el int64 con signo y la disposición en WORD big-endian de GEUL son un mapeo propio de GEUL.
