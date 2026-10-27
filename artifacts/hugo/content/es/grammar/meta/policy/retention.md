---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION es un Meta de política que anota el plazo de conservación del documento con un Value de fecha de vencimiento o de duración."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el plazo de conservación del documento.

## Layout

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[TAG de extensión de Length]
Payload           fecha de vencimiento (GREGORIAN-DATE, etc.) o duración (DURATION-SECONDS)
```

- Codec: Meta `0x53`, clase de política (`101`)
- Payload: Value incorporado (familia TIME: [GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/), etc., o [DURATION-SECONDS](/es/grammar/value/time/duration-seconds/))
- Cantidad: como máximo uno

## Interpretación y validez

- Si es una duración, se cuenta desde [RECORDED-AT](/es/grammar/meta/provenance/recorded-at/).
