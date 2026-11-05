---
title: "IEEE-DECIMAL128-DPD"
weight: 1026
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD es un Value que representa el interchange encoding DPD de decimal128 de IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD es un Value que representa el interchange encoding DPD de decimal128 de IEEE 754. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, número de Codec `0x00002002`, familia DECIMAL. Conserva tal cual el bit pattern DPD y se distingue de BID.

## Layout {#레이아웃}

```
TAG WORD          0x09DC  total 13 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Número de Codec   2 WORD  0x00002002
Payload           8 WORD (128bit)  IEEE decimal128 DPD Interchange
```

## Interpretación {#해석}

- Los ocho WORD del Payload se leen, concatenados empezando por el WORD más significativo, como la cadena de bit del interchange DPD de decimal128 de IEEE 754.
- Se conserva el bit pattern y no se reinterpreta arbitrariamente como BID ni como un formato decimal exacto.
- Los valores especiales y el payload no se normalizan arbitrariamente.

## Validez y longitud {#유효성과-길이}

- El total es exactamente 13 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 8 WORD, con longitud directa `LLLL=1100`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 8 WORD, se rechaza.
- La validez semántica de la cadena de bit sigue las reglas de interchange DPD de IEEE.

## Ejemplo {#예시}

| Estructura | Veredicto |
|---|---|
| `09DC 0000 000D 0000 2002` + cadena de bit DPD de 8 WORD | canónica |
| El total no es de 13 WORD (`LLLL=1100`) | invalid: no coincide con el ancho fijo del Payload |

## Base normativa {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): se aplica el decimal coefficient encoding (DPD) del interchange format decimal128. No se convierte numéricamente a la alternativa BID que IEEE permite, sino que se conserva el encoding de 128bit elegido, y GEUL solo añade el TAG y el framing en WORD big-endian.
