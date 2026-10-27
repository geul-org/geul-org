---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS es un Value que contiene el número de nanosegundos con signo desde el GPS epoch 1980-01-06T00:00:00 GPS (formato del Issuer GPS 0x4001)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
GPS-TIMESTAMP-NANOSECONDS es el número de nanosegundos con signo desde el GPS epoch `1980-01-06T00:00:00 GPS`. No se divide por el número de GPS week ni se recorta al ancho de week rollover del campo broadcast.

Esta representación de count acumulado no es el broadcast wire format de IS-GPS-200, sino un profile propio de GEUL que mapea la escala de tiempo GPS a un signed int64 de ancho fijo.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0063` GPS, número de formato `0x4001`. Familia TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD en total
Issuer            1 WORD  0x0063 (GPS)
Número de formato 1 WORD  0x4001
Payload WORD 1.º (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2.º (bits 47..32)     Signed Nanoseconds
Payload WORD 3.º (bits 31..16)     Signed Nanoseconds
Payload WORD 4.º (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretación y validez

- Los 4 WORD completos del Payload se leen como un count signed en complemento a dos de 64 bits en orden de WORD big-endian.
- El rango válido es `-2^63`~`2^63-1` ns. Un negativo es un instant de GPS-time anterior al GPS epoch.
- El count es un valor continuo desde el epoch. No se aplican el truncamiento ni el rollover del campo broadcast de week-number.
- Aunque el valor sea pequeño, siempre se usan 4 WORD. No contiene los parámetros de conversión a UTC.

## Longitud

- El total es exactamente 7 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 4 WORD, y se usa la longitud directa `LLLL=0110`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 4 WORD, se rechaza.

## Ejemplo

- El GPS epoch es el Payload `0000 0000 0000 0000`, 7 WORD en total, `LLLL=0110`.
- 1 ns después del epoch es el Payload `0000 0000 0000 0001`.
- 1 ns antes del epoch es el Payload `ffff ffff ffff ffff`.

## Base estándar y estatus del formato

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) es el lugar oficial de distribución de las especificaciones de interfaz de GPS.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) establece que el GPS time es una escala de tiempo continua y que la week 0 empieza a la medianoche del 1980-01-06, y define el GPS week number y los campos broadcast de time-of-week/Z-count.
- IS-GPS-200 no define una wire representation signed int64 de nanosegundos acumulados desde el epoch. El count continuo sin rollover en nanosegundos, el signed int64 y la disposición en WORD big-endian de GEUL son un mapeo propio de GEUL.
