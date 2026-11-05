---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara el fin del período de vigencia de esta versión (ley temporal)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `EFFECTIVE-UNTIL` (BIND del documento de especificación `EFFECTIVE-UNTIL`) |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| Documento de especificación | `0x00000000/codecs/0x00001C90/` (destino de DECLARE `1C90`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 9 |
| Kind | Meta · clase: definición |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Fin del período de vigencia de esta versión (ley temporal). Si falta, hasta que entre en vigor la versión siguiente |
| Lado Hugo | `meta/declaration/effective-until.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | registro | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Declara el fin del período de vigencia de esta versión (ley temporal). Desde ese momento esta versión deja de estar en vigor.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[TAG de extensión de Length]
Payload           un Value TIME
```

- Codec: Meta `0x1C9L`, clase de definición
- Payload: Value incorporado ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) o [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Si falta, es válida hasta que entre en vigor la versión siguiente.
- Pasado el período de vigencia, no hay ninguna edición en vigor. Las ediciones antiguas no reviven.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001C90/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
