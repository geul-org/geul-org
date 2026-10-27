---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE es un Meta de definición que declara con un Value de idioma el idioma por defecto del texto del documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Declara el idioma por defecto del texto del documento. El texto cuyo idioma no se ha anotado aparte está en este idioma.

## Layout

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[TAG de extensión de Length]
Payload           un Value de idioma
```

- Codec: Meta `0x16`, clase de definición (`001`)
- Payload: Value incorporado ([LANGUAGE-BCP47-CODE](/es/grammar/value/text/language-bcp47-code/) o [LANGUAGE-SHORT-CODE](/es/grammar/value/text/language-short-code/))
- Cantidad: como máximo uno

## Interpretación y validez

- Los documentos TANGEUL anotan el locale de redacción (ejemplo: `en`, `ko`).

## Ejemplo

- `en`: `0x1916 0x08C6 0x656E`
