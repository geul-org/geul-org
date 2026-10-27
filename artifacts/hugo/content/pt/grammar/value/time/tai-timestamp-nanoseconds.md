---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS é o Value que contém o número de nanossegundos signed desde 1970-01-01T00:00:00 TAI (formato 0x4001 do Issuer BIPM)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS é o número de nanossegundos signed desde a mesma epoch TAI, `1970-01-01T00:00:00 TAI`. Esta representação de contagem acumulada não é um wire format normativo do BIPM, e sim um profile próprio do GEUL que mapeia a escala de tempo TAI num signed int64 de largura fixa.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0060` BIPM, número de formato `0x4001`. Família TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  total de 7 WORD
Issuer            1 WORD  0x0060 (BIPM)
Número de formato 1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretação e validade

- As 4 WORDs do Payload, na ordem de WORD big-endian, são lidas como um signed count em complemento de dois de 64 bits.
- A faixa válida é `-2^63`~`2^63-1` ns. Um valor negativo é um instant TAI anterior à epoch definida pelo GEUL.
- Mesmo um valor pequeno ocupa sempre 4 WORD. Não guarda offset UTC nem tabela de segundos intercalares.

## Comprimento

- O total é exatamente 7 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 4 WORD de Payload, e usa o comprimento direto `LLLL=0110`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 4 WORD, rejeita-se.

## Exemplo

- A epoch TAI do GEUL é o Payload `0000 0000 0000 0000`, 7 WORD no total, `LLLL=0110`.
- 1 ns depois da epoch é o Payload `0000 0000 0000 0001`.
- 1 ns antes da epoch é o Payload `ffff ffff ffff ffff`.

## Base normativa e status do formato

- O [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) define o segundo SI e a escala de tempo International Atomic Time (TAI).
- O BIPM não define nanossegundos acumulados em signed int64 desde a epoch `1970-01-01 TAI` nem a sua wire encoding. A epoch, o count por unidade, o signed int64 e a disposição de WORD big-endian do GEUL são um mapeamento próprio do GEUL.
- O int64 de largura fixa foi escolhido pela consistência de troca com os outros profiles de count TIME, e não quer dizer que se reproduziu tal qual um formato do BIPM.
