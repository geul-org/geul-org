---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C es un Value de ancho fijo que contiene el resultado de CRC-32C."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C es un Value de ancho fijo que contiene el resultado de CRC-32C. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, número de Codec `0x0000C000`, familia BINARY. El Payload es exactamente de 2 WORD (32 bit).

## Layout {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  total 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Número de Codec   2 WORD  0x0000C000
Payload           2 WORD  CRC32C 16bit superiores │ 16bit inferiores
```

## Interpretación y validez {#해석과-유효성}

- En la notación de parámetros CRC: width 32, polinomio de Castagnoli `0x1EDC6F41`, refin/refout true, init `0xFFFFFFFF`, xorout `0xFFFFFFFF`.
- El entero unsigned de 32bit resultante del cálculo se almacena en orden de WORD big-endian. Esta serialización no es en sí la disposición del Checksum field de SCTP de RFC 3309 ni el byte mapping del digest de iSCSI de RFC 3720.
- Si el Payload no es de 2 WORD, se rechaza.

## Base normativa {#표준-근거}

- El cálculo de CRC-32C y el polinomio de Castagnoli y las reglas de reflexión siguen la definición de CRC32C de [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) y [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- El TAG y el Length de GEUL y el framing en WORD big-endian de 16bit del entero de 32bit calculado son reglas que añade este formato.

## Longitud {#길이}

- El total es exactamente 7 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 2 WORD, con longitud directa `LLLL=0110`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 2 WORD, se rechaza.

## Ejemplo {#예시}

El check value CRC-32C `0xE3069283` de ASCII `123456789`:

```
09D6 0000 0007 0000 C000 E306 9283
```
