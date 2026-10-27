---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID es un Meta de definición que declara el identificador del documento con un DOC-POINTER (Issuer, ID de documento, versión 0) que apunta al propio documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Declara el identificador de este documento. Hace falta para que otros documentos puedan apuntar a este documento y a los objetos que contiene.

## Layout

```
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[TAG de extensión de Length]
Documento         registro Reference DOC-POINTER. (Issuer, ID de documento, versión 0)
```

- Codec: Meta `0x12`, clase de definición (`001`)
- Payload: un [DOC-POINTER](/es/grammar/reference/doc-pointer/) Reference incorporado (Issuer, ID de documento, versión 0)
- Cantidad: como máximo uno. Obligatorio en los documentos cuyo nombre empieza por `0x`

## Interpretación y validez

- El Payload es exactamente un registro Reference `DOC-POINTER` (Issuer, ID de documento, versión `0`). Del ID de versión solo se usa `0`. La versión no la asigna el documento sino la lista de versiones. El Quantifier es `000`.
- Por eso la notación que apunta a "este documento" es la misma en DOC-ID, en el Subject de [BIND](/es/grammar/edge/bind/) de `documents.geul` y en las citas de otros documentos.
- Con independencia de la versión, un mismo documento tiene el mismo `DOC-ID`. El ID de versión y el hash de contenido no se anotan en el documento ([Versión](/es/grammar/document/#versión)).
- El nombre de dirección lo lleva el `BIND` de afirmación del índice de nombres `documents.geul` ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#nombre-del-documento)), y el título legible por personas lo lleva el [LABEL](/es/grammar/edge/label/) de afirmación.
- Si falta, es un documento sin nombre y solo se puede apuntar a él por su hash de contenido. Hace falta para que otros documentos puedan apuntar con un Reference que señala a un LOCAL de este documento.
- Quien trae el documento verifica que el `DOC-ID` del documento recibido sea igual al Issuer y al ID de documento solicitados.
- El ID de documento `0x0000000000000000` es el documento índice de definición de términos del Issuer ([Issuer](/es/grammar/issuer/)). Como el nombre de este documento también empieza por `0x`, lleva DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). El propio Issuer lo representa [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/).
- Los documentos de `.well-known/geul/` cuyo nombre empieza por `0x` (documento de versión `<ID de versión>.geul`, documentos de especificación) requieren `DOC-ID`.
- Los documentos cuyo nombre no empieza por `0x` quedan exceptuados y no llevan `DOC-ID`: la lista de versiones `versions.geul` ([PUBLICATION](/es/grammar/edge/publication/)), el índice de nombres de documentos `documents.geul` y el índice de nombres de Issuer `issuers.geul` ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/)). El almacén por hash de contenido `h/` son copias de los documentos anteriores y sigue al original.
- Los documentos de especificación de Codec son documentos del Issuer GEUL `0x0000`. El ID de documento es el valor del TAG WORD de Kind·Codec ampliado a 4 WORD (`0x1018` → `0x0000000000001018`). El Reference `0000` está reservado, por lo que no resulta el ID de documento `0` ([documento de especificación](/es/grammar/codec-spec/)).

## Ejemplo

- Issuer `0x0001`, documento `0x…0005`: `1C12 03B8 0001 0000 0000 0000 0005 0000 0000` (TAG de Meta 1 + TAG de Reference 1 + Issuer 1 + ID de documento 4 + versión 2 = 9 WORD)
