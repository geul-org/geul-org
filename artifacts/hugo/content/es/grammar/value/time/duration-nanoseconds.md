---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS es un Value que contiene un tiempo transcurrido en nanosegundos, signed int64 sin epoch (formato Issuer de GEUL 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
DURATION-NANOSECONDS es un tiempo transcurrido en nanosegundos con signo y sin epoch. No es un instant ni una duración de meses o años del calendario.

## Layout

- Código: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, número de formato `0x4000`. Familia TIME.
- Usa el mismo tipo físico signed int64 de ancho fijo que `Duration(NANOSECOND)` de Arrow.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD en total
Issuer            1 WORD  0x0000 (GEUL)
Número de formato 1 WORD  0x4000
Payload WORD 1.º (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2.º (bits 47..32)     Signed Nanoseconds
Payload WORD 3.º (bits 31..16)     Signed Nanoseconds
Payload WORD 4.º (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretación y validez

- Los 4 WORD completos del Payload se leen como un count signed en complemento a dos de 64 bits en orden de WORD big-endian.
- El rango válido es `-2^63`~`2^63-1` ns. El signo es la dirección del transcurso y no apunta a un instant de un epoch concreto.
- Aunque el valor sea pequeño, siempre se usan 4 WORD.

## Longitud

- El total es exactamente 7 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 4 WORD, y se usa la longitud directa `LLLL=0110`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 4 WORD, se rechaza.

## Ejemplo

- 0 ns es el Payload `0000 0000 0000 0000`, 7 WORD en total, `LLLL=0110`.
- 1 ns es el Payload `0000 0000 0000 0001`.
- -1 ns es el Payload `ffff ffff ffff ffff`.

## Base estándar

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designa `Schema.fbs` como la fuente autoritativa de los tipos de datos estándar de Arrow.
- En el [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo de Arrow, `Duration` es un tiempo transcurrido absoluto independiente del calendario, admite la unidad NANOSECOND y siempre se representa como un entero signed de 8 bytes. GEUL solo añade el TAG y el framing en WORD big-endian de 16 bits.
