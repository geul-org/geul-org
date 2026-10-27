---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE é o Value com o número de dias signed int32 que toma o proleptic Gregorian 1970-01-01 como dia 0 (Codec 0x20)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE é o número de dias signed que toma o proleptic Gregorian `1970-01-01` como dia 0. Não contém fuso horário nem hora do dia.

## Layout

- Código: código direto de Value `0x20`. Família TIME.
- Usa o mesmo tipo físico signed int32 de largura fixa que o Date32 do Arrow e o `DATE` do Parquet.

```
TAG WORD          0x0920 (0000 1001 0010 0000)  total de 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Interpretação e validade

- As 2 WORDs do Payload, na ordem de WORD big-endian, são lidas como um signed day count em complemento de dois de 32 bits.
- A faixa válida é `-2^31`~`2^31-1` dias. Um valor negativo é uma data anterior à epoch.
- Ao calcular ano, mês e dia a partir do day count, usa-se o calendário proleptic Gregorian, sem transições históricas de calendário.
- Mesmo um valor pequeno ocupa sempre 2 WORD.

## Comprimento

- O total é exatamente 3 WORD, a soma de 1 WORD de TAG e 2 WORD de Payload, e usa o comprimento direto `LLLL=0010`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 2 WORD, rejeita-se.

## Exemplo

| Data | Payload | Length total |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## Relação com EDTF

- Precisão mais grossa que o dia, incerto, aproximado e intervalos escrevem-se com [EDTF](/pt/grammar/value/time/edtf/). Uma data que se pode escrever exatamente como GREGORIAN-DATE não se escreve como EDTF (forma canônica do EDTF).

## Base normativa

- O `DATE` de [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) é um `int32` que guarda o número de dias desde 1970-01-01, a epoch Unix, com ordem signed.
- O Date32 do [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) e do [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo guarda o número de dias desde a epoch Unix como inteiro signed de 32 bits.
- O cálculo inverso proleptic Gregorian é o calendar profile do GEUL adotado por este formato. Mantém o significado de day-count int32 do Arrow/Parquet e só acrescenta a TAG e o framing de WORD de 16 bits big-endian.
