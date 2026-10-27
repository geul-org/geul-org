---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 é o Value de caixa delimitadora bidimensional com quatro componentes IEEE 754 binary64 na ordem (minX, minY, maxX, maxY) (formato 0x050C do Issuer ADHOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 é uma caixa delimitadora bidimensional com quatro componentes IEEE 754 binary64 na ordem `(minX, minY, maxX, maxY)`.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x050C`. Família NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG estendida de Length   1 WORD  0x0014 (20 WORD no total)
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Regras de interpretação

- Cada componente é um binary64 lido a partir da WORD superior. Preserva-se o padrão de bits do zero com sinal.
- O CRS, o significado e a ordem dos eixos e a unidade são contexto externo. Não há ABI padding.

## Validade

- O Payload deve ter exatamente 16 WORD, com `minX ≤ maxX` e `minY ≤ maxY`.
- Como o NaN não é comparável, rejeita-se se estiver em qualquer componente.

## Base normativa e status do formato

- O significado das coordenadas mínima e máxima consulta o bounding envelope do [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) do OGC, e cada componente segue o [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- A ordem da matriz 2D do envelope do GeoPackage é `[minx, maxx, miny, maxy]`. A ordem `(minX, minY, maxX, maxY)` deste formato não é essa wire order, e sim uma compact tuple definida pelo GEUL, e também não contém o header do WKB/GeoPackage. O CRS, o significado dos eixos e a unidade são contexto externo.

## Comprimento

- O total é exatamente 20 WORD, a soma de 1 WORD de TAG, 1 WORD de TAG estendida de Length, 1 WORD de Issuer, 1 WORD de número de formato e 16 WORD de Payload, e usa `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não for exatamente 16 WORD, rejeita-se.

## Exemplo

- Se os componentes forem `(0.0, 1.0, 2.0, 3.0)`, é válido, e se forem `(2.0, 1.0, 0.0, 3.0)`, é invalid.
