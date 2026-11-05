---
title: "IEEE-DECIMAL32-DPD"
weight: 1028
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD es un Value que representa el interchange encoding DPD de decimal32 de IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD es un Value que representa el interchange encoding DPD de decimal32 de IEEE 754. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, número de Codec `0x00002000`, familia DECIMAL. Conserva tal cual el bit pattern DPD y se distingue de BID.

## Layout {#레이아웃}

```
TAG WORD          0x09D6  total 7 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Número de Codec   2 WORD  0x00002000
Payload           2 WORD (32bit)  IEEE decimal32 DPD Interchange
```

## Interpretación {#해석}

- Los dos WORD del Payload se leen, concatenados empezando por el WORD más significativo, como la cadena de bit del interchange DPD de decimal32 de IEEE 754.
- Se conserva el bit pattern y no se reinterpreta arbitrariamente como BID ni como SIGNED-DECIMAL.
- Los valores especiales y el payload no se normalizan arbitrariamente.

## Validez y longitud {#유효성과-길이}

- El total es exactamente 7 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 2 WORD, con longitud directa `LLLL=0110`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 2 WORD, se rechaza.
- La validez semántica de la cadena de bit sigue las reglas de interchange DPD de IEEE.

## Ejemplo {#예시}

| Estructura | Veredicto |
|---|---|
| `09D6 0000 000D 0000 2000` + cadena de bit DPD de 2 WORD | estructura de longitud canónica |
| `09D6 0000 000D 0000 2000` + 4 WORD | invalid: el ancho del Payload no coincide |
| Los mismos 32 bit con el número de Codec `0x00002003` | es el formato BID y no este tipo |

## Base normativa {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): se aplica el decimal coefficient encoding (DPD) del interchange format decimal32. No se convierte numéricamente a la alternativa BID que IEEE permite, sino que se conserva el encoding de 32bit elegido, y GEUL solo añade el TAG y el framing en WORD big-endian.
