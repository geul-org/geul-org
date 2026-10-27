---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST es un formato Issuer de 20 WORD fijos que contiene los primeros 32 octetos de la salida del modo hash por defecto de BLAKE3."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
BLAKE3-256-DIGEST es un Value de ancho fijo que contiene los primeros 32 octetos (256 bits) de la salida del default hash mode de BLAKE3. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0xC000`, familia BINARY. El Payload es exactamente 16 WORD y no contiene salidas del keyed hash mode, del key derivation mode ni del XOF de otras longitudes.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG de extensión de Length   1 WORD  0x0014 (20 WORD en total)
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interpretación y validez

- El Payload son los primeros 32 octetos del output stream del default hash mode de BLAKE3. Se conserva el orden de salida y en cada WORD el octeto superior va primero.
- A la salida no se le aplica por separado ninguna conversión de endian de GEUL. La secuencia de octetos de salida se agrupa en orden de dos en dos octetos y se encuadra en WORD big-endian de 16 bits.
- Se rechaza una representación cuyo Payload no sea de 16 WORD o que contenga resultados de keyed_hash, derive_key o un XOF de otra longitud. No hay descriptor ni relleno.

## Base estándar

- La definición del algoritmo, de los modos y de la salida sigue el [repositorio de la implementación oficial](https://github.com/BLAKE3-team/BLAKE3) del equipo BLAKE3 y la [especificación de BLAKE3](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- El framing de TAG, Length y WORD de 16 bits de GEUL es una regla que añade este formato y no forma parte del algoritmo BLAKE3.

## Longitud

- El total es exactamente 20 WORD: TAG 1 WORD, TAG de extensión de Length 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 16 WORD, y se usa `LLLL=1110`. No hay descriptor ni relleno.
- Si el Payload no es exactamente de 16 WORD, se rechaza.

## Ejemplo

- Los octetos de salida desde `d[0]` hasta `d[31]` se colocan en los 16 WORD de Payload en el orden de salida, de dos en dos octetos. El Length total es siempre de 20 WORD.
