---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS é um tempo decorrido signed em segundos, sem epoch."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `DURATION-SECONDS` (BIND `DURATION-SECONDS` do documento de especificação) |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| Documento de especificação | `0x00000000/codecs/0x000006D0/` (alvo do DECLARE `06D0`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 13 |
| Kind | Value · família: TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | tempo decorrido signed em SI-second, sem epoch |
| Lado Hugo | `value/time/duration-seconds.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | valor bruto de 4 WORD |  |  |

DURATION-SECONDS é um tempo decorrido signed em segundos, sem epoch. Não é um instant nem uma duração de meses ou anos do calendário.

## Layout {#레이아웃}

- Código: direct code de Value `0x06DL`. Família TIME.
- Usa o mesmo tipo físico de largura fixa int64 signed que o `Duration(SECOND)` do Arrow.

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretação e validade {#해석과-유효성}

- As 4 WORD do Payload são lidas inteiras como uma contagem signed de 64 bits em complemento de dois, em ordem de WORD big-endian.
- O intervalo válido é de `-2^63` a `2^63-1` segundos. O sinal indica o sentido do tempo decorrido e não aponta o instant de nenhum epoch específico.
- Mesmo valores pequenos usam sempre 4 WORD.

## Comprimento {#길이}

- O total é exatamente 5 WORD, somando 1 WORD de TAG e 4 WORD de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG de extensão de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 4 WORD, é rejeitado.

## Exemplo {#예시}

- 0 segundo é o Payload `0000 0000 0000 0000`, total de 5 WORD, `LLLL=0100`.
- 1 segundo é o Payload `0000 0000 0000 0001`.
- -1 segundo é o Payload `FFFF FFFF FFFF FFFF`.

## Base normativa {#표준-근거}

- O [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designa o `Schema.fbs` como a fonte autoritativa dos tipos de dados padrão do Arrow.
- No [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) de referência do Arrow, `Duration` é um tempo decorrido absoluto independente do calendário, suporta a unidade SECOND e é sempre representado como inteiro signed de 8 bytes. O GEUL acrescenta a isso apenas o TAG e o enquadramento em WORD de 16 bits big-endian.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000006D0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
