---
title: "SIGNED-DECIMAL"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL é o Value que contém o decimal exato C×10^E com um expoente E signed de 32 bits e um coeficiente C em complemento de dois no mínimo de WORDs."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-DECIMAL é o Value de decimal exato (exact decimal) com coeficiente com sinal. Código direto de Value `0x10`, família DECIMAL. As 2 primeiras WORDs do Payload são o exponent decimal `E` signed de 32 bits, e o restante é o coeficiente `C` em complemento de dois no mínimo de WORDs, e o valor é `C×10^E`.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x10
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st–2nd (32 bits)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD ou mais)  Signed Two's-complement Coefficient C
```

## Interpretação

- `E` é um inteiro em complemento de dois big-endian signed de 32 bits, escrito a partir da WORD superior.
- `C` é um inteiro em complemento de dois de precisão arbitrária, formado por todas as WORDs restantes concatenadas a partir da WORD superior.
- `C` segue a mesma regra de mínimo de WORDs de [SIGNED-INTEGER](/pt/grammar/value/numeric/signed-integer/). São proibidas as WORDs iniciais `0000` ou `ffff` que podem ser apagadas.

## Comprimento e validade

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver) e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Registro e TAG WORD](/pt/grammar/record/)).
- Como o Payload tem 2 WORD de exponent e 1 WORD ou mais de coeficiente, o mínimo é de 3 WORD.
- A canonicidade da representação em bytes só confere a representação de menor número de WORDs do coeficiente.

## Exemplo

| Representação do valor | Payload (`E` + `C`) | Julgamento |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | representação em bytes canônica |
| `10×10^-1` | `ffff ffff 000a` | representação em bytes canônica; a relação canônica com a representação acima é uma questão em aberto |
| `1×10^0` | `0000 0000 0000 0001` | não canônica: `0000` inicial do coeficiente desnecessário |
| Payload de 7 WORD | comprimento direto `LLLL=0111`, 8 WORD no total | estrutura de comprimento canônica |

## Status do formato

- Esta disposição, que une o exponent `E` signed de 32 bits e o coeficiente `C` de mínimo de WORDs, é um formato próprio do GEUL, e não um decimal interchange do IEEE 754 nem o `DECIMAL` do Apache Parquet.
- O `DECIMAL` do Parquet usa `unscaledValue × 10^(-scale)` e metadados obrigatórios de precision/scale, guarda o unscaled value do tipo físico byte-array em complemento de dois big-endian, e o scale é 0 ou maior. Este formato põe o `E` signed no corpo e não tem metadados de precision, por isso não é o mesmo formato.
- Para trocar com o decimal do IEEE 754 ou com o `DECIMAL` do Parquet, é necessária uma conversão explícita que defina a faixa, precision/scale, quantum e a política de valores especiais.
- Base de comparação: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Questões em aberto

- Há vários pares exponent/coeficiente que representam o mesmo número, como `10×10^-1` e `1×10^0`.
- Ainda não se definiu se este formato preserva o quantum, como se julga a equivalência de valor e como se normaliza o exponent canônico.
- Por isso a implementação não deve impor arbitrariamente uma normalização de exponent/coeficiente fora da regra de mínimo de WORDs do coeficiente.
