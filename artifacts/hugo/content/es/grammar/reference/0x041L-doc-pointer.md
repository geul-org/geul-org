---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER es un Reference de designación y declaración que señala una versión de un documento publicado por un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `DOC-POINTER` (BIND `DOC-POINTER` del documento de especificación) |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| Documento de especificación | `0x00000000/codecs/0x00000410/` (destino de DECLARE `0410`) |
| Sección | 2 `0010` (Reference otros), desplazamiento dentro de la sección C = 1 |
| Kind | Reference · clasificación: designación y declaración |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Lado Hugo | `reference/doc-pointer.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | resto en valor en bruto (`0xFFFF`) |  |  |
| 2 | `doc` | #3 | valor en bruto de 4 WORD |  |  |
| 3 | `version` | #4 | valor en bruto de 2 WORD |  |  |

DOC-POINTER es un Reference de designación y declaración que señala una versión de un documento publicado por un Issuer. Es objeto de la publicación, deprecate y eliminación de documentos, de la edición citada y de los enunciados sobre el documento.

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[TAG de extensión de Length]
Issuer            2/4/16 WORD
ID de documento   4 WORD
ID de versión     2 WORD
```

## Interpretación y validez {#해석과-유효성}

- El ancho del Issuer es el resto del Payload tras restar los 6 WORD del ID de documento y el ID de versión. El Codec no divide el ancho. Es invalid si el ancho no es 2, 4 o 16 WORD, o si el valor del Issuer cabe en un ancho más estrecho (forma canónica del Issuer).
- El ID de versión no se omite. Si se permitiera omitirlo, la longitud del Payload por sí sola no determinaría el ancho del Issuer (Issuer de 4 WORD sin versión e Issuer de 2 WORD con versión darían los mismos 8 WORD).
- El ID de versión `0` es la versión más reciente. Queda atado a la versión vigente en el momento de interpretar. Cualquier otro valor queda fijado a esa versión ([PUBLICATION](../edge/0x0B8L-publication.md)).
- El ID de documento `0` es el documento índice de definición de términos del Issuer. El propio Issuer se señala con [ISSUER-POINTER](0x040L-issuer-pointer.md).
- Todo Issuer reserva los ID de documento `0x0000000000000000` y `0xFFFFFFFFFFFFFFFF` ([Issuer y publicación](../issuer.md#용어-정의-문서)). `0xFFFFFFFFFFFFFFFF` se usa en la lista de Issuer `issuers/` del Issuer `0x00000000` y los demás Issuer no lo usan. PUBLICATION, DEPRECATION y TOMBSTONE de `issuers/versions.geul` señalan con este valor las versiones de la lista ([Direcciones de publicación y lista de versiones](../publishing.md#목록-문서)).
- Es una sola casilla, el Codec `0x041L`. No hay cuantificación (Identified).
- La forma de señalar un documento de un Issuer es únicamente DOC-POINTER. Señalar un documento con `EXTERNAL-ISSUER-*` (Issuer, ID de documento, ID de destino `0`) o con `EXTERNAL-POINTER-*` (IMPORT ID, ID de destino `0`) es invalid.
- Dónde se usa: Meta [DOC-ID](../meta/0x1C7L-doc-id.md) e [IMPORT-DOC](../meta/0x1E4L-import-doc.md), y PUBLICATION, DEPRECATION y TOMBSTONE de la lista de versiones.
- El documento de Codec no tiene ID de documento. El documento de Codec y su versión se señalan con [CODEC-POINTER](0x042L-codec-pointer.md).

## Ejemplo {#예시}

Documento `0xFFFF000000000001` del Issuer GEUL `0x00000000`.

| Versión | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| Más reciente (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + ID de documento 4 + ID de versión 2 = 9 WORD, `LLLL=1000`. El TAG es `0000 0100 0001 1000` = `0418`.

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer y publicación](../issuer.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000410/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
