---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER es un Reference de designación y declaración que señala al propio Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `ISSUER-POINTER` (BIND `ISSUER-POINTER` del documento de especificación) |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| Documento de especificación | `0x00000000/codecs/0x00000400/` (destino de DECLARE `0400`) |
| Sección | 2 `0010` (Reference otros), desplazamiento dentro de la sección C = 0 |
| Kind | Reference · clasificación: designación y declaración |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Lado Hugo | `reference/issuer-pointer.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | resto en valor en bruto (`0xFFFF`) |  |  |

ISSUER-POINTER es un Reference de designación y declaración que señala al propio Issuer. Es objeto del `BIND` del nombre del Issuer, de `LABEL` y de los Edge de veredicto.

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[TAG de extensión de Length]
Issuer            2/4/16 WORD
```

- El ancho del Issuer es todo el Payload. El Codec no divide el ancho. Es invalid si el ancho no es 2, 4 o 16 WORD, o si el valor del Issuer cabe en un ancho más estrecho (forma canónica del Issuer).
- Si el Issuer es de 16 WORD, son 17 WORD en total y se añade 1 WORD de extensión de Length.
- Es una sola casilla, el Codec `0x040L`. No hay cuantificación (Identified).
- El valor del Issuer sigue la asignación de [Issuer](../issuer.md).
- Usos: el Subject del BIND de la lista de Issuer `issuers/` ([Direcciones de publicación y lista de versiones](../publishing.md#issuer-목록)), el LABEL del nombre visible del Issuer, los veredictos sobre el Issuer, el firmante y otras posiciones cuyo objeto es el propio Issuer.
- La forma de señalar al propio Issuer es únicamente ISSUER-POINTER. Señalar al Issuer con `EXTERNAL-ISSUER-*` usando ID de documento `0` e ID de destino `0` es invalid.

## Ejemplo {#예시}

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [Issuer y publicación](../issuer.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000400/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
