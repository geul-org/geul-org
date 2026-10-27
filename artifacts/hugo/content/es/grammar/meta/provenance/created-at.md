---
title: "CREATED-AT"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CREATED-AT es un Meta de procedencia que anota con un Value TIME el momento en que se escribió el documento (git author date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el momento en que se escribió el documento (git author date).

## Layout

```
TAG WORD          0001 1LLL L010 0010      Codec 0x22
[TAG de extensión de Length]
Payload           un Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, etc.)
```

- Codec: Meta `0x22`, clase de procedencia (`010`)
- Payload: Value incorporado (familia TIME: [GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/es/grammar/value/time/posix-timestamp-seconds/), etc.)
- Cantidad: como máximo uno

## Interpretación y validez

- El formato se elige entre los Value de la familia TIME. Si se necesita precisión, se usa un formato de nanosegundos definido por un Issuer (ejemplo: [POSIX-TIMESTAMP-NANOSECONDS](/es/grammar/value/time/posix-timestamp-nanoseconds/)).
