---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara la fecha de entrada en vigor de esta versión."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `EFFECTIVE-FROM` (BIND del documento de especificación `EFFECTIVE-FROM`) |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| Documento de especificación | `0x00000000/codecs/0x00001C80/` (destino de DECLARE `1C80`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 8 |
| Kind | Meta · clase: definición |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Fecha de entrada en vigor de esta versión. Value GREGORIAN-DATE o POSIX-TIMESTAMP. Si falta, el momento de publicación |
| Lado Hugo | `meta/declaration/effective-from.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | registro | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Declara la fecha de entrada en vigor de esta versión. La fecha de entrada en vigor es distinta del momento de publicación ([revisión](../document.md#개정)).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[TAG de extensión de Length]
Payload           un Value TIME
```

- Codec: Meta `0x1C8L`, clase de definición
- Payload: Value incorporado ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) o [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Si falta, rige desde el momento de publicación.
- Si hay [EFFECTIVE-UNTIL](0x1C9L-effective-until.md), debe ser anterior a él.
- Si la fecha de entrada en vigor difiere por artículo, se escribe aparte en el Edge de ese artículo con los QUALIFIER P580 (inicio) y P582 (fin) ([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).
- Este valor se lee al interpretar el documento en un momento concreto.

## Ejemplo {#예시}

- Vigente desde 1970-01-02: `0x1C83 0x06A2 0x0000 0x0001`

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001C80/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
