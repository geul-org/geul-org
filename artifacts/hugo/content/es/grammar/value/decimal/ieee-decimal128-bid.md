---
title: "IEEE-DECIMAL128-BID"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-BID es un Value de 11 WORD fijos que contiene tal cual la cadena de bits de interchange BID de decimal128 de IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
IEEE-DECIMAL128-BID es un Value que representa la codificación de interchange BID de decimal128 de IEEE 754. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, número de formato `0x2005`, familia DECIMAL. Conserva tal cual el patrón de bits BID y lo distingue de DPD.

## Layout

```
TAG WORD          0x0D7C  11 WORD en total
Issuer            1 WORD  0x0040 (IEEE)
Número de formato 1 WORD  0x2005
Payload           8 WORD (128 bits)  IEEE decimal128 BID Interchange
```

## Interpretación

- Los ocho WORD del Payload se leen, concatenados desde el WORD superior, como la cadena de bits de interchange BID de decimal128 de IEEE 754.
- Se conserva el patrón de bits y no se reinterpreta arbitrariamente como DPD ni como un formato exact decimal.
- Los valores especiales o el payload no se normalizan arbitrariamente.

## Validez y longitud

- El total es exactamente 11 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 8 WORD, y se usa la longitud directa `LLLL=1010`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 8 WORD, se rechaza.
- La validez semántica de la cadena de bits sigue las reglas de interchange BID de IEEE.

## Ejemplo

| Estructura | Veredicto |
|---|---|
| `0D7C 0040 2005` + 8 WORD de cadena de bits BID | canónica |
| El total no es de 11 WORD (`LLLL=1010`) | invalid: no coincide con el ancho fijo del Payload |

## Base estándar

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): se aplica el binary coefficient encoding (BID) del interchange format decimal128. No se convierte numéricamente a la alternativa DPD que admite IEEE, sino que se conserva la codificación de 128 bits elegida, y solo se añaden el TAG de GEUL y el framing de WORD big-endian.
