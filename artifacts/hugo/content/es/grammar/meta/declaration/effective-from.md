---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM es un Meta de definición que declara con un Value de fecha o marca de tiempo la fecha de entrada en vigor de esta versión."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Declara la fecha de entrada en vigor de esta versión. La fecha de entrada en vigor es distinta del momento de publicación ([Revisión](/es/grammar/document/#revisión)).

## Layout

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[TAG de extensión de Length]
Payload           un Value TIME
```

- Codec: Meta `0x13`, clase de definición (`001`)
- Payload: Value incorporado ([GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/) o [POSIX-TIMESTAMP-SECONDS](/es/grammar/value/time/posix-timestamp-seconds/))
- Cantidad: como máximo uno

## Interpretación y validez

- Si falta, entra en vigor desde el momento de publicación.
- Si hay [EFFECTIVE-UNTIL](/es/grammar/meta/declaration/effective-until/), debe ser anterior a él.
- Si la fecha de entrada en vigor difiere por artículo, se anota aparte en el Edge de ese artículo con QUALIFIER P580 (inicio) y P582 (fin) ([SOURCE](/es/grammar/edge/source/#expresión-de-otros-fundamentos)).
- Este valor se lee al interpretar un documento con referencia a un momento concreto.

## Ejemplo

- Vigente desde 1970-01-02: `0x1993 0x0920 0x0000 0x0001`
