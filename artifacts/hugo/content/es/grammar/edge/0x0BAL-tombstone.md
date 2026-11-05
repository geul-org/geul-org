---
title: "TOMBSTONE (0x0BAL)"
weight: 186
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION y TOMBSTONE son Edge de enunciado que registran la publicación, la recomendación de desuso y la eliminación de versiones de un documento, y esta página fija además la especificación del documento de lista de versiones que se escribe con esos Edge (Codec 0x0B8L~0x0BAL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION, DEPRECATION y TOMBSTONE son Edge de enunciado que registran la publicación, la recomendación de desuso y la eliminación de versiones de un documento, y esta página fija además la especificación del documento de lista de versiones que se escribe con esos Edge (Codec 0x0B8L~0x0BAL).

| Elemento | Valor |
|---|---|
| Nombre | `TOMBSTONE` (BIND del documento de especificación `TOMBSTONE`) |
| TAG ID | `0x0BAL` |
| Codec ID | `0x00000BA0` |
| Documento de especificación | `0x00000000/codecs/0x00000BA0/` (destino de DECLARE `0BA0`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 26 |
| Kind | Edge · familia: enunciado, grupo: otros |
| TAG WORD | `0000 1011 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Eliminación (lápida) de una versión publicada. DOC-POINTER, categoría de motivo |
| Lado Hugo | `edge/publication.md` (esa página trata también [PUBLICATION](0x0B8L-publication.md) y [DEPRECATION](0x0B9L-deprecation.md)) |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | registro | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `reason` | #4 | valor en bruto 1 WORD |  |  |

Es la especificación de los Edge de enunciado que registran la publicación, el desuso (deprecate) y la eliminación de un documento, y del documento de lista de versiones que se escribe con esos Edge. Fija el formato de la lista de versiones de [dirección de publicación y lista de versiones](../publishing.md#버전-목록).

## Códigos {#코드}

| Codec | Nombre | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id, DOC-POINTER, hash de contenido |
| `0x0B9L` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id, DOC-POINTER, categoría de motivo |

- Los tres códigos se integran en el decodificador ([capa 0](../publishing.md#층)). La lista de versiones se interpreta sin consultar el libro de codecs.
- No hay subformatos (TAG propio del Codec). Se mantiene tal cual la regla de [Edge](_index.md) de que el primer elemento del Payload es el Edge Id.

## Layout {#레이아웃}

```
TAG WORD             Edge, Codec 0x0B8L / 0x0B9L / 0x0BAL
[TAG de extensión de Length]
Edge Id              registro Reference LOCAL
documento            registro Reference DOC-POINTER (Issuer, ID de documento, ID de versión). La lista de versiones de un codec usa CODEC-POINTER
hash de contenido    16 WORD   (PUBLICATION)
categoría de motivo  1 WORD    (TOMBSTONE)
```

| Campo | Ancho | Descripción |
|---|---|---|
| Edge Id | registro Reference LOCAL | Número de orden dentro de la lista. Se asigna desde 1 y se encadena |
| documento | registro DOC-POINTER | Una versión del documento publicado ([DOC-POINTER](../reference/0x041L-doc-pointer.md)). El Issuer y el ID de documento son los del documento que trata esa lista. Hace que el documento de lista diga de qué es lista incluso sin ruta. El ID de versión es el número de orden dentro de ese documento (versión de [documento](../document.md)) y no se usa `0` (la más reciente). La lista de versiones de un codec usa [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID de versión) |
| hash de contenido | 16 WORD | Hash de contenido de esa versión (SHA-256, hash de contenido de [documento](../document.md)) |
| categoría de motivo | 1 WORD | Código de categoría del motivo de eliminación. La tabla de códigos es un problema abierto |

- La longitud tras DOC-POINTER es fija para cada código (16, 0, 1 WORD). Si es distinta, se rechaza.
- No se pone la hora en el registro. El `RECORDED-AT` del documento de lista donde se registró por primera vez ese registro es la hora de publicación, deprecate o eliminación.

## Documento de lista de versiones {#버전-목록-문서}

El publicador mantiene encadenado un documento de lista de versiones por cada documento: `/<Issuer>/docs/<ID de documento>/versions.geul` (para un codec, `/<Issuer>/codecs/<Codec ID>/versions.geul`; para la lista de Issuer, [más abajo](#목록-문서의-버전-목록)). En una sola lista entran todas las versiones de ese documento publicadas por ese publicador.

```
DOC-1WORD/2WORD/4WORD     longitud total
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value SHA-256-DIGEST. Hash de contenido del documento de lista anterior (si es la primera lista, no hay)
  RECORDED-AT             Value POSIX-TIMESTAMP-SECONDS. Momento en que se emitió esta lista
  NEXT-LOCAL-ID           Siguiente LOCAL ID a asignar (si hay versiones)
  SIGNATURE               Firma del publicador. El objetivo es el hash de contenido de este documento de lista
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- Meta de HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PARENT](../meta/0x1D1L-parent.md), [RECORDED-AT](../meta/0x1D0L-recorded-at.md), [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md), [SIGNATURE](../meta/0x1E6L-signature.md).
- El documento de lista de versiones no lleva `DOC-ID` (excepción de los documentos de lista, [DOC-ID](../meta/0x1C7L-doc-id.md)). La lista no es un documento publicado sino un registro anejo a ese documento. De qué documento es la lista lo dice el DOC-POINTER (ID de documento) del registro. Por eso, aunque se reciba sin ruta (`hashes/`, volcado), se sabe de qué es la lista.
- Todos los ID de documento de los registros deben ser el del documento que trata esa lista. Se rechazan los registros de otros documentos.
- El documento de lista de versiones no lleva IMPORT y usa solo Codec de capa 0. En BODY solo hay PUBLICATION·DEPRECATION·TOMBSTONE. No lleva BIND de nombre de documento ([dirección de publicación y lista de versiones](../publishing.md#문서-이름)).
- El nuevo documento de lista conserva delante, tal cual, el BODY del documento de lista anterior y le añade registros. No modifica, no borra ni reordena.
- El publicador firma la lista. La publicación de geul.org la firma geul.org (Issuer GEUL), y la publicación privada la firma su Issuer.
- El ID de documento `0x0000000000000000` es el documento índice de definición de términos del Issuer ([Issuer y publicación](../issuer.md)). El propio Issuer se señala con [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).

## Lista de versiones del documento de lista {#목록-문서의-버전-목록}

El documento de lista es uno solo, la lista de Issuer `issuers/` ([dirección de publicación y lista de versiones](../publishing.md#목록-문서)). La lista de Issuer también empieza en la versión 1 y tiene la lista de versiones `issuers/versions.geul`. El registro señala la versión de la lista con el DOC-POINTER del ID de documento reservado (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, ID de versión).

- El formato del registro es el mismo de arriba. Por eso, aunque se reciba por `hashes/`, se sabe de qué es la lista.
- El propio documento de lista (`<ID de versión>.geul`) tampoco lleva `DOC-ID`.
- El ID de documento `0xFFFFFFFFFFFFFFFF` no se recibe en ningún Issuer con la dirección `<Issuer>/docs/<ID de documento>/` (404).
- El `latest.geul` de la lista es un alias que no se almacena. Busca la versión más reciente en esta lista de versiones y emite sus bytes.

## Reglas {#규칙}

- El ID de versión de PUBLICATION va en orden ascendente desde 1 sin saltos. El ID de versión lo asigna el publicador.
- No se vuelve a publicar el mismo hash de contenido. Si ya existe, se devuelve ese ID de versión.
- DEPRECATION y TOMBSTONE solo señalan el ID de versión de un PUBLICATION anterior. Si señalan una versión inexistente, se rechaza.
- El estado de una versión se calcula aplicando los registros en orden. publicada → deprecated → eliminada. Una versión eliminada no se vuelve a publicar ni se entrega.
- La versión más reciente es el ID de versión más alto que no es deprecated ni eliminado.
- Cuando el ID de versión llega al final de 2 WORD, ese documento no se publica más y se emite con un nuevo ID de documento.

## Direcciones {#주소}

```
/.well-known/geul/<Issuer>/docs/<ID de documento>/versions.geul        último documento de lista (mutable)
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul             último documento de lista del codec (mutable)
/.well-known/geul/issuers/versions.geul                       última lista de versiones de la lista de Issuer (mutable)
/.well-known/geul/<Issuer>/hashes/<hash de contenido>.geul             documentos de lista anteriores (inmutable)
```

- Lo mutable es la dirección de la última lista. La lista recibida se verifica con la firma, `RECORDED-AT` y la cadena `PARENT`.
- Todos los documentos de lista anteriores se conservan en `<Issuer>/hashes/`. Siguiendo la cadena `PARENT` se puede reconstruir la lista de cualquier momento.

## Verificación {#검증}

- El documento de lista debe tener la `SIGNATURE` de la clave del publicador establecida.
- El ID de documento de los registros debe ser igual al ID de documento solicitado.
- El hash de contenido de la lista anterior que queda en el registro de bloqueo debe estar en la cadena `PARENT` de la nueva lista. El BODY de esa lista debe ser igual a la parte inicial del BODY de la nueva lista.
- El hash de contenido del documento recibido debe ser igual al valor escrito en el PUBLICATION de ese ID de versión, y el `DOC-ID` del documento debe ser igual al Issuer y al ID de documento solicitados. El documento de lista no tiene `DOC-ID`.

## Problemas abiertos {#열린-문제}

- Tabla de códigos de la categoría de motivo.
- Valor por defecto del algoritmo de firma y layout del Payload de `SIGNATURE`.
- Cuándo y en qué formato pasar a un registro Merkle (pruebas de inclusión y consistencia) cuando la lista crezca.
- Prevención de retroceso a nivel de Issuer. Como la lista forma una cadena aparte por cada documento, el ataque de presentar como antigua solo la lista de un documento se bloquea únicamente con la cadena de ese documento.

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [BIND](0x0A3L-bind.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer y publicación](../issuer.md), [dirección de publicación y lista de versiones](../publishing.md), [documento](../document.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000BA0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BA000000000
BODY
#1 DECLARE 0x0BA0
#2 FIELD #1 record
#9 CODEC #2 0x0410
#4 FIELD #1 0x0001
#5 BIND #1 "TOMBSTONE"
#6 BIND #2 "doc"
#8 BIND #4 "reason"
#10 CODEC #2 0x0420
```
