---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1032
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS é o número de nanossegundos com sinal desde a epoch Unix, 1970-01-01T00:00:00Z."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS é o número de nanossegundos com sinal desde a epoch Unix, `1970-01-01T00:00:00Z`. Como nos seconds-since-the-Epoch do POSIX, considera todo dia como exatamente 86.400 segundos e não conta segundos intercalares.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, número do Codec `0x00004000`. Família TIME.
- Para o intercâmbio de dados da indústria, usa-se o mesmo tipo físico int64 com sinal de largura fixa do `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` do Parquet.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total de 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Número do Codec   2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretação e validade {#해석과-유효성}

- Os 4 WORD do Payload são lidos por inteiro como um count com sinal de 64 bits em complemento de dois, na ordem de WORD big-endian.
- A faixa válida é de `-2^63` a `2^63-1` ns, e a faixa de instantes é de `1677-09-21 00:12:43.145224192Z` a `2262-04-11 23:47:16.854775807Z`.
- Mesmo valores pequenos usam sempre 4 WORD. Não se deve reduzir a uma representação inteira mínima em WORD.
- Não se guardam timezone, offset UTC original, label de segundo intercalar nem tabela de leap-second.

## Comprimento {#길이}

- O total é exatamente 9 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 4 WORD, e usa-se o comprimento direto `LLLL=1000`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 4 WORD, rejeita-se.

## Exemplo {#예시}

- A epoch é o Payload `0000 0000 0000 0000`, 9 WORD no total, `LLLL=1000`.
- 1 ns após a epoch é o Payload `0000 0000 0000 0001`.
- 1 ns antes da epoch é o Payload `FFFF FFFF FFFF FFFF`.

## Base normativa {#표준-근거}

- O [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) define os membros `time_t tv_sec` e `long tv_nsec`, com `0 <= tv_nsec < 10^9`. A largura concreta e a representação de `time_t` dependem do ambiente de implementação, e não se define um wire format int64 com sinal de nanossegundos acumulados que una os dois membros.
- O [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) considera o dia como exatamente 86.400 segundos.
- O `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` dos [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) armazena os nanossegundos desde a epoch Unix num único `int64`. O GEUL apenas acrescenta a esse tipo físico a TAG e o enquadramento em WORD big-endian de 16 bits.
