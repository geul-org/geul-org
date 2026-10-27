---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT es un Meta de linaje que anota el hash de contenido de la versión inmediatamente anterior (git parent). Si hay varios, es una fusión."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el hash de contenido de la versión inmediatamente anterior (git parent).

## Layout

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[TAG de extensión de Length]
Payload           un Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x30`, clase de linaje (`011`)
- Payload: Value incorporado ([SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/))
- Cantidad: puede haber varios (fusión)

## Interpretación y validez

- Si falta, es la primera versión, y si hay varios, es una fusión (git merge commit).
- Como entra en el [hash de contenido](/es/grammar/document/#hash-de-contenido), todo el historial forma una cadena de hashes.
- El documento de lista de versiones apunta al documento de lista anterior ([PUBLICATION](/es/grammar/edge/publication/)).
- El formato de digest se incorpora como Value para dejar margen a cambiar el algoritmo de hash. Por ahora el hash de contenido es solo SHA-256.

## Ejemplo

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta de 20 WORD = TAG + extensión de Length + Value incorporado de 18 WORD)
