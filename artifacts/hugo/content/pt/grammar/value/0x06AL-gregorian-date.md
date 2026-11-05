---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE é um número signed de dias que toma o dia 1970-01-01 do calendário gregoriano proléptico como day 0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `GREGORIAN-DATE` (BIND `GREGORIAN-DATE` do documento de especificação) |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| Documento de especificação | `0x00000000/codecs/0x000006A0/` (alvo do DECLARE `06A0`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 10 |
| Kind | Value · família: TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | número signed de dias a partir de `1970-01-01` do calendário gregoriano proléptico |
| Lado Hugo | `value/time/gregorian-date.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | valor bruto de 2 WORD |  |  |

GREGORIAN-DATE é um número signed de dias que toma `1970-01-01` do calendário gregoriano proléptico como day 0. Não guarda fuso horário nem hora do dia.

## Layout {#레이아웃}

- Código: direct code de Value `0x06AL`. Família TIME.
- Usa o mesmo tipo físico de largura fixa int32 signed que o Date32 do Arrow e o `DATE` do Parquet.

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  total 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Interpretação e validade {#해석과-유효성}

- As 2 WORD do Payload são lidas inteiras como um day count signed de 32 bits em complemento de dois, em ordem de WORD big-endian.
- O intervalo válido é de `-2^31` a `2^31-1` dias. Os negativos são datas anteriores ao epoch.
- Ao reconverter o day count em ano, mês e dia, usa-se o calendário gregoriano proléptico, sem transições históricas de calendário.
- Mesmo valores pequenos usam sempre 2 WORD.

## Comprimento {#길이}

- O total é exatamente 3 WORD, somando 1 WORD de TAG e 2 WORD de Payload, e usa o comprimento direto `LLLL=0010`. Não há TAG de extensão de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 2 WORD, é rejeitado.

## Exemplo {#예시}

| Data | Payload | Length total |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## Relação com o EDTF {#edtf와의-관계}

- Precisão mais grosseira que o dia, incerteza ou aproximação e intervalos são escritos com [EDTF](0x06EL-edtf.md). Uma data que pode ser escrita exatamente com GREGORIAN-DATE não se escreve em EDTF (forma canônica do EDTF).

## Base normativa {#표준-근거}

- O `DATE` do [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) é um `int32` que guarda o número de dias desde 1970-01-01, o Unix epoch, e usa a ordenação signed.
- O Date32 do [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) e do [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) de referência guarda o número de dias desde o Unix epoch como inteiro signed de 32 bits.
- A reconversão pelo calendário gregoriano proléptico é o calendar profile do GEUL adotado por este formato. Mantém-se o significado de day count int32 do Arrow/Parquet e acrescenta-se apenas o TAG e o enquadramento em WORD de 16 bits big-endian.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000006A0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
