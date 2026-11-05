---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1021
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS é o número de nanossegundos com sinal desde a mesma epoch TAI, 1970-01-01T00:00:00 TAI."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS é o número de nanossegundos com sinal desde a mesma epoch TAI, `1970-01-01T00:00:00 TAI`. Esta representação por count acumulado não é um wire format padrão do BIPM, mas um profile próprio do GEUL que mapeia a escala de tempo TAI num int64 com sinal de largura fixa.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000013` BIPM, número do Codec `0x00004001`. Família TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total de 9 WORD
Issuer            2 WORD  0x00000013 (BIPM)
Número do Codec   2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretação e validade {#해석과-유효성}

- Os 4 WORD do Payload são lidos por inteiro como um count com sinal de 64 bits em complemento de dois, na ordem de WORD big-endian.
- A faixa válida é de `-2^63` a `2^63-1` ns. Os valores negativos são instantes TAI anteriores à epoch definida pelo GEUL.
- Mesmo valores pequenos usam sempre 4 WORD. Não se armazenam offset UTC nem tabela de leap-second.

## Comprimento {#길이}

- O total é exatamente 9 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 4 WORD, e usa-se o comprimento direto `LLLL=1000`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 4 WORD, rejeita-se.

## Exemplo {#예시}

- A epoch TAI do GEUL é o Payload `0000 0000 0000 0000`, 9 WORD no total, `LLLL=1000`.
- 1 ns após a epoch é o Payload `0000 0000 0000 0001`.
- 1 ns antes da epoch é o Payload `FFFF FFFF FFFF FFFF`.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- O [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) especifica o segundo SI e a escala de tempo International Atomic Time (TAI).
- O BIPM não define um count acumulado de nanossegundos em int64 com sinal a partir da epoch `1970-01-01 TAI`, nem o seu wire encoding. A epoch, o count por unidade, o int64 com sinal e a disposição em WORD big-endian do GEUL são um mapeamento próprio do GEUL.
- O int64 de largura fixa foi escolhido por consistência de intercâmbio com outros profiles de count TIME, e não significa que o formato do BIPM foi reproduzido tal qual.
