---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT es un Meta de verificación que anota en 1 WORD el resultado del juicio del documento entero (Pass, Review, Fail)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el resultado del juicio del documento entero. El juicio por nodo o por registro lo lleva el `VERDICT` (Edge `0x78`) de [TOULMIN](/es/grammar/edge/toulmin/).

## Layout

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[TAG de extensión de Length]
Juicio            1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x44`, clase de verificación (`100`)
- Payload: valor en bruto (juicio de 1 WORD)
- Cantidad: como máximo uno

## Interpretación y validez

- Por ser de la clase de verificación, se excluye del hash de contenido.
- El juicio sobre otro documento se coloca en el BODY de un documento distinto del objeto juzgado.

## Problemas abiertos

- Si anotar también el sujeto del juicio y su fundamento.
