---
title: "SHA-512-DIGEST"
weight: 1039
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA-512 de la familia SHA-2."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST es un Value de ancho fijo que contiene el resultado completo de SHA-512 de la familia SHA-2. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000015` NIST, número de Codec `0x0000C000`, familia BINARY. El Payload es exactamente de 32 WORD (512 bit) y no se admite el truncamiento (truncation).

## Layout {#레이아웃}

```
TAG WORD                  0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG extendida de Length   1 WORD  0x0026 (total 38 WORD)
Issuer                    2 WORD  0x00000015 (NIST)
Número de Codec           2 WORD  0x0000C000
Payload                   32 WORD  SHA-512 Digest
```

## Interpretación y validez {#해석과-유효성}

- Los 64 octet del Payload se leen en el mismo orden de salida de SHA-512. En cada WORD el octet más significativo va primero.
- No se aplica ninguna conversión de endian de GEUL al digest bit string. Los octet de salida simplemente se agrupan de dos en dos, en orden, y se enmarcan como WORD big-endian de 16bit.
- Se rechaza la representación cuyo Payload no sea de 32 WORD o cuyo resultado se haya recortado arbitrariamente. No hay descriptor ni padding.

## Base normativa {#표준-근거}

- El algoritmo SHA-512 y el resultado de 512bit siguen [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) de NIST.
- El TAG, el Length y el framing en WORD de 16bit de GEUL son reglas que añade este formato y no forman parte del algoritmo SHA-2.

## Longitud {#길이}

- El total es exactamente 38 WORD: TAG 1 WORD, TAG extendida de Length 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 32 WORD, con `LLLL=1110`. No hay descriptor ni padding.
- Si el Payload no es exactamente de 32 WORD, se rechaza.

## Ejemplo {#예시}

- Los octet del digest `d[0]` a `d[63]` se colocan en orden como los WORD del Payload desde `(d[0]<<8)|d[1]` hasta `(d[62]<<8)|d[63]`. El Length total es siempre de 38 WORD.
