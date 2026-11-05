---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 é um Value que representa um número racional por uma fração irredutível de numerator int64 e denominator int64 big-endian."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 é um Value que representa um número racional por uma fração irredutível de numerator int64 e denominator int64 big-endian. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x00000702`, família NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total de 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Interpretação e validade {#해석과-유효성}

- Cada int64 é um inteiro em complemento de dois de largura fixa, formado concatenando os WORD a partir do mais significativo, e o valor é `numerator / denominator`.
- Não há ABI padding.
- O Payload tem exatamente 8 WORD e o denominator deve ser positivo.
- Só se admite a forma irredutível com `gcd(|numerator|, denominator) = 1`. O 0 escreve-se somente como `0/1`.

## Estatuto formal {#형식-지위}

- Os dois int64, o denominator positivo, o máximo divisor comum 1 e a canonicalization `0/1` não adotam um padrão externo de wire; são um formato próprio do GEUL.
- Esta página define a representação por completo, incluindo a interpretação em complemento de dois de cada int64, a ordem dos componentes e o enquadramento em WORD big-endian.

## Comprimento {#길이}

- O total é exatamente 13 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 8 WORD, e usa-se o comprimento direto `LLLL=1100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 8 WORD, rejeita-se.

## Exemplo {#예시}

- Numerator `1` e denominator `2` formam o `1/2` válido. `2/4`, `0/2` e o denominator `-2` são invalid.
