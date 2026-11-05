---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara la edición de la especificación GEUL a la que se ajusta el documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `SPEC-VERSION` (BIND del documento de especificación `SPEC-VERSION`) |
| TAG ID | `0x1C5L` |
| Codec ID | `0x00001C50` |
| Documento de especificación | `0x00000000/codecs/0x00001C50/` (destino de DECLARE `1C50`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 5 |
| Kind | Meta · clase: definición |
| TAG WORD | `0001 1100 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Edición de la especificación GEUL a la que se ajusta. El Payload es directamente un entero unsigned del ancho más corto. v1 es `0x0001` (registro `0x1C51 0x0001`) |
| Lado Hugo | `meta/declaration/spec-version.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | valor en bruto restante (`0xFFFF`) |  |  |

Declara la edición de la especificación GEUL a la que se ajusta el documento. Este valor determina cómo se leen los demás registros.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[TAG de extensión de Length]
Payload           edición de la especificación. v1 = 0x0001
```

- Codec: Meta `0x1C5L`, clase de definición
- Payload: valor en bruto (entero unsigned del ancho más corto)
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- No se apoya en códigos de Value. Para que el decodificador de cualquier edición pueda leerlo, se pone solo un entero, sin Value incorporado.
- Si la edición es desconocida, el decodificador la rechaza o emite una advertencia.
- Si falta, el decodificador lee con la edición que conoce. Los documentos publicados lo indican.

## Ejemplo {#예시}

- `0x1C51 0x0001`: GEUL v1

## Problemas abiertos {#열린-문제}

- Correspondencia con la versión del documento del libro de códigos de Codec ([documento de especificación](../codec-spec.md)).

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001C50/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
