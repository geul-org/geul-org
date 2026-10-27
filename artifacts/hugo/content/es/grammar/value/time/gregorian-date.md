---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE es un Value con el número de días como signed int32 con el proleptic Gregorian 1970-01-01 como day 0 (Codec 0x20)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
GREGORIAN-DATE es un número de días con signo con el proleptic Gregorian `1970-01-01` como day 0. No contiene zona horaria ni hora del día.

## Layout

- Código: código directo de Value `0x20`. Familia TIME.
- Usa el mismo tipo físico signed int32 de ancho fijo que Date32 de Arrow y `DATE` de Parquet.

```
TAG WORD          0x0920 (0000 1001 0010 0000)  3 WORD en total
Payload WORD 1.º (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2.º (bits 15..0)      Signed Day Count low 16bit
```

## Interpretación y validez

- Los 2 WORD completos del Payload se leen como un day count signed en complemento a dos de 32 bits en orden de WORD big-endian.
- El rango válido es `-2^31`~`2^31-1` días. Un negativo es una fecha anterior al epoch.
- Al calcular a la inversa año, mes y día a partir del day count, se usa el proleptic Gregorian calendar, sin transiciones históricas de calendario.
- Aunque el valor sea pequeño, siempre se usan 2 WORD.

## Longitud

- El total es exactamente 3 WORD: TAG 1 WORD y Payload 2 WORD, y se usa la longitud directa `LLLL=0010`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 2 WORD, se rechaza.

## Ejemplo

| Fecha | Payload | Length total |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## Relación con EDTF

- Las precisiones más gruesas que el día, la incertidumbre·aproximación y los intervalos se escriben con [EDTF](/es/grammar/value/time/edtf/). Una fecha que se pueda escribir exactamente con GREGORIAN-DATE no se escribe con EDTF (forma canónica de EDTF).

## Base estándar

- `DATE` de [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) es un `int32` que almacena el número de días desde 1970-01-01, el Unix epoch, y usa el orden signed.
- Date32 de [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) y de su [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo almacena el número de días desde el Unix epoch como un entero signed de 32 bits.
- El cálculo inverso proleptic Gregorian es el calendar profile de GEUL que adopta este formato. Se mantiene tal cual el significado de day-count int32 de Arrow/Parquet y solo se añaden el TAG y el framing en WORD big-endian de 16 bits.
