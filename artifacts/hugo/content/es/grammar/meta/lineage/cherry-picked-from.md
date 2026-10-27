---
title: "CHERRY-PICKED-FROM"
weight: 53
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "CHERRY-PICKED-FROM es un Meta de linaje que anota el hash de contenido de la versión original de la que se trajo un cambio de otro linaje (git cherry-pick -x)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el hash de contenido de la versión original de la que se trajo el cambio de otro linaje (git cherry-pick `-x`).

## Layout

```
TAG WORD          0001 1LLL L011 0100      Codec 0x34
[TAG de extensión de Length]
Payload           un Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x34`, clase de linaje (`011`)
- Payload: Value incorporado ([SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/))
- Cantidad: puede haber varios

## Interpretación y validez

- El formato de digest se incorpora como Value para dejar margen a cambiar el algoritmo de hash. Por ahora el hash de contenido es solo SHA-256.
