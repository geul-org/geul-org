---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT es un Meta de procedencia que anota con un Value TIME el momento en que se registró el documento (git commit date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el momento en que se registró el documento (git commit date).

## Layout

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[TAG de extensión de Length]
Payload           un Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, etc.)
```

- Codec: Meta `0x25`, clase de procedencia (`010`)
- Payload: Value incorporado (familia TIME: [GREGORIAN-DATE](/es/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/es/grammar/value/time/posix-timestamp-seconds/), etc.)
- Cantidad: como máximo uno

## Interpretación y validez

- El formato se elige entre los Value de la familia TIME. Si se necesita precisión, se usa un formato de nanosegundos definido por un Issuer (ejemplo: [POSIX-TIMESTAMP-NANOSECONDS](/es/grammar/value/time/posix-timestamp-nanoseconds/)).
- El documento de lista de versiones ([PUBLICATION](/es/grammar/edge/publication/)) usa este valor como momento de publicación, deprecación y eliminación.

## Problemas abiertos

- Los Meta de procedencia entran en el hash de contenido. Si se permite que el mismo contenido registrado en otro momento dé un hash distinto.
