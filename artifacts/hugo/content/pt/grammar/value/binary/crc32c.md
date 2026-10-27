---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C é um formato fixo de 5 WORD do Issuer IETF que contém os 32 bits do resultado do CRC-32C de Castagnoli."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C é o Value de largura fixa que contém o resultado do CRC-32C. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0020` IETF, número de formato `0xC000`, família BINARY. O Payload tem exatamente 2 WORD (32 bits).

## Layout

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  total de 5 WORD
Issuer            1 WORD  0x0020 (IETF)
Número de formato 1 WORD  0xC000
Payload           2 WORD  CRC32C 16 bits superiores │ 16 bits inferiores
```

## Interpretação e validade

- Na notação de parâmetros de CRC, width 32, polinômio de Castagnoli `0x1EDC6F41`, refin/refout true, init `0xffffffff`, xorout `0xffffffff`.
- Guarda-se o inteiro unsigned de 32 bits resultante do cálculo em ordem de WORD big-endian. Essa serialização não é a disposição do campo Checksum do SCTP da RFC 3309 nem o próprio byte mapping do digest do iSCSI da RFC 3720.
- Se o Payload não tiver 2 WORD, rejeita-se.

## Base normativa

- O cálculo do CRC-32C e as regras do polinômio de Castagnoli e de reflexão seguem a definição de CRC32C da [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) e da [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- A TAG, o Length do GEUL e o framing de WORD big-endian de 16 bits do inteiro de 32 bits calculado são regras que este formato acrescenta.

## Comprimento

- O total é exatamente 5 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 2 WORD de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 2 WORD, rejeita-se.

## Exemplo

O check value do CRC-32C de ASCII `123456789`, `0xe3069283`:

```
0A7C 0020 C000 e306 9283
```
