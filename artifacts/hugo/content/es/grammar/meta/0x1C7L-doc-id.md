---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara el identificador de este documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `DOC-ID` (BIND del documento de especificación `DOC-ID`) |
| TAG ID | `0x1C7L` |
| Codec ID | `0x00001C70` |
| Documento de especificación | `0x00000000/codecs/0x00001C70/` (destino de DECLARE `1C70`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 7 |
| Kind | Meta · clase: definición |
| TAG WORD | `0001 1100 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Identificador de este documento. Reference incorporado `DOC-POINTER` (Issuer, ID de documento, versión 0). Un documento de Codec usa `CODEC-POINTER` (Issuer, Codec ID, versión 0) |
| Lado Hugo | `meta/declaration/doc-id.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | registro | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

Declara el identificador de este documento. Hace falta para que otros documentos puedan señalar este documento y los objetivos que contiene.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[TAG de extensión de Length]
Documento         registro Reference DOC-POINTER. (Issuer, ID de documento, versión 0). Un documento de Codec usa CODEC-POINTER
```

- Codec: Meta `0x1C7L`, clase de definición
- Payload: un Reference incorporado [DOC-POINTER](../reference/0x041L-doc-pointer.md) (Issuer, ID de documento, versión 0)
- Cantidad: como máximo uno. Es obligatorio en los documentos de versión bajo `docs/<ID de documento>/` y `codecs/<Codec ID>/`

## Interpretación y validez {#해석과-유효성}

- El Payload es exactamente un registro Reference `DOC-POINTER` (Issuer, ID de documento, versión `0`). Del ID de versión solo se usa `0`. La versión la asigna la lista de versiones, no el documento. Un documento de Codec usa `CODEC-POINTER` (Issuer, Codec ID, versión `0`) ([CODEC-POINTER](../reference/0x042L-codec-pointer.md)).
- Por eso la notación que señala «este documento» es la misma en DOC-ID, en el registro PUBLICATION de la lista de versiones y en las citas de otros documentos.
- Con independencia de la versión, el mismo documento tiene el mismo `DOC-ID`. El ID de versión y el hash de contenido no se escriben en el documento ([versión](../document.md#버전)).
- No existe dirección por nombre de documento ([direcciones de publicación y lista de versiones](../publishing.md#문서-이름)). El título legible por personas lo asume el [LABEL](../edge/0x0A4L-label.md) de enunciado.
- Si falta, es un documento sin nombre y solo se le puede señalar por hash de contenido. Hace falta para que otro documento pueda señalar un LOCAL de este con un Reference de señalamiento.
- Quien obtiene un documento verifica que el `DOC-ID` del documento recibido coincida con el Issuer y el ID de documento solicitados.
- El ID de documento `0x0000000000000000` es el documento índice de definiciones de términos del Issuer ([Issuer](../issuer.md)). Este documento también es un documento de versión bajo `docs/<ID de documento>/`, así que lleva DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). El propio Issuer lo representa [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- `DOC-ID` es obligatorio en los documentos de versión `<ID de versión>.geul` (incluidos los documentos de especificación) de `<Issuer>/docs/<ID de documento>/` y `<Issuer>/codecs/<Codec ID>/` bajo `.well-known/geul/`.
- Los documentos de lista son la excepción y no llevan `DOC-ID`: la lista de versiones `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md)) y la versión `<ID de versión>.geul` de la lista de Issuer `issuers/` ([direcciones de publicación y lista de versiones](../publishing.md#목록-문서)). De qué es lista lo dice el DOC-POINTER del registro. La versión de un documento de lista la señala el PUBLICATION de su `versions.geul` con un DOC-POINTER (`0x00000000`, ID de documento reservado, ID de versión). La dirección por hash de contenido `<Issuer>/hashes/` es copia de los documentos anteriores y sigue al original.
- El ID de documento `0xFFFFFFFFFFFFFFFF` está reservado en todos los Issuer (igual que `0x0000000000000000`) y se usa en la lista de Issuer del Issuer `0x00000000`. Los demás Issuer no lo usan. Como los documentos de lista no tienen `DOC-ID`, este valor solo aparece en el DOC-POINTER del registro de `issuers/versions.geul`.
- El documento de especificación de Codec es un documento de Codec del Issuer GEUL `0x00000000`. No tiene ID de documento y lleva como `DOC-ID` un CODEC-POINTER (`0x00000000`, Codec ID, `0`). El Codec ID es el TAG WORD de Kind·Codec escrito en 32 bits (`0x0B80` → `0x00000B80`) ([documento de especificación](../codec-spec.md)).

## Ejemplo {#예시}

- Issuer `0x00000002`, documento `0x…0005`: `1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000` (TAG de Meta 1 + TAG de Reference 1 + Issuer 2 + ID de documento 4 + versión 2 = 10 WORD)

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001C70/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
