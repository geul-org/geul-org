---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C es un formato Issuer IETF de 5 WORD fijos que contiene los 32 bits del resultado del CRC-32C de Castagnoli."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
CRC32C es un Value de ancho fijo que contiene el resultado del CRC-32C. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, número de formato `0xC000`, familia BINARY. El Payload es exactamente 2 WORD (32 bits).

## Layout

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD en total
Issuer            1 WORD  0x0020 (IETF)
Número de formato 1 WORD  0xC000
Payload           2 WORD  CRC32C 16 bits superiores │ 16 bits inferiores
```

## Interpretación y validez

- En la notación de parámetros CRC: width 32, polinomio de Castagnoli `0x1EDC6F41`, refin/refout true, init `0xffffffff`, xorout `0xffffffff`.
- El entero unsigned de 32 bits resultante del cálculo se almacena en orden de WORD big-endian. Esta serialización no es la disposición del campo SCTP Checksum de RFC 3309 ni el mapeo de bytes del digest de iSCSI de RFC 3720.
- Si el Payload no es de 2 WORD, se rechaza.

## Base estándar

- El cálculo del CRC-32C y las reglas del polinomio de Castagnoli y de reflexión siguen la definición de CRC32C de [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) y [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- El framing de TAG, Length y WORD big-endian de 16 bits del entero de 32 bits calculado es una regla que añade este formato.

## Longitud

- El total es exactamente 5 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 2 WORD, y se usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 2 WORD, se rechaza.

## Ejemplo

El valor de comprobación del CRC-32C de ASCII `123456789`, `0xe3069283`:

```
0A7C 0020 C000 e306 9283
```
