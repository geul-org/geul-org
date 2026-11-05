---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS representa uma hora civil sem data como o número de nanosecond após a meia-noite."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `CIVIL-TIME-NANOSECONDS` (BIND `CIVIL-TIME-NANOSECONDS` do documento de especificação) |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| Documento de especificação | `0x00000000/codecs/0x000006B0/` (alvo do DECLARE `06B0`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 11 |
| Kind | Value · família: TIME |
| TAG WORD | `0000 0110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | contagem unsigned de nanosecond após a meia-noite do dia civil |
| Lado Hugo | `value/time/civil-time-nanoseconds.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | valor bruto de 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS representa uma hora civil sem data como o número de nanosecond após a meia-noite.

## Layout {#레이아웃}

- Código: direct code de Value `0x06BL`. Família TIME.
- Usa o mesmo tipo físico de largura fixa int64 signed que o `TIME(isAdjustedToUTC=false, unit=NANOS)` do Parquet.

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretação e validade {#해석과-유효성}

- As 4 WORD do Payload são lidas inteiras como uma contagem signed de 64 bits em complemento de dois, em ordem de WORD big-endian.
- O tipo físico é int64 signed, mas o intervalo válido é `0 <= value < 86,400×10^9` ns. Negativos e valores iguais ou superiores ao limite são rejeitados.
- `24:00` e labels de segundo intercalar não são admitidos. Também não guarda data, fuso horário nem UTC offset.
- Mesmo valores pequenos usam sempre 4 WORD.

## Comprimento {#길이}

- O total é exatamente 5 WORD, somando 1 WORD de TAG e 4 WORD de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG de extensão de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 4 WORD, é rejeitado.

## Exemplo {#예시}

- A meia-noite é o Payload `0000 0000 0000 0000`, total de 5 WORD, `LLLL=0100`.
- 1 ns após a meia-noite é o Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns é igual ao limite, portanto não é válido.
- `FFFF FFFF FFFF FFFF` é -1 como int64 signed, portanto não é válido.

## Base normativa {#표준-근거}

- O `TIME(isAdjustedToUTC=false, unit=NANOS)` do [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) guarda em um `int64` os nanosecond após a meia-noite da hora local e usa a ordenação signed.
- O [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html), em seu [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) de referência, define o Time NANOSECOND como inteiro signed de 64 bits, limita o intervalo válido a menos de 86.400 segundos a partir da meia-noite inclusive e não admite segundo intercalar. O GEUL acrescenta apenas o TAG e o enquadramento em WORD de 16 bits big-endian.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000006B0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
