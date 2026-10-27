---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE es un Meta de definición que declara el perfil aplicado al documento mediante un texto de nombre y versión."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Declara el perfil aplicado al documento. Los mismos registros se interpretan con los documentos de Codec que fija el perfil (ejemplo: con `tangeul-1.0`, [TOULMIN](/es/grammar/edge/toulmin/)).

## Layout

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[TAG de extensión de Length]
Payload           Value UTF8-TEXT "<nombre>-<major>.<minor>"
```

- Codec: Meta `0x11`, clase de definición (`001`)
- Payload: Value incorporado ([UTF8-TEXT](/es/grammar/value/text/utf8-text/))
- Cantidad: como máximo uno

## Interpretación y validez

- Un perfil con un major distinto se rechaza. Se admite una diferencia de minor (solo cambios de adición).
- Sin perfil, se lee solo con la gramática básica de GEUL y la especificación de los códigos directos.

## Ejemplo

- `tangeul-1.0`: `0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## Problemas abiertos

- Registro de nombres de perfil (geul.org) y reglas de nombres.
- Si se señala el perfil con un ID de documento (IMPORT) o se pone como texto.
