---
title: "SHA3-256-DIGEST"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST é um formato fixo de 20 WORD do Issuer NIST que contém os 256 bits inteiros do resultado do SHA3-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST é o Value de largura fixa que contém o resultado inteiro do SHA3-256. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0062` NIST, número de formato `0xC001`, família BINARY. O Payload tem exatamente 16 WORD (256 bits) e não se admite truncation.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG estendida de Length   1 WORD  0x0014 (20 WORD no total)
Issuer            1 WORD  0x0062 (NIST)
Número de formato 1 WORD  0xC001
Payload           16 WORD  SHA3-256 Digest
```

## Interpretação e validade

- Os 32 octetos do Payload leem-se na mesma ordem da saída do SHA3-256. Em cada WORD, o octeto superior vem primeiro.
- Não se aplica ao digest bit string nenhuma conversão de endian do GEUL. A sequência de octetos da saída apenas se agrupa de dois em dois, em ordem, no framing de WORD big-endian de 16 bits.
- Rejeita-se uma representação cujo Payload não tenha 16 WORD ou em que o resultado tenha sido cortado arbitrariamente. Não há descriptor nem padding.

## Base normativa

- O algoritmo SHA3-256 e o resultado de 256 bits seguem o [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final) do NIST. O [projeto Hash Functions](https://csrc.nist.gov/Projects/hash-functions) do NIST também apresenta o padrão SHA-3.
- A TAG, o Length e o framing de WORD de 16 bits do GEUL são regras que este formato acrescenta e não fazem parte do algoritmo SHA-3.

## Comprimento

- O total é exatamente 20 WORD, a soma de 1 WORD de TAG, 1 WORD de TAG estendida de Length, 1 WORD de Issuer, 1 WORD de número de formato e 16 WORD de Payload, e usa `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não for exatamente 16 WORD, rejeita-se.

## Exemplo

- Os octetos do digest `d[0]` a `d[31]` põem-se nas 16 WORDs do Payload, dois octetos por vez, na ordem da saída. O Length total é sempre de 20 WORD.
