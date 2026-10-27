---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG es un Meta de linaje que anota un nombre inmutable puesto a una versión (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota un nombre inmutable puesto a una versión (git annotated tag).

## Layout

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[TAG de extensión de Length]
Nombre            Value UTF8-TEXT-*
Destino           Value SHA-256-DIGEST, o marcador de omisión 0x0000 (campo opcional). Si se omite, esta versión
```

- Codec: Meta `0x39`, clase de linaje (`011`)
- Payload: Value incorporado (texto + hash de contenido opcional)
- Cantidad: puede haber varios

## Interpretación y validez

- El nombre es [UTF8-TEXT](/es/grammar/value/text/utf8-text/) y el destino es [SHA-256-DIGEST](/es/grammar/value/binary/sha-256-digest/).
- Si se omite el destino (ABSENT `0x0000`, campo opcional de [CODEC](/es/grammar/edge/codec/)), es un nombre puesto al propio documento. El propio hash de contenido no se puede anotar dentro de sí mismo. La especificación `0x1839` de geul.org tiene dos campos de registro: name (`0840`, `0841`) y target (`0861`, `0000`).
- Un mismo nombre no se vuelve a usar en otra versión.

## Ejemplo

- Nombre `v1`, esta versión: `19B9 08C0 7631 0000`

## Problemas abiertos

- Si TAG sigue haciendo falta aunque exista el ID de versión (el número de orden), y el reparto de papeles con el nombre del documento (`BIND`).
