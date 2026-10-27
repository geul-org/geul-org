---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST é um Value fixo de 18 WORD que contém os 256 bits inteiros do resultado do SHA-256."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-256-DIGEST é o Value de largura fixa que contém o resultado inteiro do SHA-256, da família SHA-2. Código direto de Value `0x61`, família BINARY. O Payload tem exatamente 16 WORD (256 bits) e não se admite truncation.

## Layout

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
TAG estendida de Length   1 WORD  0x0012 (18 WORD no total)
Payload           16 WORD  SHA-256 Digest
```

## Interpretação e validade

- Os 32 octetos do Payload leem-se na mesma ordem da saída do SHA-256. Em cada WORD, o octeto superior vem primeiro.
- Não se aplica ao digest bit string nenhuma conversão de endian do GEUL. A sequência de octetos da saída apenas se agrupa de dois em dois, em ordem, no framing de WORD big-endian de 16 bits.
- Rejeita-se uma representação cujo Payload não tenha 16 WORD ou em que o resultado tenha sido cortado arbitrariamente. Não há descriptor nem padding.

## Base normativa

- O algoritmo SHA-256 e o resultado de 256 bits seguem o [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) do NIST.
- A TAG, o Length e o framing de WORD de 16 bits do GEUL são regras que este formato acrescenta e não fazem parte do algoritmo SHA-2.

## Comprimento

- O total é exatamente 18 WORD, a soma de 1 WORD de TAG, 1 WORD de TAG estendida de Length e 16 WORD de Payload, e usa `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não for exatamente 16 WORD, rejeita-se.

## Exemplo

- Os octetos do digest `d[0]` a `d[31]` põem-se em ordem nas WORDs do Payload, de `(d[0]<<8)|d[1]` a `(d[30]<<8)|d[31]`. O Length total é sempre de 18 WORD.
