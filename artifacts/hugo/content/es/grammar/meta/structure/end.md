---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END es un Meta de estructura de 1 WORD que cierra el documento. Es obligatorio en todos los documentos."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Es el registro que cierra el documento.

## Layout

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[TAG de extensión de Length]
```

- Codec: Meta `0x0F`, clase de estructura (`000`)
- Payload: ninguno (1 WORD)
- Cantidad: uno por documento, al final

## Interpretación y validez

- Es obligatorio. La posición se comprueba con la longitud de [DOC](/es/grammar/meta/structure/doc/) (`DOC-*`).
- Si la entrada termina sin END, el documento está truncado. Si el contenido de un documento truncado se considera válido es política del decodificador.
- Después no viene nada.

## Ejemplo

- `0x180F`
