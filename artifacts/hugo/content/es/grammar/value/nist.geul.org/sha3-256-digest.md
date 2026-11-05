---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA3-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA3-256. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, número de Codec `0x0000C001`, familia BINARY. El Payload es exactamente de 16 WORD (256 bit) y no se admite el truncamiento (truncation).

## Layout {#레이아웃}

```
TAG WORD                  0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG extendida de Length   1 WORD  0x0016 (total 22 WORD)
Issuer                    2 WORD  0x00000015 (NIST)
Número de Codec           2 WORD  0x0000C001
Payload                   16 WORD  SHA3-256 Digest
```

## Interpretación y validez {#해석과-유효성}

- Los 32 octet del Payload se leen en el mismo orden de salida de SHA3-256. En cada WORD el octet más significativo va primero.
- No se aplica ninguna conversión de endian de GEUL al digest bit string. Los octet de salida simplemente se agrupan de dos en dos, en orden, y se enmarcan como WORD big-endian de 16bit.
- Se rechaza la representación cuyo Payload no sea de 16 WORD o cuyo resultado se haya recortado arbitrariamente. No hay descriptor ni padding.

## Base normativa {#표준-근거}

- El algoritmo SHA3-256 y el resultado de 256bit siguen [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final) de NIST. El [proyecto Hash Functions](https://csrc.nist.gov/Projects/hash-functions) de NIST también presenta el estándar SHA-3.
- El TAG, el Length y el framing en WORD de 16bit de GEUL son reglas que añade este formato y no forman parte del algoritmo SHA-3.

## Longitud {#길이}

- El total es exactamente 22 WORD: TAG 1 WORD, TAG extendida de Length 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 16 WORD, con `LLLL=1110`. No hay descriptor ni padding.
- Si el Payload no es exactamente de 16 WORD, se rechaza.

## Ejemplo {#예시}

- Los octet del digest `d[0]` a `d[31]` se colocan en los 16 WORD del Payload en orden de salida, de dos en dos. El Length total es siempre de 22 WORD.
