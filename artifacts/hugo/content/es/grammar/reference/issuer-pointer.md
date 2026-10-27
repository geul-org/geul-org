---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER es un Reference que señala y declara, y apunta al propio Issuer. El Payload es solo un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
ISSUER-POINTER es un Reference que señala y declara, y apunta al propio Issuer. Es el objeto del `BIND` del nombre de Issuer, de `LABEL` y de los Edge de juicio.

## Layout

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[TAG de extensión de Length]
Issuer            1/2/4/16 WORD
```

- El ancho del Issuer es todo el Payload. El Codec no divide el ancho. Si el ancho no es de 1, 2, 4 o 16 WORD, o si el valor del Issuer cabe en un ancho más estrecho, es invalid (forma canónica del Issuer).
- Si el Issuer es de 16 WORD, son 17 WORD en total, por lo que se añade 1 WORD de extensión de Length.
- Del Quantifier solo se usa `000` (Identified). Cualquier otro valor es invalid.
- El valor del Issuer sigue la asignación de [Issuer](/es/grammar/issuer/).
- Usos: el Subject de BIND del índice de nombres de Issuer `issuers.geul` ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#nombre-del-issuer)), el LABEL del nombre para mostrar del Issuer, el juicio sobre un Issuer, el firmante y otras posiciones en que el propio Issuer es el objeto.
- La única forma de apuntar al propio Issuer es ISSUER-POINTER. Apuntar a un Issuer con `EXTERNAL-ISSUER-*` usando el ID de documento `0` y el ID de destino `0` es invalid.

## Ejemplo

| Issuer | Secuencia de WORD |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## Páginas relacionadas

- [Reference](/es/grammar/reference/), [DOC-POINTER](/es/grammar/reference/doc-pointer/), [EXTERNAL-ISSUER](/es/grammar/reference/external-issuer/), [Issuer y publicación](/es/grammar/issuer/)
