---
title: "DURATION-SECONDS"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS é o Value que contém um tempo decorrido em segundos, signed int64 sem epoch (Codec 0x23)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-SECONDS é um tempo decorrido em segundos signed, sem epoch. Não é um instant nem um período de meses e anos do calendário.

## Layout

- Código: código direto de Value `0x23`. Família TIME.
- Usa o mesmo tipo físico signed int64 de largura fixa que `Duration(SECOND)` do Arrow.

```
TAG WORD          0x0A23 (0000 1010 0010 0011)  total de 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretação e validade

- As 4 WORDs do Payload, na ordem de WORD big-endian, são lidas como um signed count em complemento de dois de 64 bits.
- A faixa válida é `-2^63`~`2^63-1` segundos. O sinal é a direção do tempo decorrido e não aponta para o instant de nenhuma epoch específica.
- Mesmo um valor pequeno ocupa sempre 4 WORD.

## Comprimento

- O total é exatamente 5 WORD, a soma de 1 WORD de TAG e 4 WORD de Payload, e usa o comprimento direto `LLLL=0100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 4 WORD, rejeita-se.

## Exemplo

- 0 segundo é o Payload `0000 0000 0000 0000`, 5 WORD no total, `LLLL=0100`.
- 1 segundo é o Payload `0000 0000 0000 0001`.
- -1 segundo é o Payload `ffff ffff ffff ffff`.

## Base normativa

- O [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designa o `Schema.fbs` como a fonte autoritativa dos tipos de dados padrão do Arrow.
- No [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo do Arrow, `Duration` é um tempo decorrido absoluto, independente do calendário, que admite a unidade SECOND e é sempre representado como inteiro signed de 8 bytes. O GEUL só acrescenta a isso a TAG e o framing de WORD de 16 bits big-endian.
