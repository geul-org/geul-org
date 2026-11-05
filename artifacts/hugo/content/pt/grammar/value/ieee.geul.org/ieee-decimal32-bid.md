---
title: "IEEE-DECIMAL32-BID"
weight: 1027
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-BID é um Value que representa o interchange encoding BID do decimal32 do IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-BID é um Value que representa o interchange encoding BID do decimal32 do IEEE 754. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, número do Codec `0x00002003`, família DECIMAL. Preserva tal qual o bit pattern BID e o distingue do DPD.

## Layout {#레이아웃}

```
TAG WORD          0x09D6  total de 7 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Número do Codec   2 WORD  0x00002003
Payload           2 WORD (32 bits)  IEEE decimal32 BID Interchange
```

## Interpretação {#해석}

- Os 2 WORD do Payload, concatenados a partir do mais significativo, são lidos como a cadeia de bits de interchange BID do decimal32 do IEEE 754.
- Preservam-se os bit patterns; não se reinterpreta arbitrariamente como DPD nem como SIGNED-DECIMAL.
- Valores especiais e payloads não são normalizados arbitrariamente.

## Validade e comprimento {#유효성과-길이}

- O total é exatamente 7 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 2 WORD, e usa-se o comprimento direto `LLLL=0110`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 2 WORD, rejeita-se.
- A validade semântica da cadeia de bits segue as regras de interchange BID do IEEE.

## Exemplo {#예시}

| Estrutura | Veredicto |
|---|---|
| `09D6 0000 000D 0000 2003` + 2 WORD de bits BID | estrutura de comprimento canônica |
| `09D6 0000 000D 0000 2003` + 4 WORD | invalid: largura do Payload não coincide |
| O mesmo valor de 32 bits com número do Codec `0x00002000` | é o formato DPD e não este tipo |

## Base normativa {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): aplica-se o binary coefficient encoding (BID) do interchange format decimal32. Preserva-se o encoding de 32 bits escolhido, sem conversão numérica para a alternativa DPD permitida pelo IEEE, e o GEUL apenas acrescenta a TAG e o enquadramento em WORD big-endian.
