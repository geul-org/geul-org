---
title: "IEEE-DECIMAL128-DPD"
weight: 1026
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD é um Value que representa o interchange encoding DPD do decimal128 do IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD é um Value que representa o interchange encoding DPD do decimal128 do IEEE 754. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, número do Codec `0x00002002`, família DECIMAL. Preserva tal qual o bit pattern DPD e o distingue do BID.

## Layout {#레이아웃}

```
TAG WORD          0x09DC  total de 13 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Número do Codec   2 WORD  0x00002002
Payload           8 WORD (128 bits)  IEEE decimal128 DPD Interchange
```

## Interpretação {#해석}

- Os 8 WORD do Payload, concatenados a partir do mais significativo, são lidos como a cadeia de bits de interchange DPD do decimal128 do IEEE 754.
- Preservam-se os bit patterns; não se reinterpreta arbitrariamente como BID nem como decimal exato (exact decimal).
- Valores especiais e payloads não são normalizados arbitrariamente.

## Validade e comprimento {#유효성과-길이}

- O total é exatamente 13 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 8 WORD, e usa-se o comprimento direto `LLLL=1100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 8 WORD, rejeita-se.
- A validade semântica da cadeia de bits segue as regras de interchange DPD do IEEE.

## Exemplo {#예시}

| Estrutura | Veredicto |
|---|---|
| `09DC 0000 000D 0000 2002` + 8 WORD de bits DPD | canônico |
| O total não é de 13 WORD (`LLLL=1100`) | invalid: a largura fixa do Payload não coincide |

## Base normativa {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): aplica-se o decimal coefficient encoding (DPD) do interchange format decimal128. Preserva-se o encoding de 128 bits escolhido, sem conversão numérica para a alternativa BID permitida pelo IEEE, e o GEUL apenas acrescenta a TAG e o enquadramento em WORD big-endian.
