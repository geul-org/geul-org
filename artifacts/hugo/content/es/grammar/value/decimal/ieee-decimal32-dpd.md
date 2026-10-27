---
title: "IEEE-DECIMAL32-DPD"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD es un Value de 5 WORD fijos que contiene tal cual la cadena de bits de interchange DPD de decimal32 de IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
IEEE-DECIMAL32-DPD es un Value que representa la codificación de interchange DPD de decimal32 de IEEE 754. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, número de formato `0x2000`, familia DECIMAL. Conserva tal cual el patrón de bits DPD y lo distingue de BID.

## Layout

```
TAG WORD          0x0A7C  5 WORD en total
Issuer            1 WORD  0x0040 (IEEE)
Número de formato 1 WORD  0x2000
Payload           2 WORD (32 bits)  IEEE decimal32 DPD Interchange
```

## Interpretación

- Los dos WORD del Payload se leen, concatenados desde el WORD superior, como la cadena de bits de interchange DPD de decimal32 de IEEE 754.
- Se conserva el patrón de bits y no se reinterpreta arbitrariamente como BID ni como SIGNED-DECIMAL.
- Los valores especiales o el payload no se normalizan arbitrariamente.

## Validez y longitud

- El total es exactamente 5 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 2 WORD, y se usa la longitud directa `LLLL=0100`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 2 WORD, se rechaza.
- La validez semántica de la cadena de bits sigue las reglas de interchange DPD de IEEE.

## Ejemplo

| Estructura | Veredicto |
|---|---|
| `0A7C 0040 2000` + 2 WORD de cadena de bits DPD | estructura de longitud canónica |
| `0A7C 0040 2000` + 4 WORD | invalid: el ancho del Payload no coincide |
| Con los mismos 32 bits y el número de formato `0x2003` | es un formato BID y no este tipo |

## Base estándar

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): se aplica el decimal coefficient encoding (DPD) del interchange format decimal32. No se convierte numéricamente a la alternativa BID que admite IEEE, sino que se conserva la codificación de 32 bits elegida, y solo se añaden el TAG de GEUL y el framing de WORD big-endian.
