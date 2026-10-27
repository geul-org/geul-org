---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST es un Value de 18 WORD fijos que contiene los 256 bits completos del resultado de SHA-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
SHA-256-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA-256, de la familia SHA-2. Es el código directo de Value `0x61`, familia BINARY. El Payload es exactamente 16 WORD (256 bits) y no se admite el truncamiento.

## Layout

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
TAG de extensión de Length   1 WORD  0x0012 (18 WORD en total)
Payload           16 WORD  SHA-256 Digest
```

## Interpretación y validez

- Los 32 octetos del Payload se leen en el orden de salida de SHA-256. En cada WORD el octeto superior va primero.
- Al digest bit string no se le aplica por separado ninguna conversión de endian de GEUL. La secuencia de octetos de salida solo se agrupa en orden de dos en dos octetos y se encuadra en WORD big-endian de 16 bits.
- Se rechaza una representación cuyo Payload no sea de 16 WORD o que haya recortado arbitrariamente el resultado. No hay descriptor ni relleno.

## Base estándar

- El algoritmo SHA-256 y el resultado de 256 bits siguen [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) de NIST.
- El framing de TAG, Length y WORD de 16 bits de GEUL es una regla que añade este formato y no forma parte del algoritmo SHA-2.

## Longitud

- El total es exactamente 18 WORD: TAG 1 WORD, TAG de extensión de Length 1 WORD y Payload 16 WORD, y se usa `LLLL=1110`. No hay descriptor ni relleno.
- Si el Payload no es exactamente de 16 WORD, se rechaza.

## Ejemplo

- Los octetos del digest desde `d[0]` hasta `d[31]` se colocan en orden en los WORD de Payload, desde `(d[0]<<8)|d[1]` hasta `(d[30]<<8)|d[31]`. El Length total es siempre de 18 WORD.
