---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indica el nombre inmutable asignado a una versión (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `TAG` (BIND del documento de especificación `TAG`) |
| TAG ID | `0x1DAL` |
| Codec ID | `0x00001DA0` |
| Documento de especificación | `0x00000000/codecs/0x00001DA0/` (destino de DECLARE `1DA0`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 26 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Nombre inmutable asignado a una versión. Value TEXT y hash de contenido (git annotated tag) |
| Lado Hugo | `meta/lineage/tag.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | registro | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | registro | `07C0` SHA-256-DIGEST, `0000` ABSENT (campo opcional) |  |

Indica el nombre inmutable asignado a una versión (git annotated tag).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[TAG de extensión de Length]
Nombre            Value UTF8-TEXT-*
Objetivo          Value SHA-256-DIGEST, o marca de omisión 0x0000 (campo opcional). Si se omite, esta versión
```

- Codec: Meta `0x1DAL`, clase de linaje
- Payload: Value incorporado (texto + hash de contenido opcional)
- Cantidad: varios posibles

## Interpretación y validez {#해석과-유효성}

- El nombre es [UTF8-TEXT](../value/0x072L-utf8-text.md) y el objetivo es [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md).
- Si se omite el objetivo (ABSENT `0x0000`, campo opcional de [CODEC](../edge/0x0BEL-codec.md)), es un nombre asignado a este mismo documento. Un documento no puede escribir dentro de sí su propio hash de contenido. La especificación `0x1DA0` de geul.org es de dos campos de registro: name (`0720`, `0730`) y target (`07C0`, `0000`).
- El mismo nombre no se reutiliza en otra versión.

## Ejemplo {#예시}

- Nombre `v1`, esta versión: `1DA3 0721 7631 0000`

## Problemas abiertos {#열린-문제}

- Si TAG sigue siendo necesario existiendo el ID de versión (número de orden).

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001DA0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
