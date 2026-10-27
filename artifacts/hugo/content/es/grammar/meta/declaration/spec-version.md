---
title: "SPEC-VERSION"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "SPEC-VERSION es un Meta de definición que declara con un solo entero la versión de la especificación GEUL que sigue el documento. GEUL v1 es 0x0001."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Declara la versión de la especificación GEUL que sigue el documento. Este valor fija cómo se leen los demás registros.

## Layout

```
TAG WORD          0001 1LLL L001 0000      Codec 0x10
[TAG de extensión de Length]
Payload           versión de la especificación. v1 = 0x0001
```

- Codec: Meta `0x10`, clase de definición (`001`)
- Payload: valor en bruto (entero unsigned del ancho más corto)
- Cantidad: como máximo uno

## Interpretación y validez

- No depende del código de Value. Para que lo pueda leer el decodificador de cualquier versión, lleva solo un entero, sin Value incorporado.
- Si es una versión desconocida, el decodificador rechaza o avisa.
- Si falta, se lee con la versión que conoce el decodificador. Los documentos publicados la anotan.

## Ejemplo

- `0x1890 0x0001`: GEUL v1

## Problemas abiertos

- Correspondencia con la versión del documento del libro de códigos ([documento de especificación](/es/grammar/codec-spec/)).
