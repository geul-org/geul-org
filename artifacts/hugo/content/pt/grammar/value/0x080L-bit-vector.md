---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR é uma raw bit sequence com o comprimento declarado."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR é uma raw bit sequence com o comprimento declarado. Código direto de Value `0x080L`, família BINARY. Os 2 primeiros WORDs do Payload são o bit count `N`, um inteiro unsigned de 32 bits, e depois vêm `ceil(N/16)` WORDs.

| Item | Valor |
|---|---|
| Nome | `BIT-VECTOR` (BIND do documento de especificação `BIT-VECTOR`) |
| TAG ID | `0x080L` |
| Codec ID | `0x00000800` |
| Documento de especificação | `0x00000000/codecs/0x00000800/` (alvo de DECLARE `0800`) |
| Seção | 4 `0100` (Value), deslocamento C dentro da seção = 0 |
| Kind | Value · família: BINARY |
| TAG WORD | `0000 1000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | N bits armazenados em MSB-first depois do bit-count |
| Lado Hugo | `value/binary/bit-vector.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | valor bruto de 2 WORDs |  |  |
| 2 | `bits` | #3 | restante, valor bruto (`0xFFFF`) |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st–2nd       Bit Count N (16 bits altos │ 16 bits baixos)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Interpretação e validade {#해석과-유효성}

- `N` é o valor obtido ao ler os 2 primeiros WORDs do Payload como inteiro unsigned de 32 bits em big-endian.
- Os bits do payload são preenchidos em ordem, a partir do bit mais significativo de cada WORD.
- O número de WORDs do payload é exatamente `ceil(N/16)`, e os bits baixos não usados do último WORD devem ser todos 0.
- Se `N=0`, não há WORDs de payload. Como os dois WORDs de count já formam o Payload, não há conflito com a regra do mínimo de 1 WORD de Payload.

## Situação do formato {#형식-지위}

- O bit count unsigned de 32 bits, a disposição MSB-first e o zero padding do último WORD não citam um padrão industrial externo, mas são framing próprio de GEUL.
- Esta página define a representação, incluindo as regras de TAG, Length e WORD de 16 bits de GEUL.

## Comprimento {#길이}

- O total é 1 WORD de TAG mais o número de WORDs da TAG de extensão de Length (se houver) e do Payload. Até 14 WORD usa-se o comprimento direto; com 15 WORD ou mais, o comprimento estendido `1110`·`1111`, e a TAG de extensão também entra no total ([Registro e TAG WORD](../record.md)).

## Exemplo {#예시}

- Um bit vector vazio tem count `0000 0000`, nenhum payload, 3 WORDs no total, `LLLL=0010`. O total é `0802 0000 0000`.
- A bit sequence `101` tem count `0000 0003`, payload `A000`, 4 WORDs no total, `LLLL=0011`. O total é `0803 0000 0003 A000`.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000800/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
