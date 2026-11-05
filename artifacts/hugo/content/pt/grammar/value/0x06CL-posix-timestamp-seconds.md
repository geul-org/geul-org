---
title: "POSIX-TIMESTAMP-SECONDS (0x06CL)"
weight: 108
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS é o número signed de segundos desde o Unix epoch 1970-01-01T00:00:00Z."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `POSIX-TIMESTAMP-SECONDS` (BIND `POSIX-TIMESTAMP-SECONDS` do documento de especificação) |
| TAG ID | `0x06CL` |
| Codec ID | `0x000006C0` |
| Documento de especificação | `0x00000000/codecs/0x000006C0/` (alvo do DECLARE `06C0`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 12 |
| Kind | Value · família: TIME |
| TAG WORD | `0000 0110 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | contagem signed de segundos desde o epoch Unix/POSIX |
| Lado Hugo | `value/time/posix-timestamp-seconds.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | valor bruto de 4 WORD |  |  |

POSIX-TIMESTAMP-SECONDS é o número signed de segundos desde o Unix epoch `1970-01-01T00:00:00Z`. Como o seconds-since-the-Epoch do POSIX, considera todos os dias exatamente com 86.400 segundos e não conta segundos intercalares.

## Layout {#레이아웃}

- Código: direct code de Value `0x06CL`. Família TIME.
- Para o intercâmbio de dados industriais, usa o mesmo tipo físico de largura fixa int64 signed que o `timestamp[s]` do Arrow.

```
TAG WORD          0x06C4 (0000 0110 1100 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretação e validade {#해석과-유효성}

- As 4 WORD do Payload são lidas inteiras como uma contagem signed de 64 bits em complemento de dois, em ordem de WORD big-endian.
- O intervalo válido é de `-2^63` a `2^63-1` segundos. Os negativos são instants anteriores ao epoch.
- Mesmo valores pequenos usam sempre 4 WORD. Não se deve reduzir para a representação de inteiro com o mínimo de WORD.
- Não guarda timezone, o UTC offset original, labels de segundo intercalar nem leap-second table.

## Comprimento {#길이}

- O total é exatamente 5 WORD, somando 1 WORD de TAG e 4 WORD de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG de extensão de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 4 WORD, é rejeitado.

## Exemplo {#예시}

- O epoch é o Payload `0000 0000 0000 0000`, total de 5 WORD, `LLLL=0100`.
- 1 segundo após o epoch é o Payload `0000 0000 0000 0001`.
- 1 segundo antes do epoch é o Payload `FFFF FFFF FFFF FFFF`.

## Base normativa {#표준-근거}

- O [`timespec` do POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) define apenas os membros `time_t tv_sec` e `long tv_nsec`, e não define um wire format que serialize os segundos acumulados como int64 signed. A largura e a representação concretas de `time_t` dependem do ambiente de implementação e não coincidem com a representação do Payload do GEUL.
- O [Seconds Since the Epoch do POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) define a correspondência de calendário dos segundos desde o epoch e a regra de 86.400 segundos por dia.
- O [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) e o [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) de referência definem o timestamp como inteiro signed de 64 bits a partir de um epoch fixo, com suporte à unidade SECOND e à não contagem de segundos intercalares. O GEUL acrescenta a esse tipo físico apenas o TAG e o enquadramento em WORD de 16 bits big-endian.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000006C0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006C000000000
BODY
#1 DECLARE 0x06C0
#2 FIELD #1 0x0004
#3 BIND #1 "POSIX-TIMESTAMP-SECONDS"
#4 BIND #2 "seconds"
```
