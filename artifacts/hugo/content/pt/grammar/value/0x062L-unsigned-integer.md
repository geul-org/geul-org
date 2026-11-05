---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER é o Value que representa um valor inteiro sem sinal."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `UNSIGNED-INTEGER` (BIND `UNSIGNED-INTEGER` do documento de especificação) |
| TAG ID | `0x062L` |
| Codec ID | `0x00000620` |
| Documento de especificação | `0x00000000/codecs/0x00000620/` (alvo do DECLARE `0620`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 2 |
| Kind | Value · família: NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | inteiro de magnitude unsigned big-endian com o mínimo de WORD |
| Lado Hugo | `value/numeric/unsigned-integer.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | valor bruto restante (`0xFFFF`) |  |  |

UNSIGNED-INTEGER é o Value que representa um valor inteiro sem sinal. É o direct code de Value `0x062L`, família NUMERIC. O Payload inteiro é lido como uma magnitude unsigned de precisão arbitrária, em ordem de WORD big-endian. O Payload tem no mínimo 1 WORD e só se admite a representação canônica com o mínimo de WORD.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st  (WORD superior)   Unsigned Magnitude 1st
...
Payload WORD Nth  (WORD inferior)   Unsigned Magnitude Nth
```

## Interpretação {#해석}

- A primeira WORD do Payload é a posição mais alta e a última WORD é a posição mais baixa.
- Se o Payload tem N WORD, é lido como uma única magnitude unsigned de `16N` bits.
- Essa largura não é uma largura de armazenamento declarada e não há descriptor de largura em bits.

## Representação canônica {#정규-표현}

- O 0 é o Payload de 1 WORD `0000`.
- Quando o Payload tem 2 WORD ou mais e a primeira WORD é `0000`, a representação é não canônica, pois removê-la mantém o mesmo valor.
- O decodificador deve rejeitar representações com WORD zero iniciais desnecessárias.

## Comprimento {#길이}

- O total é o número de WORD somando 1 WORD de TAG, o TAG de extensão de Length (se houver) e o Payload. Até 14 WORD usa-se o comprimento direto; a partir de 15 WORD usa-se o comprimento estendido `1110`·`1111`, e o TAG de extensão também entra no total ([Registro e TAG WORD](../record.md)).
- Larguras declaradas como UINT8, UINT16 e UINT32 não são preservadas; preserva-se apenas o valor numérico.

## Exemplo {#예시}

| Valor | WORD do Payload | Julgamento |
|---:|---|---|
| 0 | `0000` | canônico |
| 1 | `0001` | canônico |
| 65535 | `FFFF` | canônico |
| 65536 | `0001 0000` | canônico |
| 1 | `0000 0001` | não canônico: `0000` inicial desnecessário |
| Payload de 7 WORD | as 7 WORD após o TAG `0627` (comprimento direto `LLLL=0111`, total de 8 WORD) | canônico |
| Payload de 7 WORD | as 7 WORD após o TAG de comprimento estendido e o valor de extensão `0009` | não canônico: até 14 WORD usa-se o comprimento direto |

## Status de formato {#형식-지위}

- Esta representação, que normaliza uma magnitude unsigned de precisão arbitrária em uma sequência de WORD de no mínimo 16 bits e a une ao TAG do GEUL, é um scalar profile próprio do GEUL.
- Ao trocar dados com tipos externos de largura fixa, como UINT8/16/32/64, são necessárias verificação de intervalo e conversão explícita de largura.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000620/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
