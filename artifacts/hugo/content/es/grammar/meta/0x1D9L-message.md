---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indica el motivo del cambio (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `MESSAGE` (BIND del documento de especificación `MESSAGE`) |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| Documento de especificación | `0x00000000/codecs/0x00001D90/` (destino de DECLARE `1D90`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 25 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Motivo del cambio. Value UTF8-LANGUAGE-TEXT, uno por idioma (git commit message) |
| Lado Hugo | `meta/lineage/message.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | registro | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Indica el motivo del cambio (git commit message).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[TAG de extensión de Length]
Mensaje           1 Value UTF8-LANGUAGE-TEXT
```

- Codec: Meta `0x1D9L`, clase de linaje
- Payload: Value incorporado ([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- Cantidad: como máximo uno por idioma

## Interpretación y validez {#해석과-유효성}

- El mensaje y el idioma van en un único UTF8-LANGUAGE-TEXT. Hay un solo MESSAGE por idioma.
- El documento de especificación de geul.org lo escribe con [CODEC](../edge/0x0BEL-codec.md) `0780` y `0790`.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001D90/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
