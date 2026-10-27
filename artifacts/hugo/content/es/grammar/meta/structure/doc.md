---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD y DOC-4WORD son Meta de estructura que abren el documento indicando el número total de WORD del documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Es el registro que abre el documento. Indica en el Payload el número total de WORD del documento. En esta página se tratan juntos `DOC-1WORD` (`0x00`), `DOC-2WORD` (`0x01`) y `DOC-4WORD` (`0x02`).

## Layout

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[TAG de extensión de Length]
Payload           número total de WORD. El Codec fija el ancho: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x00`~`0x02`, clase de estructura (`000`)
- Payload: valor en bruto (número total de WORD del documento, unsigned)
- Cantidad: uno por documento, al principio

## Interpretación y validez

- La longitud va desde el inicio del registro de apertura hasta el final de [END](/es/grammar/meta/structure/end/).
- Se usa el ancho más estrecho en que quepa el valor. Si se codifica con un ancho mayor, se rechaza por codificación no canónica.
- La longitud debe ser igual a toda la entrada. Un documento es una entrada.
- El decodificador puede saltar el documento entero con esta longitud. No existe un Codec que abra sin conocer la longitud.
- Al calcular el hash de contenido, se reescribe con la longitud sin los Meta de la clase de verificación y el ancho que corresponde a ella ([Hash de contenido](/es/grammar/document/#hash-de-contenido)).

## Ejemplo

- `0x1880 0x0017`: DOC-1WORD, 23 WORD en total
