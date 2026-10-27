---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF es un Meta de verificación que anota con un Reference la confirmación de derechos de contribución (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Es la confirmación de derechos de contribución (git `Signed-off-by`, DCO).

## Layout

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[TAG de extensión de Length]
Payload           un Reference
```

- Codec: Meta `0x42`, clase de verificación (`100`)
- Payload: Reference incorporado
- Cantidad: puede haber varios

## Interpretación y validez

- En los documentos publicados en geul.org no se pone un Reference que apunte a una persona física ([Issuer y publicación](/es/grammar/issuer/#publicación-en-geulorg)). Se apunta a una organización o a un Issuer. Como excepción, se permite apuntar a una persona física con [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/).
