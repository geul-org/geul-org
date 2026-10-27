---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC es un Meta IMPORT que señala un documento externo con un DOC-POINTER y le asigna un IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Trae un documento externo con un IMPORT ID. El documento que se trae lo señala [DOC-POINTER](/es/grammar/reference/doc-pointer/), y el ancho del Issuer también lo lleva DOC-POINTER.

## Layout

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[TAG de extensión de Length]
Documento         registro Reference DOC-POINTER (Issuer, ID de documento, ID de versión. Si la versión es 0, la última)
IMPORT ID         todo el resto. unsigned del ancho más corto
```

- Codec: Meta `0x60`, clase IMPORT (`110`)
- Payload: Reference incorporado `DOC-POINTER` (Issuer, ID de documento, ID de versión) + valor en bruto IMPORT ID
- Cantidad: puede haber varios (uno por IMPORT ID)

## Interpretación y validez

- El documento es exactamente un registro DOC-POINTER. Termina con su propio Length y el resto es el IMPORT ID.
- El IMPORT ID tiene 1 WORD o más, con el ancho más corto. El ancho del IMPORT ID lo fija aquí la longitud del registro y en [EXTERNAL-POINTER-*](/es/grammar/reference/external-pointer/) el Codec. El IMPORT ID solo es válido dentro de ese documento.
- En un documento no se asigna dos veces el mismo IMPORT ID.
- Si se anota el ID de versión, queda ligado a esa edición, y si es `0`, a la edición más reciente en el momento de la interpretación (o a la que esté vigente en el momento indicado) ([Revisión](/es/grammar/document/#revisión)).
- El [EXTERNAL-POINTER-*](/es/grammar/reference/external-pointer/) del BODY apunta, con el IMPORT ID, a un LOCAL del documento importado. El propio documento importado se señala con DOC-POINTER.
- El HEAD del documento importado no se trae. Los objetos de ese documento se interpretan según las declaraciones de ese documento.
- Con el IMPORT ID no se puede buscar entre documentos. Un almacén que cargue varios documentos guarda el IMPORT ID resuelto a la ruta completa (Issuer, ID de documento, ID de versión, LOCAL ID).

## Ejemplo

- IMPORT ID 1, Issuer `0x0001`, documento `0x…0002`, última versión: `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (TAG de Meta 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORD)
