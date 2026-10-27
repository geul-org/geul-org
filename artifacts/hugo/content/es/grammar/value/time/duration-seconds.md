---
title: "DURATION-SECONDS"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS es un Value que contiene un tiempo transcurrido en segundos, signed int64 sin epoch (Codec 0x23)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
DURATION-SECONDS es un tiempo transcurrido en segundos con signo y sin epoch. No es un instant ni una duración de meses o años del calendario.

## Layout

- Código: código directo de Value `0x23`. Familia TIME.
- Usa el mismo tipo físico signed int64 de ancho fijo que `Duration(SECOND)` de Arrow.

```
TAG WORD          0x0A23 (0000 1010 0010 0011)  5 WORD en total
Payload WORD 1.º (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2.º (bits 47..32)     Signed Seconds
Payload WORD 3.º (bits 31..16)     Signed Seconds
Payload WORD 4.º (bits 15..0)      Signed Seconds low 16bit
```

## Interpretación y validez

- Los 4 WORD completos del Payload se leen como un count signed en complemento a dos de 64 bits en orden de WORD big-endian.
- El rango válido es `-2^63`~`2^63-1` segundos. El signo es la dirección del transcurso y no apunta a un instant de un epoch concreto.
- Aunque el valor sea pequeño, siempre se usan 4 WORD.

## Longitud

- El total es exactamente 5 WORD: TAG 1 WORD y Payload 4 WORD, y se usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 4 WORD, se rechaza.

## Ejemplo

- 0 segundos es el Payload `0000 0000 0000 0000`, 5 WORD en total, `LLLL=0100`.
- 1 segundo es el Payload `0000 0000 0000 0001`.
- -1 segundo es el Payload `ffff ffff ffff ffff`.

## Base estándar

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designa `Schema.fbs` como la fuente autoritativa de los tipos de datos estándar de Arrow.
- En el [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo de Arrow, `Duration` es un tiempo transcurrido absoluto independiente del calendario, admite la unidad SECOND y siempre se representa como un entero signed de 8 bytes. GEUL solo añade el TAG y el framing en WORD big-endian de 16 bits.
