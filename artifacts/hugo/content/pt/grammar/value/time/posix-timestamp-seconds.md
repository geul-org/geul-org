---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS é o Value que contém o número de segundos signed int64 desde a epoch Unix (Codec 0x22)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS é o número de segundos signed desde a epoch Unix `1970-01-01T00:00:00Z`. Como o seconds-since-the-Epoch do POSIX, vê todo dia como exatamente 86.400 segundos e não conta segundos intercalares.

## Layout

- Código: código direto de Value `0x22`. Família TIME.
- Para a troca de dados industriais, usa o mesmo tipo físico signed int64 de largura fixa que `timestamp[s]` do Arrow.

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  total de 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretação e validade

- As 4 WORDs do Payload, na ordem de WORD big-endian, são lidas como um signed count em complemento de dois de 64 bits.
- A faixa válida é `-2^63`~`2^63-1` segundos. Um valor negativo é um instant anterior à epoch.
- Mesmo um valor pequeno ocupa sempre 4 WORD. Não se deve reduzir à representação inteira de mínimo de WORDs.
- Não contém fuso horário, o offset UTC original, label de segundo intercalar nem tabela de segundos intercalares.

## Comprimento

- O total é exatamente 5 WORD, a soma de 1 WORD de TAG e 4 WORD de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 4 WORD, rejeita-se.

## Exemplo

- A epoch é o Payload `0000 0000 0000 0000`, 5 WORD no total, `LLLL=0100`.
- 1 segundo depois da epoch é o Payload `0000 0000 0000 0001`.
- 1 segundo antes da epoch é o Payload `ffff ffff ffff ffff`.

## Base normativa

- O [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) apenas define os membros `time_t tv_sec` e `long tv_nsec`, e não define um wire format que serialize os segundos acumulados como signed int64. A largura concreta e a representação de `time_t` dependem do ambiente de implementação e não são iguais à representação do Payload do GEUL.
- O [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) define a correspondência de calendário dos segundos desde a epoch e a regra de 86.400 segundos por dia.
- O [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) e o [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo definem o timestamp como inteiro signed de 64 bits desde uma epoch fixa, com suporte à unidade SECOND e sem contar segundos intercalares. O GEUL só acrescenta a esse tipo físico a TAG e o framing de WORD de 16 bits big-endian.
