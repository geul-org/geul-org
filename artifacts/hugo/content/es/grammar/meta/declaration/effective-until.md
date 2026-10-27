---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL es un Meta de definición que declara con un Value de fecha o marca de tiempo el fin de la validez de esta versión (ley temporal)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Declara el fin de la validez de esta versión (ley temporal). Desde ese momento esta versión deja de estar vigente.

## Layout

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[TAG de extensión de Length]
Payload           un Value TIME
```

- Codec: Meta `0x14`, clase de definición (`001`)
- Payload: Value incorporado ([GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/) o [POSIX-TIMESTAMP-SECONDS](/es/grammar/value/time/posix-timestamp-seconds/))
- Cantidad: como máximo uno

## Interpretación y validez

- Si falta, es válida hasta que entre en vigor la siguiente versión.
- Una vez pasado el periodo de validez, no hay ninguna edición vigente. Las ediciones antiguas no reviven.
