---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS é o Value que contém o número de nanossegundos signed desde a epoch GPS 1980-01-06T00:00:00 GPS (formato 0x4001 do Issuer GPS)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS é o número de nanossegundos signed desde a epoch GPS `1980-01-06T00:00:00 GPS`. Não se divide pelo número da semana GPS nem se corta pela largura do week rollover do campo de broadcast.

Esta representação de contagem acumulada não é o wire format de broadcast do IS-GPS-200, e sim um profile próprio do GEUL que mapeia a escala de tempo GPS num signed int64 de largura fixa.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0063` GPS, número de formato `0x4001`. Família TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  total de 7 WORD
Issuer            1 WORD  0x0063 (GPS)
Número de formato 1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretação e validade

- As 4 WORDs do Payload, na ordem de WORD big-endian, são lidas como um signed count em complemento de dois de 64 bits.
- A faixa válida é `-2^63`~`2^63-1` ns. Um valor negativo é um instant de tempo GPS anterior à epoch GPS.
- O count é um valor contínuo a partir da epoch. Não se aplica truncamento nem rollover do campo de número de semana do broadcast.
- Mesmo um valor pequeno ocupa sempre 4 WORD. Não contém parâmetros de conversão para UTC.

## Comprimento

- O total é exatamente 7 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 4 WORD de Payload, e usa o comprimento direto `LLLL=0110`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 4 WORD, rejeita-se.

## Exemplo

- A epoch GPS é o Payload `0000 0000 0000 0000`, 7 WORD no total, `LLLL=0110`.
- 1 ns depois da epoch é o Payload `0000 0000 0000 0001`.
- 1 ns antes da epoch é o Payload `ffff ffff ffff ffff`.

## Base normativa e status do formato

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) é o local oficial de distribuição das especificações de interface do GPS.
- O [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) define que o tempo GPS é uma escala de tempo contínua e que a semana 0 começa à meia-noite de 1980-01-06, e define o número da semana GPS e os campos de broadcast time-of-week/Z-count.
- O IS-GPS-200 não define uma wire representation signed int64 de nanossegundos acumulados desde a epoch. O count contínuo em nanossegundos sem rollover, o signed int64 e a disposição de WORD big-endian do GEUL são um mapeamento próprio do GEUL.
