---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE es un Meta de linaje que anota el motivo del cambio como texto con idioma (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el motivo del cambio (git commit message).

## Layout

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[TAG de extensión de Length]
Mensaje           1 Value UTF8-LANGUAGE-TEXT
```

- Codec: Meta `0x38`, clase de linaje (`011`)
- Payload: Value incorporado ([UTF8-LANGUAGE-TEXT](/es/grammar/value/text/utf8-language-text/))
- Cantidad: como máximo uno por idioma

## Interpretación y validez

- El mensaje y el idioma van juntos en un único UTF8-LANGUAGE-TEXT. Para un mismo idioma hay un solo MESSAGE.
- El documento de especificación de geul.org lo anota con [CODEC](/es/grammar/edge/codec/) `084A` y `084B`.
