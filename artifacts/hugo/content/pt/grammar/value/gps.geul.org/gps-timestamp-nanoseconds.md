---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1023
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS é o número de nanossegundos com sinal desde a epoch GPS, 1980-01-06T00:00:00 GPS."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS é o número de nanossegundos com sinal desde a epoch GPS `1980-01-06T00:00:00 GPS`. Não se divide pelo número da GPS week nem se trunca pela largura de week rollover do campo de broadcast.

Esta representação por count acumulado não é o wire format de broadcast do IS-GPS-200, mas um profile próprio do GEUL que mapeia a escala de tempo GPS num int64 com sinal de largura fixa.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000016` GPS, número do Codec `0x00004001`. Família TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total de 9 WORD
Issuer            2 WORD  0x00000016 (GPS)
Número do Codec   2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretação e validade {#해석과-유효성}

- Os 4 WORD do Payload são lidos por inteiro como um count com sinal de 64 bits em complemento de dois, na ordem de WORD big-endian.
- A faixa válida é de `-2^63` a `2^63-1` ns. Os valores negativos são instantes de GPS time anteriores à epoch GPS.
- O count é um valor contínuo a partir da epoch. Não se aplica truncation nem rollover do campo de week-number do broadcast.
- Mesmo valores pequenos usam sempre 4 WORD. Não se incluem parâmetros de conversão para UTC.

## Comprimento {#길이}

- O total é exatamente 9 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 4 WORD, e usa-se o comprimento direto `LLLL=1000`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 4 WORD, rejeita-se.

## Exemplo {#예시}

- A epoch GPS é o Payload `0000 0000 0000 0000`, 9 WORD no total, `LLLL=1000`.
- 1 ns após a epoch é o Payload `0000 0000 0000 0001`.
- 1 ns antes da epoch é o Payload `FFFF FFFF FFFF FFFF`.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- A [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) é a fonte oficial de distribuição das especificações de interface do GPS.
- O [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) estabelece que o GPS time é uma escala de tempo contínua e que a week 0 começa à meia-noite de 1980-01-06, e define os campos de broadcast de GPS week number e de time-of-week/Z-count.
- O IS-GPS-200 não define uma wire representation int64 com sinal de nanossegundos acumulados desde a epoch. O count contínuo em nanossegundos sem rollover, o int64 com sinal e a disposição em WORD big-endian do GEUL são um mapeamento próprio do GEUL.
