---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 é um formato fixo de 11 WORD do Issuer ADHOC que contém um intervalo fechado finito e não vazio por limites inferior e superior binary64."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 é o Value que representa um intervalo fechado por dois endpoints IEEE 754 binary64 na ordem `(lower, upper)`. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x0703`, família NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total de 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interpretação e validade

- Os dois endpoints são binary64 em ordem de WORD big-endian e incluem as duas extremidades.
- O padrão de bits do zero com sinal de um endpoint válido é preservado tal como está. Não há ABI padding.
- O Payload tem exatamente 8 WORD e deve ter `lower ≤ upper`.
- Como o NaN não é comparável, rejeita-se. Um endpoint infinito também é rejeitado, pois seria um intervalo unbounded.
- Empty, unbounded, intervalos abertos e NaI não se podem representar com este formato e são rejeitados.

## Base normativa e status do formato

- O formato numérico dos endpoints segue o [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), e o significado de par de endpoints fechado consulta o modelo de interval do [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) e do [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734), o simplified flavor.
- Este formato é um profile simples do GEUL que só admite intervalos fechados finitos e não vazios. Não implementa nem serializa tal qual as decorations, o NaI, os intervalos empty/unbounded nem o modelo completo de operações e interchange do IEEE 1788/1788.1.

## Comprimento

- O total é exatamente 11 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 8 WORD de Payload, e usa o comprimento direto `LLLL=1010`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 8 WORD, rejeita-se.

## Exemplo

- Os endpoints `(1.0, 2.0)` são `[1.0, 2.0]` e válidos. `(2.0, 1.0)` e `(NaN, 1.0)` são invalid.
