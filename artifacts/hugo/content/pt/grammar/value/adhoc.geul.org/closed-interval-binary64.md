---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 é um Value que representa um intervalo fechado por dois endpoints IEEE 754 binary64, na ordem (lower, upper)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 é um Value que representa um intervalo fechado por dois endpoints IEEE 754 binary64, na ordem `(lower, upper)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x00000703`, família NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total de 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interpretação e validade {#해석과-유효성}

- Os dois endpoints são binary64 na ordem de WORD big-endian e incluem ambas as extremidades.
- O bit pattern do zero com sinal de um endpoint válido é preservado como está. Não há ABI padding.
- O Payload tem exatamente 8 WORD e deve valer `lower ≤ upper`.
- NaN não é comparável; portanto, rejeita-se. Um endpoint infinito também é rejeitado, pois resulta num intervalo unbounded.
- Intervalo empty, unbounded, open interval e NaI não podem ser representados por este formato e são rejeitados.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- O formato numérico dos endpoints segue o [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), e o sentido de par de endpoints fechado toma como referência o modelo de intervalo do [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) e do simplified flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- Este formato é um profile simples do GEUL que admite apenas intervalos fechados, finitos e não vazios. Não implementa nem serializa tal qual as decorations, o NaI, os intervalos empty/unbounded nem o modelo completo de operações e interchange do IEEE 1788/1788.1.

## Comprimento {#길이}

- O total é exatamente 13 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 8 WORD, e usa-se o comprimento direto `LLLL=1100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 8 WORD, rejeita-se.

## Exemplo {#예시}

- Os endpoints `(1.0, 2.0)` formam `[1.0, 2.0]` e são válidos. `(2.0, 1.0)` e `(NaN, 1.0)` são invalid.
