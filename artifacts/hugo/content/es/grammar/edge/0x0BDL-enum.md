---
title: "ENUM (0x0BDL)"
weight: 189
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM es un Edge de enunciado que da significado a un código de un campo de valor en bruto."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `ENUM` (BIND del documento de especificación `ENUM`) |
| TAG ID | `0x0BDL` |
| Codec ID | `0x00000BD0` |
| Documento de especificación | `0x00000000/codecs/0x00000BD0/` (destino de DECLARE `0BD0`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 29 |
| Kind | Edge · familia: enunciado, grupo: otros |
| TAG WORD | `0000 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Un código de un campo de valor en bruto. Campo, código |
| Lado Hugo | `edge/enum.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | registro | `0050` LOCAL |  |
| 2 | `code` | #3 | resto de valor en bruto (`0xFFFF`) |  |  |

ENUM es un Edge de enunciado que da significado a un código de un campo de valor en bruto. Codec `0x0BDL`.

Junto con [FIELD](0x0BCL-field.md), es el vocabulario para escribir especificaciones de Codec. El layout se integra en el decodificador ([documento de especificación de Codec](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1101 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
campo             registro Reference LOCAL que señala el Edge FIELD
código            valor en bruto. Mismo número de WORD que el ancho de ese FIELD
```

## Interpretación y validez {#해석과-유효성}

- El campo debe ser un FIELD de valor en bruto (ancho `n ≥ 1`). No se añade ENUM a un campo de registro. El significado de un registro lo dice el Codec de ese registro.
- El código tiene exactamente el ancho de ese FIELD. El límite se comprueba con el Length del registro ENUM.
- En un campo no se declara dos veces el mismo código.
- El nombre del código se liga al Edge Id de ENUM con [BIND](0x0A3L-bind.md). Todo UTF8-TEXT que se pone en DECLARE, FIELD, ENUM y CODEC se hace con BIND, y no se pone con otros Edge como LABEL.
- Un código no declarado no es un error. El visor lo muestra como valor en bruto. Si se cierra o no el conjunto de valores admitidos lo decide la especificación del Codec; el vocabulario actual no tiene una marca para cerrarlo.

## Longitud {#길이}

```
total = 1 + N_len + N_id + N_field + n WORD
```

## Ejemplo (no normativo) {#예시-비규범}

Se declara el código `0x0001` en el campo de categoría de motivo (FIELD #4, valor en bruto 1 WORD) del documento de especificación de TOMBSTONE. Edge Id 10. El nombre se liga aparte con BIND. Como la tabla de códigos de la categoría de motivo aún no está fijada, el código es un ejemplo.

- TAG 1 + Edge Id 2 + campo 2 + código 1 = 6 WORD, `LLLL = 0101`.

```
0BD5 0051 000A 0051 0004 0001
```

El documento de especificación de TRIPLE pone tres ENUM (`0`·`1`·`2`) en el campo Rank (FIELD #5) y los liga con BIND a `normal`·`preferred`·`deprecated` ([TRIPLE](0x0AAL-triple.md)).

## Páginas relacionadas {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [FIELD](0x0BCL-field.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [documento de especificación de Codec](../codec-spec.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000BD0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BD000000000
BODY
#1 DECLARE 0x0BD0
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "ENUM"
#5 BIND #2 "field"
#6 BIND #3 "code"
#7 CODEC #2 0x0050
```
