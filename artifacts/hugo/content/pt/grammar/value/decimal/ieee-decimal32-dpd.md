---
title: "IEEE-DECIMAL32-DPD"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD é um Value fixo de 5 WORD que contém tal como está a sequência de bits de interchange IEEE 754 decimal32 DPD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD é o Value que representa a codificação de interchange IEEE 754 decimal32 DPD. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0040` IEEE, número de formato `0x2000`, família DECIMAL. Preserva tal como está o padrão de bits DPD e distingue-se de BID.

## Layout

```
TAG WORD          0x0A7C  total de 5 WORD
Issuer            1 WORD  0x0040 (IEEE)
Número de formato 1 WORD  0x2000
Payload           2 WORD (32 bits)  IEEE decimal32 DPD Interchange
```

## Interpretação

- As dois WORDs do Payload, concatenadas a partir da WORD superior, são lidas como a sequência de bits de interchange IEEE 754 decimal32 DPD.
- Preserva-se o padrão de bits e não se reinterpreta arbitrariamente como BID ou como SIGNED-DECIMAL.
- Não se normalizam arbitrariamente valores especiais nem payloads.

## Validade e comprimento

- O total é exatamente 5 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 2 WORD de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 2 WORD, rejeita-se.
- A validade semântica da sequência de bits segue as regras de interchange DPD do IEEE.

## Exemplo

| Estrutura | Julgamento |
|---|---|
| `0A7C 0040 2000` + 2 WORD de sequência de bits DPD | estrutura de comprimento canônica |
| `0A7C 0040 2000` + 4 WORD | invalid: largura do Payload não coincide |
| número de formato `0x2003` para os mesmos 32 bits | é o formato BID, não este tipo |

## Base normativa

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): aplica a codificação decimal (DPD) do coeficiente do formato de interchange decimal32. Não converte numericamente para a alternativa BID, permitida pelo IEEE, e preserva a codificação de 32 bits escolhida; o GEUL só acrescenta a TAG e o framing big-endian de WORD.
