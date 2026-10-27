---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR é um formato Issuer do GEUL que contém, depois de um número de bits N de 32 bits, N bits em MSB-first."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR é uma raw bit sequence com o comprimento declarado. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0000` GEUL, número de formato `0xC002`, família BINARY. As 2 primeiras WORDs do Payload são o bit count `N` unsigned de 32 bits, seguidas de `ceil(N/16)` WORD.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Issuer            1 WORD  0x0000 (GEUL)
Número de formato 1 WORD  0xC002
Payload WORD 1st–2nd       Bit Count N (16 bits superiores │ 16 bits inferiores)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Interpretação e validade

- `N` é o valor lido nas 2 primeiras WORDs do Payload como inteiro unsigned de 32 bits big-endian.
- Os bits do payload preenchem-se em sequência a partir do bit mais significativo de cada WORD.
- O número de WORDs do payload é exatamente `ceil(N/16)`, e todos os bits inferiores não usados da última WORD devem ser 0.
- Se `N=0`, não há WORD de payload. Como as duas WORDs de count já formam o Payload, não entra em conflito com a regra do mínimo de 1 WORD de Payload.

## Status do formato

- O bit count unsigned de 32 bits, a disposição MSB-first e o zero padding da última WORD não citam uma norma industrial externa: são um framing próprio do GEUL.
- Esta página define a representação, inclusive as regras de TAG, Length e WORD de 16 bits do GEUL.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver), 1 WORD de Issuer, 1 WORD de número de formato e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Registro e TAG WORD](/pt/grammar/record/)).

## Exemplo

- O bit vector vazio tem count `0000 0000`, nenhum payload, 5 WORD no total, `LLLL=0100`.
- A sequência de bits `101` tem count `0000 0003`, payload `a000`, 6 WORD no total, `LLLL=0101`.
