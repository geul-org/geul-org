---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM es un Meta de linaje que anota el documento o material de otro linaje del que deriva este documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota que este documento deriva de un documento o material de otro linaje.

## Layout

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[TAG de extensión de Length]
Payload           Reference, o SHA-256-DIGEST (hash de contenido), o Value URI
```

- Codec: Meta `0x31`, clase de linaje (`011`)
- Payload: Reference o Value incorporado
- Cantidad: puede haber varios

## Interpretación y validez

- Si deriva de un documento GEUL, se pone su hash de contenido ([SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/)); si es un material externo, un [URI](/es/grammar/value/text/uri/). Para fijar con un hash la edición de un material externo, se añade al [SOURCE](/es/grammar/edge/source/#procedencia-del-documento-entero) del HEAD un QUALIFIER de hash del texto original (P4092).
- La fuente por registro la lleva el Edge de fundamento [SOURCE](/es/grammar/edge/source/), y el registro antiguo antes de un traslado, división o fusión lo lleva el QUALIFIER P1365 del Edge destino (con el Edge Id antiguo como valor).
