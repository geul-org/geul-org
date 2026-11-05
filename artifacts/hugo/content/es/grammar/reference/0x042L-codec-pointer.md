---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER es un Reference de designación y declaración que señala una versión de un documento de Codec publicado por un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER es un Reference de designación y declaración que señala una versión de un documento de Codec publicado por un Issuer. El documento de Codec no tiene ID de documento y se señala a sí mismo y su versión con CODEC-POINTER.

| Elemento | Valor |
|---|---|
| Nombre | `CODEC-POINTER` (BIND `CODEC-POINTER` del documento de especificación) |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| Documento de especificación | `0x00000000/codecs/0x00000420/` (destino de DECLARE `0420`) |
| Sección | 2 `0010` (Reference otros), desplazamiento dentro de la sección C = 2 |
| Kind | Reference · clasificación: designación y declaración |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Una versión de un Codec del Issuer. Issuer + Codec ID de 2 WORD + ID de versión de 2 WORD, sin ID de destino |
| Lado Hugo | `reference/codec-pointer.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | resto en valor en bruto (`0xFFFF`) |  |  |
| 2 | `codec` | #3 | valor en bruto de 2 WORD |  |  |
| 3 | `version` | #4 | valor en bruto de 2 WORD |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[TAG de extensión de Length]
Issuer            2/4/16 WORD
Codec ID          2 WORD
ID de versión     2 WORD
```

## Interpretación y validez {#해석과-유효성}

- El ancho del Issuer es el resto del Payload tras restar los 4 WORD del Codec ID y el ID de versión. El Payload es de 6, 8 o 20 WORD y cualquier otra longitud es invalid. Es invalid si el valor del Issuer cabe en un ancho más estrecho (forma canónica del Issuer).
- Si el Issuer es de 16 WORD, son 21 WORD en total y se añade 1 WORD de extensión de Length.
- El Codec ID es de 32 bits. El Codec ID de un código directo de GEUL es el valor de su TAG WORD (L=0) escrito en 32 bits (TRIPLE `0x0AAL` → `0x00000AA0`). El Codec ID de un Codec de Issuer es el número de Codec del registro, y el Issuer lo fija sin solaparse dentro de su `codecs/`, con independencia del Kind ([Direcciones de publicación y lista de versiones](../publishing.md#id-표기)).
- El ID de versión `0` es la versión más reciente. Cualquier otro valor queda fijado a esa versión.
- Es una sola casilla, el Codec `0x042L`. No hay cuantificación (Identified). Al ser la sección 2, no se lee como cuantificación ni como sistema.
- Dónde se usa: el Meta [DOC-ID](../meta/0x1C7L-doc-id.md) del documento de Codec, [PUBLICATION](../edge/0x0B8L-publication.md), DEPRECATION y TOMBSTONE de la lista de versiones de Codec, e [IMPORT-DOC](../meta/0x1E4L-import-doc.md) que importa un documento de Codec. En estas posiciones sustituye a DOC-POINTER.
- La dirección de publicación es `/.well-known/geul/<Issuer>/codecs/<Codec ID>/<ID de versión>.geul` ([Direcciones de publicación y lista de versiones](../publishing.md#공표-주소)).

## Ejemplo {#예시}

Codec TRIPLE del Issuer GEUL `0x00000000` (Codec ID `0x00000AA0`).

| Versión | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| Más reciente (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + Codec ID 2 + ID de versión 2 = 7 WORD, `LLLL=0110`. El TAG es `0000 0100 0010 0110` = `0426`.

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [Documento de especificación de Codec](../codec-spec.md)
- [Direcciones de publicación y lista de versiones](../publishing.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000420/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
