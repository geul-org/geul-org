---
title: "SQUASHED-FROM"
weight: 56
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "SQUASHED-FROM es un Meta de linaje que anota los hashes de contenido de las versiones originales unidas en una (git squash)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota los hashes de contenido de las versiones originales unidas en una (git squash).

## Layout

```
TAG WORD          0001 1LLL L011 0111      Codec 0x37
[TAG de extensión de Length]
Payload           un Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x37`, clase de linaje (`011`)
- Payload: Value incorporado ([SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/))
- Cantidad: puede haber varios (uno por versión original)

## Interpretación y validez

- El formato de digest se incorpora como Value para dejar margen a cambiar el algoritmo de hash. Por ahora el hash de contenido es solo SHA-256.
