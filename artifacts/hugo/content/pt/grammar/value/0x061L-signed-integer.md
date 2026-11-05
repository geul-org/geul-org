---
title: "SIGNED-INTEGER (0x061L)"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER é o Value que representa um valor inteiro com sinal."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `SIGNED-INTEGER` (BIND `SIGNED-INTEGER` do documento de especificação) |
| TAG ID | `0x061L` |
| Codec ID | `0x00000610` |
| Documento de especificação | `0x00000000/codecs/0x00000610/` (alvo do DECLARE `0610`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 1 |
| Kind | Value · família: NUMERIC |
| TAG WORD | `0000 0110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | inteiro com sinal em complemento de dois com o mínimo de WORD |
| Lado Hugo | `value/numeric/signed-integer.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `integer` | #2 | valor bruto restante (`0xFFFF`) |  |  |

SIGNED-INTEGER é o Value que representa um valor inteiro com sinal. É o direct code de Value `0x061L`, família NUMERIC. O Payload inteiro é lido como um inteiro em complemento de dois de precisão arbitrária, em ordem de WORD big-endian. O Payload tem no mínimo 1 WORD e só se admite a representação canônica com o mínimo de WORD.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0001 LLLL      Codec 0x061L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st  (WORD superior)   Integer 1st
...
Payload WORD Nth  (WORD inferior)   Integer Nth
```

## Interpretação {#해석}

- O bit mais significativo da primeira WORD do Payload é o bit de sinal do inteiro.
- Todas as WORD do Payload são lidas como uma única cadeia contínua de bits em complemento de dois. A primeira WORD é a posição mais alta e a última WORD é a posição mais baixa.
- Se o Payload tem N WORD, a largura de interpretação é de `16N` bits. Essa largura não é uma largura de armazenamento declarada, mas a largura de representação do valor, determinada pela forma canônica.
- Não há Byte Count nem descriptor de largura em bits.

## Representação canônica {#정규-표현}

- O 0 é o Payload de 1 WORD `0000`.
- WORD iniciais de extensão de sinal que não alteram o valor são proibidas.
- Quando o Payload tem 2 WORD ou mais, os casos a seguir são não canônicos.
  - A primeira WORD é `0000` e o bit mais significativo da WORD seguinte é 0
  - A primeira WORD é `FFFF` e o bit mais significativo da WORD seguinte é 1
- Um `0000` inicial que preserva o sinal de um número positivo é admitido quando o bit mais significativo da WORD seguinte é 1.
- Um `FFFF` inicial que preserva o sinal de um número negativo é admitido quando o bit mais significativo da WORD seguinte é 0.
- O decodificador deve rejeitar representações não canônicas.

## Comprimento {#길이}

- O total é o número de WORD somando 1 WORD de TAG, o TAG de extensão de Length (se houver) e o Payload. Até 14 WORD usa-se o comprimento direto; a partir de 15 WORD usa-se o comprimento estendido `1110`·`1111`, e o TAG de extensão também entra no total ([Registro e TAG WORD](../record.md)).
- Larguras declaradas como INT8, INT16 e INT32 não são preservadas; preserva-se apenas o valor numérico. `-32768` a `32767` ocupam 1 WORD e, fora desse intervalo, acrescentam-se as WORD necessárias. Não existe um formato SIGNED-INT8 separado.

## Exemplo {#예시}

| Valor | WORD do Payload | Julgamento |
|---:|---|---|
| 0 | `0000` | canônico |
| 1 | `0001` | canônico |
| 32767 | `7FFF` | canônico |
| 32768 | `0000 8000` | canônico: o `0000` é necessário para preservar o sinal positivo |
| -1 | `FFFF` | canônico |
| -32768 | `8000` | canônico |
| -32769 | `FFFF 7FFF` | canônico: o `FFFF` é necessário para preservar o sinal negativo |
| 1 | `0000 0001` | não canônico: `0000` inicial desnecessário |
| -1 | `FFFF FFFF` | não canônico: `FFFF` inicial desnecessário |

## Status de formato {#형식-지위}

- O complemento de dois é uma convenção amplamente usada, mas esta representação, que normaliza um valor de precisão arbitrária em uma sequência de WORD de no mínimo 16 bits e a une ao TAG do GEUL, é um scalar profile próprio do GEUL.
- Ao trocar dados com tipos externos de largura fixa, como INT8/16/32/64, são necessárias verificação de intervalo e conversão explícita de largura.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000610/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000061000000000
BODY
#1 DECLARE 0x0610
#2 FIELD #1 rest
#3 BIND #1 "SIGNED-INTEGER"
#4 BIND #2 "integer"
```
