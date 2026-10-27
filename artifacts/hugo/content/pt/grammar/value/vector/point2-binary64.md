---
title: "POINT2-BINARY64"
weight: 1011
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 é o Value de ponto bidimensional com dois componentes IEEE 754 binary64 na ordem (x, y) (formato 0x050A do Issuer ADHOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 é um ponto bidimensional com dois componentes IEEE 754 binary64 na ordem `(x, y)`.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x050A`. Família NUMERIC.

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total de 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## Regras de interpretação

- Cada componente é lido a partir da WORD superior, e preservam-se o payload de NaN e o padrão de bits do zero com sinal.
- O CRS, o significado e a ordem dos eixos e a unidade são contexto externo. Não há ABI padding.

## Validade

- O Payload tem exatamente 8 WORD, e cada intervalo de 4 WORD são bits de interchange binary64.

## Base normativa e status do formato

- A ordem das coordenadas `x, y` do ponto consulta a axis order do Point/WKB do [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) do OGC, e cada componente segue o [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Este Payload é um compact profile do GEUL que não contém o header de type/byte-order do WKB nem o header do GeoPackage, e não é o wire format WKB do OGC. O CRS, o significado dos eixos e a unidade são contexto externo.

## Comprimento

- O total é exatamente 11 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 8 WORD de Payload, e usa o comprimento direto `LLLL=1010`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 8 WORD, rejeita-se.

## Exemplo

- O Payload `3ff0 0000 0000 0000 4000 0000 0000 0000` é `(1.0, 2.0)`.
