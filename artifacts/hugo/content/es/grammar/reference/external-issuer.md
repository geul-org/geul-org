---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER es un Reference que señala y declara, y cita con un solo registro, sin IMPORT, el LOCAL ID de un documento publicado por un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
EXTERNAL-ISSUER es un Reference que señala y declara, y cita sin IMPORT el LOCAL ID de un documento publicado por un Issuer. Su sentido queda completo con un solo registro y sigue la última versión.

## Layout

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[TAG de extensión de Length]
Issuer            ancho fijado por WW (00=1, 01=2, 10=4, 11=16 WORD)
ID de documento   4 WORD
ID de destino     todo el resto. El LOCAL ID de ese documento, con el ancho más corto
```

| CCCC | Nombre | Ancho del Issuer |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (asignado por geul.org) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (registro en geul.org, prueba de dominio) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (registro en geul.org, sin prueba) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (calculado a partir de la clave pública) |

- El ID de Issuer es un valor entero. Si el valor es el mismo, es el mismo Issuer. El Issuer se escribe con el ancho más corto en que quepa el valor y se elige el Codec de ese ancho (2 WORD solo si el valor supera `0xFFFF`, 4 WORD solo si es `2^32` o más, 16 WORD solo si es `2^64` o más). La notación con un ancho mayor es invalid ([Issuer](/es/grammar/issuer/)).
- El registro y la gestión de los Issuer corren a cargo de geul.org.
- No se anota la versión y se sigue la última. Para fijar la versión se usan [IMPORT-DOC](/es/grammar/meta/import/import-doc/) y [EXTERNAL-POINTER](/es/grammar/reference/external-pointer/).
- La ubicación se encuentra con las reglas de dirección de publicación ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/)).
- Si es el mismo LOCAL ID de ese documento, es el mismo objeto, ya se escriba como LOCAL dentro de ese documento, como EXTERNAL-ISSUER desde otro documento (o como EXTERNAL-POINTER tras un IMPORT).
- Solo apunta a un LOCAL del documento. El documento en sí se señala con [DOC-POINTER](/es/grammar/reference/doc-pointer/) y el propio Issuer con [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/). Por eso el ID de destino no es `0`. El ID de documento `0` es el documento índice de definición de términos del Issuer.

## Validez

- Si el ancho del Issuer no corresponde al Codec, o si el valor cabe en un ancho más estrecho, es invalid.
- Si el ID de destino es `0`, es invalid. El ID de destino `0` (el propio documento) lo cubre DOC-POINTER.
- Se prohíben WORD `0x0000` iniciales en el ID de destino.

## Ejemplo

| Objeto | Secuencia de WORD |
|---|---|
| Issuer `0x0001`, documento `0x…0002`, LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, documento `0x…0002`, LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## Páginas relacionadas

- [Reference](/es/grammar/reference/), [DOC-POINTER](/es/grammar/reference/doc-pointer/), [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/es/grammar/reference/external-pointer/)
- [Issuer y publicación](/es/grammar/issuer/)
