---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER es un Reference que señala y declara, y apunta a una versión de un documento publicado por un Issuer. El ID de versión 0 es la última versión."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
DOC-POINTER es un Reference que señala y declara, y apunta a una versión de un documento publicado por un Issuer. Es el objeto de la publicación, deprecación y eliminación de documentos, de las ediciones citadas y de las afirmaciones sobre un documento.

## Layout

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[TAG de extensión de Length]
Issuer            1/2/4/16 WORD
ID de documento   4 WORD
ID de versión     2 WORD
```

## Interpretación y validez

- El ancho del Issuer es lo que queda del Payload al restar los 6 WORD del ID de documento y el ID de versión. El Codec no divide el ancho. Si el ancho no es de 1, 2, 4 o 16 WORD, o si el valor del Issuer cabe en un ancho más estrecho, es invalid (forma canónica del Issuer).
- El ID de versión no se omite. Si se permitiera omitirlo, el ancho del Issuer no se podría fijar solo con la longitud del Payload (Issuer de 4 WORD sin versión y Issuer de 2 WORD con versión serían los mismos 8 WORD).
- El ID de versión `0` es la última versión. Queda ligado a la versión vigente en el momento de la interpretación. Los demás valores quedan fijados a esa versión ([PUBLICATION](/es/grammar/edge/publication/)).
- El ID de documento `0` es el documento índice de definición de términos del Issuer. El propio Issuer se señala con [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/).
- Del Quantifier solo se usa `000` (Identified). Cualquier otro valor es invalid.
- La única forma de apuntar a un documento de un Issuer es DOC-POINTER. Apuntar a un documento con `EXTERNAL-ISSUER-*` (Issuer, ID de documento, ID de destino `0`) o con `EXTERNAL-POINTER-*` (IMPORT ID, ID de destino `0`) es invalid.
- Dónde se usa: Meta [DOC-ID](/es/grammar/meta/declaration/doc-id/) e [IMPORT-DOC](/es/grammar/meta/import/import-doc/), PUBLICATION, DEPRECATION y TOMBSTONE de la lista de versiones y el Subject de BIND, y el Subject de BIND del índice de nombres `documents.geul`.

## Ejemplo

Del Issuer GEUL `0x0000`, el documento `0xffff000000000001`.

| Versión | Secuencia de WORD |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| Última (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + ID de documento 4 + ID de versión 2 = 8 WORD, `LLLL=0111`. El TAG es `0000 0 0111 0111 000` = `03B8`.

## Páginas relacionadas

- [Reference](/es/grammar/reference/), [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/), [EXTERNAL-ISSUER](/es/grammar/reference/external-issuer/), [PUBLICATION](/es/grammar/edge/publication/)
- [Issuer y publicación](/es/grammar/issuer/)
