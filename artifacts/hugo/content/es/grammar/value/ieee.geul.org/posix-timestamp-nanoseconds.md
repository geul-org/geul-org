---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1032
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS es el número de nanosecond con signo desde el Unix epoch 1970-01-01T00:00:00Z."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS es el número de nanosecond con signo desde el Unix epoch `1970-01-01T00:00:00Z`. Como los seconds-since-the-Epoch de POSIX, considera que todos los días tienen exactamente 86,400 segundos y no cuenta los leap second.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, número de Codec `0x00004000`. Familia TIME.
- Para el intercambio de datos industriales se usa el mismo tipo físico int64 con signo de ancho fijo que Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Número de Codec   2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretación y validez {#해석과-유효성}

- Los 4 WORD del Payload se leen en conjunto como un count con signo de 64 bit en complemento a dos, en orden de WORD big-endian.
- El rango válido es de `-2^63` a `2^63-1` ns, y el rango de instant es de `1677-09-21 00:12:43.145224192Z` a `2262-04-11 23:47:16.854775807Z`.
- Los valores pequeños también usan siempre 4 WORD. No se deben reducir a una representación entera mínima en WORD.
- No se incluyen timezone, UTC offset original, label de leap second ni leap-second table.

## Longitud {#길이}

- El total es exactamente 9 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 4 WORD, con longitud directa `LLLL=1000`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 4 WORD, se rechaza.

## Ejemplo {#예시}

- El epoch es el Payload `0000 0000 0000 0000`, 9 WORD en total, `LLLL=1000`.
- 1 ns después del epoch es el Payload `0000 0000 0000 0001`.
- 1 ns antes del epoch es el Payload `FFFF FFFF FFFF FFFF`.

## Base normativa {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) define los miembros `time_t tv_sec` y `long tv_nsec`, con `0 <= tv_nsec < 10^9`. El ancho concreto y la representación de `time_t` dependen del entorno de implementación, y no define un wire format int64 con signo del nanosecond acumulado que combine ambos miembros.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) considera que un día tiene exactamente 86,400 segundos.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` de [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) almacena los nanosecond desde el Unix epoch como un único `int64`. GEUL solo añade a este tipo físico el TAG y el framing en WORD big-endian de 16bit.
