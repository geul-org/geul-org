---
title: "SIGNED-INTEGER"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER é o Value que contém um inteiro com sinal em complemento de dois no mínimo de WORDs."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-INTEGER é o Value que representa um valor inteiro com sinal. Código direto de Value `0x01`, família NUMERIC. O Payload inteiro é lido como um inteiro em complemento de dois de precisão arbitrária, em ordem de WORD big-endian. O Payload tem no mínimo 1 WORD e só se admite a representação canônica de menor número de WORDs.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x01
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st  (WORD superior)   Integer 1st
...
Payload WORD Nth  (WORD inferior)   Integer Nth
```

## Interpretação

- O bit mais significativo da primeira WORD do Payload é o bit de sinal do inteiro todo.
- Todas as WORDs do Payload são lidas como uma sequência contínua de bits em complemento de dois. A primeira WORD é a casa mais alta e a última WORD é a casa mais baixa.
- Se o Payload tem N WORD, a largura de interpretação é de `16N` bits. Essa largura não é uma largura de armazenamento declarada, e sim a largura de representação do valor determinada pela representação canônica.
- Não há Byte Count nem bit width descriptor.

## Representação canônica

- O 0 é 1 WORD de Payload `0000`.
- São proibidas WORDs iniciais de extensão de sinal que não mudem o valor.
- Quando o Payload tem 2 WORD ou mais, são não canônicos os seguintes casos.
  - A primeira WORD é `0000` e o bit mais significativo da WORD seguinte é 0
  - A primeira WORD é `ffff` e o bit mais significativo da WORD seguinte é 1
- Um `0000` inicial que preserva o sinal de um positivo é permitido quando o bit mais significativo da WORD seguinte é 1.
- Um `ffff` inicial que preserva o sinal de um negativo é permitido quando o bit mais significativo da WORD seguinte é 0.
- O decodificador deve rejeitar as representações não canônicas.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver) e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Registro e TAG WORD](/pt/grammar/record/)).
- Larguras declaradas como INT8, INT16 e INT32 não se preservam: só se preserva o valor numérico. De `-32768` a `32767` é 1 WORD, e fora dessa faixa acrescentam-se as WORDs necessárias. Não existe um formato SIGNED-INT8 separado.

## Exemplo

| Valor | WORDs do Payload | Julgamento |
|---:|---|---|
| 0 | `0000` | canônico |
| 1 | `0001` | canônico |
| 32767 | `7fff` | canônico |
| 32768 | `0000 8000` | canônico: `0000` é necessário para preservar o sinal positivo |
| -1 | `ffff` | canônico |
| -32768 | `8000` | canônico |
| -32769 | `ffff 7fff` | canônico: `ffff` é necessário para preservar o sinal negativo |
| 1 | `0000 0001` | não canônico: `0000` inicial desnecessário |
| -1 | `ffff ffff` | não canônico: `ffff` inicial desnecessário |

## Status do formato

- O complemento de dois é uma convenção amplamente usada, mas esta representação, que normaliza um valor de precisão arbitrária numa sequência de WORDs de 16 bits no mínimo e a une à TAG do GEUL, é um scalar profile próprio do GEUL.
- Ao trocar com tipos externos de largura fixa, como INT8/16/32/64, são necessárias verificação de faixa e conversão explícita de largura.
