---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 é um formato fixo de 11 WORD do Issuer ADHOC que contém um número racional como fração irredutível de numerador int64 e denominador int64 positivo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 é o Value que representa um número racional como fração irredutível de um numerator int64 big-endian e um denominator int64. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x0702`, família NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total de 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interpretação e validade

- Cada int64 é um inteiro em complemento de dois de largura fixa, concatenado a partir da WORD superior, e o valor é `numerator / denominator`.
- Não há ABI padding.
- O Payload tem exatamente 8 WORD e o denominator deve ser positivo.
- Só se admite a forma irredutível com `gcd(|numerator|, denominator) = 1`. O 0 escreve-se apenas como `0/1`.

## Status do formato

- Os dois int64, o denominator positivo, o máximo divisor comum 1 e a canonicalization `0/1` não adotam uma norma externa de wire: são um formato próprio do GEUL.
- Esta página define a representação por completo, inclusive a interpretação em complemento de dois de cada int64, a ordem dos componentes e o framing de WORD big-endian.

## Comprimento

- O total é exatamente 11 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 8 WORD de Payload, e usa o comprimento direto `LLLL=1010`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 8 WORD, rejeita-se.

## Exemplo

- O numerator `1` e o denominator `2` são o `1/2` válido. `2/4`, `0/2` e o denominator `-2` são invalid.
