---
title: "BBOX2-BINARY64"
weight: 1000
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 é uma caixa delimitadora bidimensional formada por quatro componentes IEEE 754 binary64, na ordem (minX, minY, maxX, maxY)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 é uma caixa delimitadora bidimensional formada por quatro componentes IEEE 754 binary64, na ordem `(minX, minY, maxX, maxY)`.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x0000050C`. Família NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG estendida de Length   1 WORD  0x0016 (total de 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x0000050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Regras de interpretação {#해석-규칙}

- Cada componente é um binary64 e é lido a partir do WORD mais significativo. O bit pattern do zero com sinal é preservado.
- O CRS, o significado e a ordem dos eixos e a unidade são contexto externo. Não há ABI padding.

## Validade {#유효성}

- O Payload deve ter exatamente 16 WORD, e deve valer `minX ≤ maxX` e `minY ≤ maxY`.
- NaN não é comparável; portanto, se houver NaN em qualquer componente, rejeita-se.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- O significado das coordenadas mínima e máxima toma como referência o bounding envelope do OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), e cada componente segue o [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- A ordem do array 2D do envelope do GeoPackage é `[minx, maxx, miny, maxy]`. A ordem `(minX, minY, maxX, maxY)` deste formato não é essa wire order, mas uma compact tuple definida pelo GEUL, e também não leva o cabeçalho WKB/GeoPackage. O CRS, o significado dos eixos e a unidade são contexto externo.

## Comprimento {#길이}

- O total é exatamente 22 WORD, somando TAG 1 WORD, TAG estendida de Length 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 16 WORD, e usa-se `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não tiver exatamente 16 WORD, rejeita-se.

## Exemplo {#예시}

- Se os componentes forem `(0.0, 1.0, 2.0, 3.0)`, é válido; se forem `(2.0, 1.0, 0.0, 3.0)`, é invalid.
