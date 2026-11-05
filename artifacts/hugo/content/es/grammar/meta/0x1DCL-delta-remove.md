---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "En un diff (DELTA-BASE), indica los LOCAL ID (Edge Id) de los registros que se quitan del BODY de la instantánea base (como «se elimina el artículo X»)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `DELTA-REMOVE` (BIND del documento de especificación `DELTA-REMOVE`) |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| Documento de especificación | `0x00000000/codecs/0x00001DC0/` (destino de DECLARE `1DC0`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 28 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Lista de LOCAL ID (Edge Id) que el diff quita del BODY base |
| Lado Hugo | `meta/lineage/delta-remove.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | valor en bruto restante (`0xFFFF`) |  |  |

En un diff ([DELTA-BASE](0x1DBL-delta-base.md)), indica los LOCAL ID (Edge Id) de los registros que se quitan del BODY de la instantánea base («se elimina el artículo X»).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[TAG de extensión de Length]
LOCAL ID a eliminar    registro Reference LOCAL × 1 o más
```

- Codec: Meta `0x1DCL`, clase de linaje
- Payload: uno o más registros Reference [LOCAL](../reference/0x005L-local.md)
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Se pone solo en documentos que tienen `DELTA-BASE`.
- Cada LOCAL ID debe ser un Edge Id presente en el BODY de la instantánea base. Si no, es invalid. Poner el mismo ID dos veces es invalid.
- Volver a poner el mismo Edge Id en el BODY del mismo diff es invalid (no se puede eliminar y revisar a la vez).
- Un LOCAL ID eliminado no se vuelve a asignar a otro objetivo en versiones posteriores ([revisión](../document.md#개정)).
- Que el BODY del diff no tenga un registro significa «sin cambios». Por eso la eliminación se expresa solo con este Meta.
- No se escribe el Edge de HEAD (el [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) de todo el documento y su QUALIFIER). El HEAD se sustituye por entero por el HEAD del diff ([almacenamiento de diff](../document.md#diff-저장)).

## Ejemplo {#예시}

Eliminar los LOCAL `#7` y `#12`:

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4` (Meta `0x1DCL`, `LLLL=0100`, 5 WORD), Reference LOCAL `0051 0007`, `0051 000C`.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001DC0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
