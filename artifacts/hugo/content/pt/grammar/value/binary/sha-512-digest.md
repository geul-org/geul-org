---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST é um formato fixo de 36 WORD do Issuer NIST que contém os 512 bits inteiros do resultado do SHA-512."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST é o Value de largura fixa que contém o resultado inteiro do SHA-512, da família SHA-2. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0062` NIST, número de formato `0xC000`, família BINARY. O Payload tem exatamente 32 WORD (512 bits) e não se admite truncation.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG estendida de Length   1 WORD  0x0024 (36 WORD no total)
Issuer            1 WORD  0x0062 (NIST)
Número de formato 1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## Interpretação e validade

- Os 64 octetos do Payload leem-se na mesma ordem da saída do SHA-512. Em cada WORD, o octeto superior vem primeiro.
- Não se aplica ao digest bit string nenhuma conversão de endian do GEUL. A sequência de octetos da saída apenas se agrupa de dois em dois, em ordem, no framing de WORD big-endian de 16 bits.
- Rejeita-se uma representação cujo Payload não tenha 32 WORD ou em que o resultado tenha sido cortado arbitrariamente. Não há descriptor nem padding.

## Base normativa

- O algoritmo SHA-512 e o resultado de 512 bits seguem o [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) do NIST.
- A TAG, o Length e o framing de WORD de 16 bits do GEUL são regras que este formato acrescenta e não fazem parte do algoritmo SHA-2.

## Comprimento

- O total é exatamente 36 WORD, a soma de 1 WORD de TAG, 1 WORD de TAG estendida de Length, 1 WORD de Issuer, 1 WORD de número de formato e 32 WORD de Payload, e usa `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não for exatamente 32 WORD, rejeita-se.

## Exemplo

- Os octetos do digest `d[0]` a `d[63]` põem-se em ordem nas WORDs do Payload, de `(d[0]<<8)|d[1]` a `(d[62]<<8)|d[63]`. O Length total é sempre de 36 WORD.
