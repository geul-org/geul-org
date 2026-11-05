---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST es un Value de ancho fijo que contiene los primeros 32 octet (256 bit) de la salida del default hash mode de BLAKE3."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST es un Value de ancho fijo que contiene los primeros 32 octet (256 bit) de la salida del default hash mode de BLAKE3. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x0000C000`, familia BINARY. El Payload es exactamente de 16 WORD y no contiene keyed hash mode, key derivation mode ni salidas XOF de otras longitudes.

## Layout {#레이아웃}

```
TAG WORD                  0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG extendida de Length   1 WORD  0x0016 (total 22 WORD)
Issuer                    2 WORD  0x00000002 (ADHOC)
Número de Codec           2 WORD  0x0000C000
Payload                   16 WORD  BLAKE3-256 Digest
```

## Interpretación y validez {#해석과-유효성}

- El Payload son los primeros 32 octet del output stream del default hash mode de BLAKE3. Se conserva el orden de salida y en cada WORD el octet más significativo va primero.
- No se aplica ninguna conversión de endian de GEUL a la salida. Los octet de salida se agrupan de dos en dos, en orden, y se enmarcan como WORD big-endian de 16bit.
- Se rechaza la representación cuyo Payload no sea de 16 WORD o que contenga el resultado de keyed_hash, derive_key o un XOF de otra longitud. No hay descriptor ni padding.

## Base normativa {#표준-근거}

- El algoritmo y la definición de modos y salida siguen el [repositorio de la implementación oficial](https://github.com/BLAKE3-team/BLAKE3) del equipo BLAKE3 y la [BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- El TAG, el Length y el framing en WORD de 16bit de GEUL son reglas que añade este formato y no forman parte del algoritmo BLAKE3.

## Longitud {#길이}

- El total es exactamente 22 WORD: TAG 1 WORD, TAG extendida de Length 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 16 WORD, con `LLLL=1110`. No hay descriptor ni padding.
- Si el Payload no es exactamente de 16 WORD, se rechaza.

## Ejemplo {#예시}

- Los octet de salida `d[0]` a `d[31]` se colocan en los 16 WORD del Payload en orden de salida, de dos en dos. El Length total es siempre de 22 WORD.
