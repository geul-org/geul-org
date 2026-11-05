---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT é o Value que representa um scalar de intercâmbio binário IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `BINARY-FLOAT` (BIND `BINARY-FLOAT` do documento de especificação) |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| Documento de especificação | `0x00000000/codecs/0x00000630/` (alvo do DECLARE `0630`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 3 |
| Kind | Value · família: NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | scalar IEEE 754 binary16/32/64/128 com Payload de 1/2/4/8 WORD |
| Lado Hugo | `value/numeric/binary-float.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | valor bruto restante (`0xFFFF`) |  |  |

BINARY-FLOAT é o Value que representa um scalar de intercâmbio binário IEEE 754. É o direct code de Value `0x063L`, família NUMERIC. Um Payload de 1/2/4/8 WORD corresponde a binary16/32/64/128, respectivamente. A cadeia de bits de intercâmbio é preservada tal qual e não se admitem outros tamanhos de Payload.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st  (WORD superior)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (WORD inferior)   IEEE Binary Interchange Nth
```

## Interpretação {#해석}

- As WORD do Payload são concatenadas em ordem big-endian e lidas como a cadeia de bits de intercâmbio binário IEEE 754 da largura correspondente.
- Os padrões de bits de intercâmbio são preservados, incluindo o payload de NaN e o zero com sinal.
- O decodificador não deve substituir um NaN por um NaN canônico qualquer nem apagar o sinal de um zero com sinal.
- O modo de arredondamento e o comportamento aritmético não são definidos por este formato de serialização.

## Comprimento {#길이}

O total é o número de WORD somando 1 WORD de TAG, o TAG de extensão de Length (se houver) e o Payload ([Registro e TAG WORD](../record.md)).

| Formato | Payload | Código de Length | TAG de extensão de Length | Length total |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | nenhum | 2 WORD |
| binary32 | 2 WORD | `0010` | nenhum | 3 WORD |
| binary64 | 4 WORD | `0100` | nenhum | 5 WORD |
| binary128 | 8 WORD | `1000` | nenhum | 9 WORD |

Como binary128 também está na faixa direta de 1 a 14 WORD, não usa TAG de extensão de Length.

## Validade {#유효성}

- O Payload tem exatamente 1, 2, 4 ou 8 WORD.
- Cada tamanho de Payload deve corresponder exatamente à representação de Length da tabela acima.
- Não se admitem recodificação que altere a largura nem WORD de padding antes ou depois do Payload.

## Exemplo {#예시}

| Formato | TAG | TAG de extensão de Length | Exemplo de Payload | Julgamento |
|---|---|---|---|---|
| binary16 | `0631` | nenhum | `0000` | canônico |
| binary32 | `0632` | nenhum | `0000 0000` | canônico |
| binary64 | `0634` | nenhum | `0000 0000 0000 0000` | canônico |
| binary128 | `0638` | nenhum | cadeia de bits de 8 WORD | canônico |
| qualquer | tamanho diferente do indicado pelo Length | qualquer | qualquer | invalid |

## Base normativa {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): aplica-se a codificação de intercâmbio de binary16, binary32, binary64 e binary128. O GEUL acrescenta a essa cadeia de bits apenas o TAG e o enquadramento em WORD de 16 bits big-endian.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000630/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
