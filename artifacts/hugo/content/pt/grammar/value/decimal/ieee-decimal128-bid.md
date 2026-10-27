---
title: "IEEE-DECIMAL128-BID"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-BID é um Value fixo de 11 WORD que contém tal como está a sequência de bits de interchange IEEE 754 decimal128 BID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-BID é o Value que representa a codificação de interchange IEEE 754 decimal128 BID. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0040` IEEE, número de formato `0x2005`, família DECIMAL. Preserva tal como está o padrão de bits BID e distingue-se de DPD.

## Layout

```
TAG WORD          0x0D7C  total de 11 WORD
Issuer            1 WORD  0x0040 (IEEE)
Número de formato 1 WORD  0x2005
Payload           8 WORD (128 bits)  IEEE decimal128 BID Interchange
```

## Interpretação

- As oito WORDs do Payload, concatenadas a partir da WORD superior, são lidas como a sequência de bits de interchange IEEE 754 decimal128 BID.
- Preserva-se o padrão de bits e não se reinterpreta arbitrariamente como DPD ou como formato de decimal exato.
- Não se normalizam arbitrariamente valores especiais nem payloads.

## Validade e comprimento

- O total é exatamente 11 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 8 WORD de Payload, e usa o comprimento direto `LLLL=1010`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 8 WORD, rejeita-se.
- A validade semântica da sequência de bits segue as regras de interchange BID do IEEE.

## Exemplo

| Estrutura | Julgamento |
|---|---|
| `0D7C 0040 2005` + 8 WORD de sequência de bits BID | canônico |
| total diferente de 11 WORD (`LLLL=1010`) | invalid: não coincide com a largura fixa do Payload |

## Base normativa

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): aplica a codificação binária do coeficiente (BID) do formato de interchange decimal128. Não converte numericamente para a alternativa DPD, permitida pelo IEEE, e preserva a codificação de 128 bits escolhida; o GEUL só acrescenta a TAG e o framing big-endian de WORD.
