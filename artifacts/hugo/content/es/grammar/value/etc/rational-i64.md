---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 es un formato Issuer ADHOC de 11 WORD fijos que contiene un número racional como fracción irreducible de un numerador int64 y un denominador int64 positivo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
RATIONAL-I64 es un Value que representa un número racional como fracción irreducible de un int64 numerator big-endian y un int64 denominator. Es un Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, número de formato `0x0702`, familia NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD en total
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interpretación y validez

- Cada int64 es un entero en complemento a dos de ancho fijo, concatenando desde el WORD superior, y el valor es `numerator / denominator`.
- No hay ABI padding.
- El Payload es exactamente de 8 WORD y el denominator debe ser positivo.
- Solo se admite la forma irreducible con `gcd(|numerator|, denominator) = 1`. El 0 se escribe únicamente como `0/1`.

## Estatus del formato

- Los dos int64, el denominator positivo, el máximo común divisor 1 y la canonicalization de `0/1` no adoptan un estándar wire externo, sino que son un formato propio de GEUL.
- Esta página define por completo la representación, incluidas la interpretación en complemento a dos de cada int64, el orden de los componentes y el framing en WORD big-endian.

## Longitud

- El total es exactamente 11 WORD: TAG 1 WORD, Issuer 1 WORD, número de formato 1 WORD y Payload 8 WORD, y se usa la longitud directa `LLLL=1010`. No hay TAG de extensión de Length, descriptor ni relleno.
- Si el Payload no es exactamente de 8 WORD, se rechaza.

## Ejemplo

- El numerator `1` y el denominator `2` son el `1/2` válido. `2/4`, `0/2` y el denominator `-2` son invalid.
