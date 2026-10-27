---
title: "IEEE-DECIMAL64-BID"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-BID es un Value de 7 WORD fijos que contiene tal cual la cadena de bits de interchange BID de decimal64 de IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
IEEE-DECIMAL64-BID es un Value que representa la codificación de interchange BID de decimal64 de IEEE 754. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, número de formato `0x2004`, familia DECIMAL. Conserva tal cual el patrón de bits BID y lo distingue de DPD.

## Layout

```
TAG WORD          0x0B7C  7 WORD en total
Issuer            1 WORD  0x0040 (IEEE)
Número de formato 1 WORD  0x2004
Payload           4 WORD (64 bits)  IEEE decimal64 BID Interchange
```

## Interpretación

- Los cuatro WORD del Payload se leen, concatenados desde el WORD superior, como la cadena de bits de interchange BID de decimal64 de IEEE 754.
- Se conserva el patrón de bits y no se reinterpreta arbitrariamente como DPD ni como un formato exact decimal.
- Los valores especiales o el payload no se normalizan arbitrariamente.

## Validez y longitud

- El total es exactamente 7 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 4 WORD, y se usa la longitud directa `LLLL=0110`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 4 WORD, se rechaza.
- La validez semántica de la cadena de bits sigue las reglas de interchange BID de IEEE.

## Ejemplo

| Estructura | Veredicto |
|---|---|
| `0B7C 0040 2004` + 4 WORD de cadena de bits BID | estructura de longitud canónica |
| `0B7C 0040 2004` + 8 WORD | invalid: el ancho del Payload no coincide |
| Con los mismos 64 bits y el número de formato `0x2001` | es un formato DPD y no este tipo |

## Base estándar

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): se aplica el binary coefficient encoding (BID) del interchange format decimal64. No se convierte numéricamente a la alternativa DPD que admite IEEE, sino que se conserva la codificación de 64 bits elegida, y solo se añaden el TAG de GEUL y el framing de WORD big-endian.
