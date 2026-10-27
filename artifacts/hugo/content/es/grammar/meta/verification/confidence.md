---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE es un Meta de verificación que anota la confiabilidad del documento entero con un Value decimal entre 0 y 1."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota la confiabilidad del documento entero. La confiabilidad por registro se escribe con un QUALIFIER que se añade al Edge destino (propiedad por definir, [SOURCE](/es/grammar/edge/source/#expresión-de-otros-fundamentos)).

## Layout

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[TAG de extensión de Length]
Payload           Value UNSIGNED-DECIMAL, de 0 a 1
```

- Codec: Meta `0x43`, clase de verificación (`100`)
- Payload: Value incorporado ([UNSIGNED-DECIMAL](/es/grammar/value/decimal/unsigned-decimal/))
- Cantidad: como máximo uno

## Interpretación y validez

- Quién asignó el valor se anota aparte con [GENERATED-BY](/es/grammar/meta/lineage/generated-by/), etc.

## Problemas abiertos

- La escala (0~1) y su relación con el juicio de TOULMIN.
