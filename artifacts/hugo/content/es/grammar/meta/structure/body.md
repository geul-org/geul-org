---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY es un Meta de estructura de 1 WORD que termina el HEAD del documento e inicia el BODY."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Es el registro que termina el HEAD y comienza el BODY.

## Layout

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[TAG de extensión de Length]
```

- Codec: Meta `0x0E`, clase de estructura (`000`)
- Payload: ninguno (1 WORD)
- Cantidad: como máximo uno por documento

## Interpretación y validez

- Si el HEAD está vacío, se omite. Un documento sin `BODY` es todo BODY. Se coloca si el HEAD tiene Meta o Edge del HEAD (el [SOURCE](/es/grammar/edge/source/#procedencia-del-documento-entero) del documento entero y sus QUALIFIER).
- No tiene Payload. Son 1 WORD en total.

## Ejemplo

- `0x180E`
