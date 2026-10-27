---
title: "PUBLICATION"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION y TOMBSTONE son Edge de afirmación que registran la publicación, la recomendación de dejar de usar y la eliminación de una versión de un documento; esta página fija además la especificación del documento de lista de versiones escrito con esos Edge (Codec 0x18~0x1A)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Es la especificación de los Edge de afirmación que registran la publicación, la deprecación y la eliminación de un documento, y del documento de lista de versiones que se escribe con ellos. Fija el formato de la lista de versiones de [Direcciones de publicación y lista de versiones](/es/grammar/publishing/#lista-de-versiones).

## Códigos

| Codec | Nombre | Payload |
|---|---|---|
| `0x18` | PUBLICATION | Edge Id, DOC-POINTER, hash de contenido |
| `0x19` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x1A` | TOMBSTONE | Edge Id, DOC-POINTER, categoría de motivo |

- Los tres códigos vienen integrados en el decodificador ([capa 0](/es/grammar/publishing/#capas)). La lista de versiones se interpreta sin consultar el libro de códigos.
- No tienen subformato (TAG propio del Codec). Se respeta tal cual la regla de [Edge](/es/grammar/edge/) de que el primer elemento del Payload es el Edge Id.

## Layout

```
TAG WORD          Edge, Codec 0x18 / 0x19 / 0x1A
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Documento         registro Reference DOC-POINTER (Issuer, ID de documento, ID de versión)
Hash de contenido 16 WORD   (PUBLICATION)
Categoría de motivo 1 WORD  (TOMBSTONE)
```

| Campo | Ancho | Descripción |
|---|---|---|
| Edge Id | registro Reference LOCAL | Número de orden dentro de la lista. Se numera desde 1 y se encadena |
| Documento | registro DOC-POINTER | Una versión del documento publicado ([DOC-POINTER](/es/grammar/reference/doc-pointer/)). El Issuer y el ID de documento son los mismos del documento que trata esa lista. Hace que el documento de la lista diga de qué es lista incluso sin ruta. El ID de versión es el número de orden dentro de ese documento (versión de [Documento](/es/grammar/document/)) y no se usa `0` (la más reciente) |
| Hash de contenido | 16 WORD | Hash de contenido de esa versión (SHA-256, hash de contenido de [Documento](/es/grammar/document/)) |
| Categoría de motivo | 1 WORD | Código de categoría del motivo de eliminación. La tabla de códigos es un problema abierto |

- La longitud tras DOC-POINTER es fija según el código (16, 0, 1 WORD). Si es distinta, se rechaza.
- La hora no se pone en el registro. El `RECORDED-AT` del documento de lista en el que se incluyó por primera vez ese registro es la hora de publicación, deprecación o eliminación.

## Documento de lista de versiones

El lugar de publicación escribe, por cada documento, un documento de lista de versiones al que va añadiendo: `/<Issuer>/<ID de documento>/versions.geul`. En una sola lista entran todas las versiones de ese documento publicadas en ese lugar de publicación.

```
DOC-1WORD/2WORD/4WORD     longitud total
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value SHA-256-DIGEST. Hash de contenido del documento de lista anterior (si es la primera lista, no hay)
  RECORDED-AT             Value POSIX-TIMESTAMP-SECONDS. Hora en que se emitió esta lista
  NEXT-LOCAL-ID           siguiente ID LOCAL que se asignará (si hay versiones)
  SIGNATURE               firma del lugar de publicación. El objeto es el hash de contenido de este documento de lista
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE · BIND …
END
```

- Meta de HEAD: [SPEC-VERSION](/es/grammar/meta/declaration/spec-version/), [PARENT](/es/grammar/meta/lineage/parent/), [RECORDED-AT](/es/grammar/meta/provenance/recorded-at/), [NEXT-LOCAL-ID](/es/grammar/meta/lineage/next-local-id/), [SIGNATURE](/es/grammar/meta/verification/signature/).
- El documento de lista no lleva `DOC-ID` (excepción para los documentos cuyo nombre no empieza por `0x`, [DOC-ID](/es/grammar/meta/declaration/doc-id/)). La lista no es un documento publicado, sino un registro que acompaña a ese documento. De qué documento es la lista lo dice el ID de documento de los registros. Por eso, aunque se reciba sin ruta (`h/`, volcado), se sabe de qué es la lista.
- Todos los ID de documento de los registros deben ser el documento que trata esa lista. Los registros de otro documento se rechazan.
- El documento de lista no pone IMPORT y usa solo Codec de la capa 0. No se incluye en otra lista (no hay lista de listas).
- El documento de lista nuevo pone delante, tal cual, el BODY del documento de lista anterior y le añade registros. No se corrige, ni se borra, ni se cambia el orden.
- El lugar de publicación firma la lista. En la publicación en geul.org firma geul.org (Issuer de GEUL), y en la publicación privada firma ese Issuer.
- El ID de documento `0x0000000000000000` es el documento de índice de definiciones de términos del Issuer ([Issuer y publicación](/es/grammar/issuer/)). El propio Issuer se señala con [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/).

## Reglas

- El ID de versión de PUBLICATION es ascendente desde 1 sin saltos. El ID de versión lo asigna el lugar de publicación.
- No se vuelve a publicar el mismo hash de contenido. Si ya existe, se devuelve ese ID de versión.
- DEPRECATION y TOMBSTONE apuntan solo al ID de versión de un PUBLICATION que aparece antes. Si apuntan a una versión inexistente, se rechaza.
- El estado de una versión se calcula aplicando los registros en orden: publicada → deprecada → eliminada. Una versión eliminada no se vuelve a publicar ni se entrega.
- La versión más reciente es el ID de versión más alto que no está ni deprecado ni eliminado.
- Si el ID de versión llega al final de sus 2 WORD, ese documento no se publica más y se emite con un ID de documento nuevo.

## Nombre del documento

El nombre de dirección de un documento lo liga con [BIND](/es/grammar/edge/bind/) el índice de nombres del Issuer `/<Issuer>/documents.geul` ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#nombre-del-documento)). El resolvedor lee solo este índice.

En el documento de lista también se puede poner el mismo BIND (opcional). Si se pone, se cumple lo siguiente.

- Subject es `DOC-POINTER` (Issuer, ID del documento de esa lista, versión `0`). El nombre se liga al documento y no a una versión, por lo que la versión es `0`.
- Solo se liga a documentos cuyo PUBLICATION aparece antes. No se liga un nombre a un documento que nunca se publicó.
- El nombre sigue la regla de nombres de documento (slug ASCII en minúsculas) y debe ser igual al BIND del índice de nombres.
- Si se cambia el nombre, se añade un BIND nuevo. El nombre antiguo se mantiene y apunta al mismo documento. El nombre principal es el último BIND.
- Dentro del documento no se anota su propio nombre.

## Dirección

```
/.well-known/geul/<Issuer>/<ID de documento>/versions.geul     documento de lista más reciente (mutable)
/.well-known/geul/h/<hash de contenido>.geul                   documento de lista anterior (inmutable)
```

- Lo único mutable es la dirección de la lista más reciente. La lista recibida se verifica con la firma, `RECORDED-AT` y la cadena de `PARENT`.
- Todos los documentos de lista anteriores se conservan en `h/`. Siguiendo la cadena de `PARENT` se puede reconstruir la lista de cualquier momento.

## Verificación

- El documento de lista debe tener un `SIGNATURE` con la clave del lugar de publicación fijado.
- El ID de documento de los registros debe ser igual al ID de documento solicitado.
- El hash de contenido de la lista anterior que quedó en el registro de bloqueo debe estar en la cadena de `PARENT` de la lista nueva. El BODY de esa lista debe ser igual a la parte inicial del BODY de la lista nueva.
- El hash de contenido del documento recibido debe ser igual al valor anotado en el PUBLICATION de ese ID de versión, y el `DOC-ID` del documento debe ser igual al Issuer e ID de documento solicitados.

## Problemas abiertos

- Tabla de códigos de la categoría de motivo.
- Algoritmo de firma por defecto y layout del Payload de `SIGNATURE`.
- Cuándo y en qué formato pasar a un registro Merkle (pruebas de inclusión y consistencia) cuando la lista crezca.
- Si se funden en uno el BIND de la lista y el índice de nombres `documents.geul`; firma del índice.
- Prevención de retrocesos por Issuer. Como las listas forman una cadena independiente por documento, un ataque que presente como actual solo una lista antigua de un documento solo se frena con la cadena de ese documento.

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [BIND](/es/grammar/edge/bind/), [DOC-POINTER](/es/grammar/reference/doc-pointer/)
- [Issuer y publicación](/es/grammar/issuer/), [Direcciones de publicación y lista de versiones](/es/grammar/publishing/), [Documento](/es/grammar/document/)
