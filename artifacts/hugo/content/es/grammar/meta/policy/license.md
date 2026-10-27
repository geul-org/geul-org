---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE es un Meta de política que anota la licencia de este documento y de las obras contenidas en los bytes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota la licencia de este documento y de las obras contenidas en los bytes.

## Layout

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[TAG de extensión de Length]
Payload           Reference que apunta a la licencia, o identificador SPDX UTF8-TEXT, o Value URI
```

- Codec: Meta `0x50`, clase de política (`101`)
- Payload: Reference o Value incorporado ([UTF8-TEXT](/es/grammar/value/text/utf8-text/), [URI](/es/grammar/value/text/uri/))
- Cantidad: como máximo uno

## Interpretación y validez

- Los documentos publicados en geul.org son CC0. En la publicación privada lo fija el Issuer ([Issuer](/es/grammar/issuer/)).
- Se registra la licencia original de la obra de origen.

## Problemas abiertos

- Si el identificador SPDX se pone como texto o como Reference a una entidad de GEUL.
