---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 es un Value que representa un número racional como fracción irreducible de un numerator int64 y un denominator int64 big-endian."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 es un Value que representa un número racional como fracción irreducible de un numerator int64 y un denominator int64 big-endian. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número de Codec `0x00000702`, familia NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Número de Codec   2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interpretación y validez {#해석과-유효성}

- Cada int64 es un entero de complemento a dos de ancho fijo, concatenado empezando por el WORD más significativo, y el valor es `numerator / denominator`.
- No hay ABI padding.
- El Payload es exactamente de 8 WORD y el denominator debe ser positivo.
- Solo se admite la forma irreducible con `gcd(|numerator|, denominator) = 1`. El 0 se escribe únicamente como `0/1`.

## Estatus del formato {#형식-지위}

- Los dos int64, el denominator positivo, el máximo común divisor 1 y la canonicalization `0/1` no adoptan un wire standard externo, sino que son un formato propio de GEUL.
- Esta página define por completo la representación, incluidas la interpretación en complemento a dos de cada int64, el orden de los componentes y el framing en WORD big-endian.

## Longitud {#길이}

- El total es exactamente 13 WORD: TAG 1 WORD, Issuer 2 WORD, número de Codec 2 WORD y Payload 8 WORD, con longitud directa `LLLL=1100`. No hay TAG extendida de Length, descriptor ni padding.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Ejemplo {#예시}

- El numerator `1` con denominator `2` es el `1/2` válido. `2/4`, `0/2` y el denominator `-2` son invalid.
