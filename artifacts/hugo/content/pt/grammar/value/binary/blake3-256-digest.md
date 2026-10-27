---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST é um formato Issuer fixo de 20 WORD que contém os primeiros 32 octetos da saída do modo hash padrão do BLAKE3."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST é o Value de largura fixa que contém os primeiros 32 octetos (256 bits) da saída do default hash mode do BLAKE3. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0xC000`, família BINARY. O Payload tem exatamente 16 WORD e não contém keyed hash mode, key derivation mode nem saídas XOF de outros comprimentos.

## Layout

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG estendida de Length   1 WORD  0x0014 (20 WORD no total)
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## Interpretação e validade

- O Payload são os primeiros 32 octetos do output stream do default hash mode do BLAKE3. Preserva-se a ordem da saída e, em cada WORD, o octeto superior vem primeiro.
- Não se aplica à saída nenhuma conversão de endian do GEUL. A sequência de octetos da saída agrupa-se de dois em dois, em ordem, no framing de WORD big-endian de 16 bits.
- Rejeita-se uma representação cujo Payload não tenha 16 WORD ou que contenha o resultado de keyed_hash, derive_key ou XOF de outro comprimento. Não há descriptor nem padding.

## Base normativa

- A definição do algoritmo, dos modos e da saída segue o [repositório oficial de implementação](https://github.com/BLAKE3-team/BLAKE3) da equipe BLAKE3 e a [especificação do BLAKE3](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- A TAG, o Length e o framing de WORD de 16 bits do GEUL são regras que este formato acrescenta e não fazem parte do algoritmo BLAKE3.

## Comprimento

- O total é exatamente 20 WORD, a soma de 1 WORD de TAG, 1 WORD de TAG estendida de Length, 1 WORD de Issuer, 1 WORD de número de formato e 16 WORD de Payload, e usa `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não for exatamente 16 WORD, rejeita-se.

## Exemplo

- Os octetos de saída `d[0]` a `d[31]` põem-se nas 16 WORDs do Payload, dois octetos por vez, na ordem da saída. O Length total é sempre de 20 WORD.
