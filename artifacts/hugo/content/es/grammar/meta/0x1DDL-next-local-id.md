---
title: "NEXT-LOCAL-ID (0x1DDL)"
weight: 477
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indica el LOCAL ID que la versión siguiente del documento asignará a un nuevo enunciado (el auto increment de un DBMS, AUTO_INCREMENT de MySQL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `NEXT-LOCAL-ID` (BIND del documento de especificación `NEXT-LOCAL-ID`) |
| TAG ID | `0x1DDL` |
| Codec ID | `0x00001DD0` |
| Documento de especificación | `0x00000000/codecs/0x00001DD0/` (destino de DECLARE `1DD0`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 29 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Próximo LOCAL ID a asignar (auto increment). Se pone en el HEAD de la lista de versiones `versions.geul` |
| Lado Hugo | `meta/lineage/next-local-id.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `next` | #2 | valor en bruto restante (`0xFFFF`) |  |  |

Indica el LOCAL ID que la versión siguiente del documento asignará a un nuevo enunciado (el auto increment de un DBMS, `AUTO_INCREMENT` de MySQL). Todos los LOCAL ID asignados en cualquier versión del documento son menores que este valor.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1101 LLLL      Codec 0x1DDL
Payload           próximo LOCAL ID a asignar, entero unsigned del ancho más corto
```

- Codec: Meta `0x1DDL`, clase de linaje
- Payload: valor en bruto (entero unsigned del ancho más corto)
- Cantidad: como máximo uno
- Dónde se pone: en el HEAD del documento de la lista de versiones `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md))

## Interpretación y validez {#해석과-유효성}

- El LOCAL ID (incluido el Edge Id) es una identidad que trasciende las versiones ([revisión](../document.md#개정)). Un nuevo enunciado recibe este valor y el valor aumenta en 1. Un LOCAL ID eliminado no se reutiliza. Por eso, aunque se elimine el enunciado de valor máximo, este valor no disminuye.
- El LOCAL ID `0` no se asigna, así que el primer valor es `1`. Si aún no hay versiones, no se pone este Meta y el siguiente número es `1`.
- Quien publica lo actualiza en el nuevo documento de lista al publicar una versión. Debe ser mayor que cualquier LOCAL ID usado en las versiones publicadas. Si es menor o igual, es invalid.
- El valor solo crece. Si es menor que el del documento de lista anterior ([PARENT](0x1D1L-parent.md)), es invalid.
- No existe en documentos sin control de versiones (documentos sin `versions.geul`, documentos sin nombre). Esos documentos tampoco llevan diff ([DELTA-BASE](0x1DBL-delta-base.md)).
- No se pone en el cuerpo del documento (el documento de versión). Recordar el número no es contenido del documento sino estado de quien publica y continúa el documento (en git, no el commit sino el lado de refs).

## Ejemplo {#예시}

Próximo número a asignar 524:

```
1DD1 020C
```

- TAG `1DD1` (Meta `0x1DDL`, `LLLL=0001`, 2 WORD), Payload `020C`.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001DD0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DD000000000
BODY
#1 DECLARE 0x1DD0
#2 FIELD #1 rest
#3 BIND #1 "NEXT-LOCAL-ID"
#4 BIND #2 "next"
```
