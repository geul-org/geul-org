---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS es un Value que contiene una hora civil sin fecha como el número de nanosegundos desde la medianoche (Codec 0x21)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
CIVIL-TIME-NANOSECONDS representa una hora civil sin fecha como el número de nanosegundos desde la medianoche.

## Layout

- Código: código directo de Value `0x21`. Familia TIME.
- Usa el mismo tipo físico signed int64 de ancho fijo que `TIME(isAdjustedToUTC=false, unit=NANOS)` de Parquet.

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  5 WORD en total
Payload WORD 1.º (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2.º (bits 47..32)     Signed Nanoseconds
Payload WORD 3.º (bits 31..16)     Signed Nanoseconds
Payload WORD 4.º (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretación y validez

- Los 4 WORD completos del Payload se leen como un count signed en complemento a dos de 64 bits en orden de WORD big-endian.
- El tipo físico es signed int64, pero el rango válido es `0 <= value < 86,400×10^9` ns. Los negativos y los valores iguales o superiores al límite se rechazan.
- No se admiten `24:00` ni etiquetas de segundo intercalar. Tampoco contiene fecha, zona horaria ni UTC offset.
- Aunque el valor sea pequeño, siempre se usan 4 WORD.

## Longitud

- El total es exactamente 5 WORD: TAG 1 WORD y Payload 4 WORD, y se usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 4 WORD, se rechaza.

## Ejemplo

- La medianoche es el Payload `0000 0000 0000 0000`, 5 WORD en total, `LLLL=0100`.
- 1 ns después de la medianoche es el Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns es igual al límite, por lo que no es válido.
- `ffff ffff ffff ffff` es -1 como signed int64, por lo que no es válido.

## Base estándar

- `TIME(isAdjustedToUTC=false, unit=NANOS)` de [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) almacena en un `int64` los nanosegundos de una hora local desde la medianoche y usa el orden signed.
- [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs), autoritativo en [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html), define Time NANOSECOND como un entero signed de 64 bits, limita el rango válido a menos de 86.400 segundos incluida la medianoche y no admite segundos intercalares. GEUL solo añade el TAG y el framing en WORD big-endian de 16 bits.
