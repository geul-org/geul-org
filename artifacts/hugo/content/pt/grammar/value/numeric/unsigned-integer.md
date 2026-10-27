---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER é o Value que contém um inteiro sem sinal como magnitude big-endian no mínimo de WORDs."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER é o Value que representa um valor inteiro sem sinal. Código direto de Value `0x02`, família NUMERIC. O Payload inteiro é lido como uma magnitude sem sinal de precisão arbitrária, em ordem de WORD big-endian. O Payload tem no mínimo 1 WORD e só se admite a representação canônica de menor número de WORDs.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st  (WORD superior)   Unsigned Magnitude 1st
...
Payload WORD Nth  (WORD inferior)   Unsigned Magnitude Nth
```

## Interpretação

- A primeira WORD do Payload é a casa mais alta e a última WORD é a casa mais baixa.
- Se o Payload tem N WORD, lê-se como uma única magnitude sem sinal de `16N` bits.
- Essa largura não é uma largura de armazenamento declarada e não há bit width descriptor.

## Representação canônica

- O 0 é 1 WORD de Payload `0000`.
- Quando o Payload tem 2 WORD ou mais, se a primeira WORD for `0000` é não canônico, pois apagá-la deixa o valor igual.
- O decodificador deve rejeitar as representações com WORD zero inicial desnecessária.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver) e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Registro e TAG WORD](/pt/grammar/record/)).
- Larguras declaradas como UINT8, UINT16 e UINT32 não se preservam: só se preserva o valor numérico.

## Exemplo

| Valor | WORDs do Payload | Julgamento |
|---:|---|---|
| 0 | `0000` | canônico |
| 1 | `0001` | canônico |
| 65535 | `ffff` | canônico |
| 65536 | `0001 0000` | canônico |
| 1 | `0000 0001` | não canônico: `0000` inicial desnecessário |
| Payload de 7 WORD | TAG `0b82` (comprimento direto `LLLL=0111`, 8 WORD no total) seguida de 7 WORD | canônico |
| Payload de 7 WORD | TAG de comprimento estendido e valor estendido `0009`, seguidos de 7 WORD | não canônico: até 14 WORD usa-se o comprimento direto |

## Status do formato

- Esta representação, que normaliza uma magnitude sem sinal de precisão arbitrária numa sequência de WORDs de 16 bits no mínimo e a une à TAG do GEUL, é um scalar profile próprio do GEUL.
- Ao trocar com tipos externos de largura fixa, como UINT8/16/32/64, são necessárias verificação de faixa e conversão explícita de largura.
