---
title: "SHA3-256-DIGEST"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST es un formato Issuer NIST de 20 WORD fijos que contiene los 256 bits completos del resultado de SHA3-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
SHA3-256-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA3-256. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, número de formato `0xC001`, familia BINARY. El Payload es exactamente 16 WORD (256 bits) y no se admite el truncamiento.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG de extensión de Length   1 WORD  0x0014 (20 WORD en total)
Issuer            1 WORD  0x0062 (NIST)
Número de formato 1 WORD  0xC001
Payload           16 WORD  SHA3-256 Digest
```

## Interpretación y validez

- Los 32 octetos del Payload se leen en el orden de salida de SHA3-256. En cada WORD el octeto superior va primero.
- Al digest bit string no se le aplica por separado ninguna conversión de endian de GEUL. La secuencia de octetos de salida solo se agrupa en orden de dos en dos octetos y se encuadra en WORD big-endian de 16 bits.
- Se rechaza una representación cuyo Payload no sea de 16 WORD o que haya recortado arbitrariamente el resultado. No hay descriptor ni relleno.

## Base estándar

- El algoritmo SHA3-256 y el resultado de 256 bits siguen [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final) de NIST. El [proyecto Hash Functions](https://csrc.nist.gov/Projects/hash-functions) de NIST también presenta el estándar SHA-3.
- El framing de TAG, Length y WORD de 16 bits de GEUL es una regla que añade este formato y no forma parte del algoritmo SHA-3.

## Longitud

- El total es exactamente 20 WORD: TAG 1 WORD, TAG de extensión de Length 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 16 WORD, y se usa `LLLL=1110`. No hay descriptor ni relleno.
- Si el Payload no es exactamente de 16 WORD, se rechaza.

## Ejemplo

- Los octetos del digest desde `d[0]` hasta `d[31]` se colocan en los 16 WORD de Payload en el orden de salida, de dos en dos octetos. El Length total es siempre de 20 WORD.
