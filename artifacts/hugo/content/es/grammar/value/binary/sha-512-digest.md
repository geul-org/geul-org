---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST es un formato Issuer NIST de 36 WORD fijos que contiene los 512 bits completos del resultado de SHA-512."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
SHA-512-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA-512, de la familia SHA-2. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, número de formato `0xC000`, familia BINARY. El Payload es exactamente 32 WORD (512 bits) y no se admite el truncamiento.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG de extensión de Length   1 WORD  0x0024 (36 WORD en total)
Issuer            1 WORD  0x0062 (NIST)
Número de formato 1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## Interpretación y validez

- Los 64 octetos del Payload se leen en el orden de salida de SHA-512. En cada WORD el octeto superior va primero.
- Al digest bit string no se le aplica por separado ninguna conversión de endian de GEUL. La secuencia de octetos de salida solo se agrupa en orden de dos en dos octetos y se encuadra en WORD big-endian de 16 bits.
- Se rechaza una representación cuyo Payload no sea de 32 WORD o que haya recortado arbitrariamente el resultado. No hay descriptor ni relleno.

## Base estándar

- El algoritmo SHA-512 y el resultado de 512 bits siguen [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) de NIST.
- El framing de TAG, Length y WORD de 16 bits de GEUL es una regla que añade este formato y no forma parte del algoritmo SHA-2.

## Longitud

- El total es exactamente 36 WORD: TAG 1 WORD, TAG de extensión de Length 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 32 WORD, y se usa `LLLL=1110`. No hay descriptor ni relleno.
- Si el Payload no es exactamente de 32 WORD, se rechaza.

## Ejemplo

- Los octetos del digest desde `d[0]` hasta `d[63]` se colocan en orden en los WORD de Payload, desde `(d[0]<<8)|d[1]` hasta `(d[62]<<8)|d[63]`. El Length total es siempre de 36 WORD.
