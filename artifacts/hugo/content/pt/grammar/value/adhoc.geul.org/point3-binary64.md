---
title: "POINT3-BINARY64"
weight: 1018
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 é um ponto tridimensional formado por três componentes IEEE 754 binary64, na ordem (x, y, z)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 é um ponto tridimensional formado por três componentes IEEE 754 binary64, na ordem `(x, y, z)`.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x0000050B`. Família NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG estendida de Length   1 WORD  0x0012 (total de 18 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x0000050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Regras de interpretação {#해석-규칙}

- Cada componente é lido a partir do WORD mais significativo, preservando o NaN payload e o bit pattern do zero com sinal.
- O CRS, o significado e a ordem dos eixos e a unidade são contexto externo. Não há ABI padding.

## Validade {#유효성}

- O Payload tem exatamente 12 WORD, e cada segmento de 4 WORD é formado por interchange bits de binary64.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- A ordem das coordenadas `x, y, z` do ponto toma como referência a axis order de Point/WKB do OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), e cada componente segue o [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Este Payload é um compact profile do GEUL que não leva o cabeçalho WKB de type/byte-order nem o cabeçalho GeoPackage, e não é o wire format WKB do OGC. O CRS, o significado dos eixos e a unidade são contexto externo.

## Comprimento {#길이}

- O total é exatamente 18 WORD, somando TAG 1 WORD, TAG estendida de Length 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 12 WORD, e usa-se `LLLL=1110`. Não há descriptor nem padding.
- Se o Payload não tiver exatamente 12 WORD, rejeita-se.

## Exemplo {#예시}

- Se os três binary64 do Payload forem `1.0, 2.0, 3.0`, é o ponto `(1.0, 2.0, 3.0)`.
