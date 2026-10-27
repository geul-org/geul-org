---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS é o Value que contém uma hora civil sem data como número de nanosegundos desde a meia-noite (Codec 0x21)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS representa uma hora civil sem data como o número de nanosegundos (nanosecond) desde a meia-noite.

## Layout

- Código: código direto de Value `0x21`. Família TIME.
- Usa o mesmo tipo físico signed int64 de largura fixa que `TIME(isAdjustedToUTC=false, unit=NANOS)` do Parquet.

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  total de 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretação e validade

- As 4 WORDs do Payload, na ordem de WORD big-endian, são lidas como um signed count em complemento de dois de 64 bits.
- O tipo físico é signed int64, mas a faixa válida é `0 <= value < 86,400×10^9` ns. Rejeitam-se negativos e valores iguais ou maiores que o limite superior.
- Não se admitem `24:00` nem o label de segundo intercalar. Também não contém data, fuso horário nem offset UTC.
- Mesmo um valor pequeno ocupa sempre 4 WORD.

## Comprimento

- O total é exatamente 5 WORD, a soma de 1 WORD de TAG e 4 WORD de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 4 WORD, rejeita-se.

## Exemplo

- A meia-noite é o Payload `0000 0000 0000 0000`, 5 WORD no total, `LLLL=0100`.
- 1 ns depois da meia-noite é o Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns é igual ao limite superior e, portanto, não é válido.
- `ffff ffff ffff ffff` é -1 como signed int64 e, portanto, não é válido.

## Base normativa

- `TIME(isAdjustedToUTC=false, unit=NANOS)` de [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) guarda em `int64` os nanosegundos desde a meia-noite da hora local, com ordem signed.
- O [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo do [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) define Time em NANOSECOND como inteiro signed de 64 bits, limita a faixa válida a menos de 86.400 segundos desde a meia-noite, inclusive, e não admite segundo intercalar. O GEUL só acrescenta a TAG e o framing de WORD de 16 bits big-endian.
