---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS é um tempo decorrido em nanossegundos com sinal (signed), sem epoch."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS é um tempo decorrido em nanossegundos com sinal (signed), sem epoch. Não é um instant nem um período de meses ou anos do calendário.

| Item | Valor |
|---|---|
| Nome | `DURATION-NANOSECONDS` (BIND do documento de especificação `DURATION-NANOSECONDS`) |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| Documento de especificação | `0x00000000/codecs/0x00000810/` (alvo de DECLARE `0810`) |
| Seção | 4 `0100` (Value), deslocamento C dentro da seção = 1 |
| Kind | Value · família: TIME |
| TAG WORD | `0000 1000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Tempo decorrido em nanossegundos com sinal, sem epoch |
| Lado Hugo | `value/time/duration-nanoseconds.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | valor bruto de 4 WORDs |  |  |

## Layout {#레이아웃}

- Código: código direto de Value `0x081L`. Família TIME.
- Usa o mesmo tipo físico de largura fixa, int64 com sinal, que o `Duration(NANOSECOND)` do Arrow.

```
TAG WORD          0x0814 (0000 1000 0001 0100)  5 WORDs no total
Payload WORD 1st (bits 63..48)     Signed Nanoseconds 16 bits altos
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds 16 bits baixos
```

## Interpretação e validade {#해석과-유효성}

- Os 4 WORDs do Payload são lidos, no seu conjunto, como uma contagem signed de 64 bits em complemento de dois, na ordem de WORDs big-endian.
- O intervalo válido é `-2^63`~`2^63-1` ns. O sinal é o sentido do tempo decorrido e não aponta para um instant de nenhum epoch específico.
- Mesmo valores pequenos usam sempre 4 WORDs.

## Comprimento {#길이}

- O total é exatamente 5 WORDs, 1 WORD de TAG mais 4 WORDs de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG de extensão de Length, descriptor nem padding.
- Se o Payload não for exatamente 4 WORDs, rejeita-se.

## Exemplo {#예시}

- 0 ns tem Payload `0000 0000 0000 0000`, 5 WORDs no total, `LLLL=0100`. O total é `0814 0000 0000 0000 0000`.
- 1 ns tem Payload `0000 0000 0000 0001`.
- -1 ns tem Payload `FFFF FFFF FFFF FFFF`.

## Base normativa {#표준-근거}

- O [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designa `Schema.fbs` como a authoritative source dos tipos de dados padrão do Arrow.
- No [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) authoritative do Arrow, `Duration` é um tempo decorrido absoluto, independente do calendário, que suporta a unidade NANOSECOND e é sempre representado como inteiro com sinal de 8 bytes. GEUL acrescenta a isso apenas o TAG e o framing em WORDs big-endian de 16 bits.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000810/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
