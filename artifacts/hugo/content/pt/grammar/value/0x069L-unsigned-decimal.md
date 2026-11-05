---
title: "UNSIGNED-DECIMAL (0x069L)"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL é o Value de número decimal exato (exact decimal) com coefficient sem sinal."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `UNSIGNED-DECIMAL` (BIND `UNSIGNED-DECIMAL` do documento de especificação) |
| TAG ID | `0x069L` |
| Codec ID | `0x00000690` |
| Documento de especificação | `0x00000000/codecs/0x00000690/` (alvo do DECLARE `0690`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 9 |
| Kind | Value · família: DECIMAL |
| TAG WORD | `0000 0110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | `C×10^E` com um signed exponent `E` e um coefficient `C` unsigned com o mínimo de WORD |
| Lado Hugo | `value/decimal/unsigned-decimal.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | valor bruto de 2 WORD |  |  |
| 2 | `coefficient` | #3 | valor bruto restante (`0xFFFF`) |  |  |

UNSIGNED-DECIMAL é o Value de número decimal exato (exact decimal) com coefficient sem sinal. É o direct code de Value `0x069L`, família DECIMAL. As 2 primeiras WORD do Payload são o exponent decimal `E` signed de 32 bits e o restante é o coefficient `C` unsigned com o mínimo de WORD, e o valor é `C×10^E`.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 1001 LLLL      Codec 0x069L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st–2nd (32 bits)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD ou mais)  Unsigned Coefficient C
```

## Interpretação {#해석}

- `E` é um inteiro em complemento de dois big-endian signed de 32 bits, registrado a partir da WORD superior.
- `C` é uma magnitude unsigned de precisão arbitrária lida de todas as WORD restantes, a partir da WORD superior.
- `C` segue a mesma regra de mínimo de WORD de [UNSIGNED-INTEGER](0x062L-unsigned-integer.md). O 0 é `0000`, e com 2 WORD ou mais é proibido que a primeira WORD seja `0000`.

## Comprimento e validade {#길이와-유효성}

- O total é o número de WORD somando 1 WORD de TAG, o TAG de extensão de Length (se houver) e o Payload. Até 14 WORD usa-se o comprimento direto; a partir de 15 WORD usa-se o comprimento estendido `1110`·`1111`, e o TAG de extensão também entra no total ([Registro e TAG WORD](../record.md)).
- O Payload tem 2 WORD de exponent e 1 WORD ou mais de coefficient, portanto no mínimo 3 WORD.
- A canonicidade da representação em bytes verifica apenas a representação de coefficient com o mínimo de WORD.

## Exemplo {#예시}

| Representação do valor | Payload (`E` + `C`) | Julgamento |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | representação em bytes canônica |
| `10×10^-1` | `FFFF FFFF 000A` | representação em bytes canônica; a relação canonical com a representação acima é um problema em aberto |
| `1×10^0` | `0000 0000 0000 0001` | não canônico: `0000` inicial do coefficient desnecessário |
| coefficient negativo | não se aplica | invalid |

## Status de formato {#형식-지위}

- Esta disposição, que une o exponent `E` signed de 32 bits ao coefficient `C` unsigned com o mínimo de WORD, é um formato próprio do GEUL, e não o intercâmbio decimal IEEE 754 nem o `DECIMAL` do Apache Parquet.
- O `DECIMAL` do Parquet usa unscaled value signed, `unscaledValue × 10^(-scale)` e metadados obrigatórios de precision/scale, e o tipo físico byte-array é em complemento de dois big-endian, com scale maior ou igual a 0. Este formato não é o mesmo por ter `C` unsigned, `E` signed e não ter metadados de precision.
- Para trocar dados com o decimal IEEE 754 ou com o `DECIMAL` do Parquet, é necessária uma conversão explícita que defina sinal, intervalo, precision/scale, quantum e a política de valores especiais.
- Base de comparação: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Problemas em aberto {#열린-문제}

- Há vários pares exponent/coefficient que representam o mesmo número, como `10×10^-1` e `1×10^0`.
- Ainda não se definiu se este formato preserva o quantum, como se julga a igualdade de valores nem como se normaliza o exponent canonical.
- Por isso, uma implementação não deve impor arbitrariamente uma normalização de exponent/coefficient além da regra de mínimo de WORD do coefficient.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000690/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000069000000000
BODY
#1 DECLARE 0x0690
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "UNSIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
