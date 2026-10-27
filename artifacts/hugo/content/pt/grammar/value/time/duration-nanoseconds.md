---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS é o Value que contém um tempo decorrido em nanossegundos, signed int64 sem epoch (formato 0x4000 do Issuer GEUL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS é um tempo decorrido em nanossegundos signed, sem epoch. Não é um instant nem um período de meses e anos do calendário.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0000` GEUL, número de formato `0x4000`. Família TIME.
- Usa o mesmo tipo físico signed int64 de largura fixa que `Duration(NANOSECOND)` do Arrow.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  total de 7 WORD
Issuer            1 WORD  0x0000 (GEUL)
Número de formato 1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretação e validade

- As 4 WORDs do Payload, na ordem de WORD big-endian, são lidas como um signed count em complemento de dois de 64 bits.
- A faixa válida é `-2^63`~`2^63-1` ns. O sinal é a direção do tempo decorrido e não aponta para o instant de nenhuma epoch específica.
- Mesmo um valor pequeno ocupa sempre 4 WORD.

## Comprimento

- O total é exatamente 7 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 4 WORD de Payload, e usa o comprimento direto `LLLL=0110`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 4 WORD, rejeita-se.

## Exemplo

- 0 ns é o Payload `0000 0000 0000 0000`, 7 WORD no total, `LLLL=0110`.
- 1 ns é o Payload `0000 0000 0000 0001`.
- -1 ns é o Payload `ffff ffff ffff ffff`.

## Base normativa

- O [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) designa o `Schema.fbs` como a fonte autoritativa dos tipos de dados padrão do Arrow.
- No [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) autoritativo do Arrow, `Duration` é um tempo decorrido absoluto, independente do calendário, que admite a unidade NANOSECOND e é sempre representado como inteiro signed de 8 bytes. O GEUL só acrescenta a isso a TAG e o framing de WORD de 16 bits big-endian.
