---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Indica la confianza de todo el documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `CONFIDENCE` (BIND del documento de especificación `CONFIDENCE`) |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| Documento de especificación | `0x00000000/codecs/0x00001E80/` (destino de DECLARE `1E80`) |
| Sección | 15 `1111` (Meta), desplazamiento C dentro de la sección = 8 |
| Kind | Meta · clase: verificación |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Confianza |
| Lado Hugo | `meta/verification/confidence.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | registro | `0690` UNSIGNED-DECIMAL |  |

Indica la confianza de todo el documento. La confianza por registro se escribe como un QUALIFIER que se añade al Edge objetivo (la propiedad está por decidir, [SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[TAG de extensión de Length]
Payload           Value UNSIGNED-DECIMAL, de 0 a 1
```

- Codec: Meta `0x1E8L`, clase de verificación
- Payload: Value incorporado ([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Quién asignó el valor se anota junto con [GENERATED-BY](0x1D3L-generated-by.md), etc.

## Problemas abiertos {#열린-문제}

- La escala (0 a 1) y su relación con el veredicto de TOULMIN.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001E80/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
