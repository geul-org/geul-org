---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS é o Value que contém o número de nanossegundos signed int64 desde a epoch Unix (formato 0x4000 do Issuer IEEE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS é o número de nanossegundos signed desde a epoch Unix `1970-01-01T00:00:00Z`. Como o seconds-since-the-Epoch do POSIX, vê todo dia como exatamente 86.400 segundos e não conta segundos intercalares.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0040` IEEE, número de formato `0x4000`. Família TIME.
- Para a troca de dados industriais, usa o mesmo tipo físico signed int64 de largura fixa que `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` do Parquet.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  total de 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
Número de formato 1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretação e validade

- As 4 WORDs do Payload, na ordem de WORD big-endian, são lidas como um signed count em complemento de dois de 64 bits.
- A faixa válida é `-2^63`~`2^63-1` ns, e a faixa de instant é `1677-09-21 00:12:43.145224192Z`~`2262-04-11 23:47:16.854775807Z`.
- Mesmo um valor pequeno ocupa sempre 4 WORD. Não se deve reduzir à representação inteira de mínimo de WORDs.
- Não contém fuso horário, o offset UTC original, label de segundo intercalar nem tabela de segundos intercalares.

## Comprimento

- O total é exatamente 7 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 4 WORD de Payload, e usa o comprimento direto `LLLL=0110`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 4 WORD, rejeita-se.

## Exemplo

- A epoch é o Payload `0000 0000 0000 0000`, 7 WORD no total, `LLLL=0110`.
- 1 ns depois da epoch é o Payload `0000 0000 0000 0001`.
- 1 ns antes da epoch é o Payload `ffff ffff ffff ffff`.

## Base normativa

- O [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) define os membros `time_t tv_sec` e `long tv_nsec`, com `0 <= tv_nsec < 10^9`. A largura concreta e a representação de `time_t` dependem do ambiente de implementação, e não se define um wire format signed int64 de nanossegundos acumulados que una os dois membros.
- O [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) vê um dia como exatamente 86.400 segundos.
- O `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` de [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) guarda os nanossegundos desde a epoch Unix em um único `int64`. O GEUL só acrescenta a esse tipo físico a TAG e o framing de WORD de 16 bits big-endian.
