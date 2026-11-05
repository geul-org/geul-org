---
title: "FIELD (0x0BCL)"
weight: 188
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD es un Edge de enunciado que declara un campo del Payload de un Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `FIELD` (BIND del documento de especificación `FIELD`) |
| TAG ID | `0x0BCL` |
| Codec ID | `0x00000BC0` |
| Documento de especificación | `0x00000000/codecs/0x00000BC0/` (destino de DECLARE `0BC0`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 28 |
| Kind | Edge · familia: enunciado, grupo: otros |
| TAG WORD | `0000 1011 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Un campo del Payload. DECLARE al que pertenece, ancho: registro (Length del TAG) o valor en bruto de n WORD |
| Lado Hugo | `edge/field.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `declare` | #2 | registro | `0050` LOCAL |  |
| 2 | `width` | #3 | valor en bruto 1 WORD |  | `0x0000` record, `0xFFFF` rest |

FIELD es un Edge de enunciado que declara un campo del Payload de un Codec. Codec `0x0BCL`.

FIELD señala su propio [DECLARE](0x0BBL-declare.md). Los FIELD que señalan un mismo DECLARE componen el Payload en el orden en que están en el documento. El layout se integra en el decodificador ([documento de especificación de Codec](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1100 LLLL
Edge Id           registro Reference LOCAL
DECLARE           registro Reference LOCAL. El Edge DECLARE al que pertenece este campo
ancho             1 WORD. 0 = registro, n (1~65534) = valor en bruto de n WORD, 0xFFFF = resto de valor en bruto
```

## Interpretación y validez {#해석과-유효성}

- DECLARE señala un Edge DECLARE del mismo documento. Un FIELD pertenece a un solo DECLARE. El orden no se escribe aparte; es el orden en que los registros FIELD están colocados en el documento.
- El documento de especificación de FIELD declara DECLARE como un campo de ancho `0` (registro), CODEC `0050` (LOCAL). Por eso en el grafo del visor se dibuja como una conexión FIELD → DECLARE.
- El ancho `0` es un campo de registro. Empieza con un TAG WORD y se lee tantos WORD como indica el Length de ese TAG (reglas de interpretación de [DECLARE](0x0BBL-declare.md)).
- El ancho `n` (1~65534) es un campo de valor en bruto. Siempre son exactamente n WORD.
- El ancho `0xFFFF` es el resto de valor en bruto. Se pone uno solo en un DECLARE y puede estar al principio, en medio o al final. El ancho es el valor que queda de los WORD restantes fijados por el Length del TAG del registro exterior tras restar los anchos de los campos posteriores. Por eso todos los campos tras un campo de resto deben ser valores en bruto de ancho fijo (un registro solo se sabe dónde acaba leyéndolo desde el principio). Puede ser 0 WORD. No se le añade ENUM.
- El Kind·Codec que acepta un campo se especifica con [CODEC](0x0BEL-codec.md). Un campo de registro, si no hay CODEC, acepta cualquier registro, y si lo hay, debe ser uno de ellos. Si a un campo de valor en bruto se le pone un CODEC, ese valor en bruto se interpreta como ese Value sin el TAG.
- El nombre de un campo se liga al Edge Id de FIELD con [BIND](0x0A3L-bind.md) (por ejemplo, `doc`, `hash`). Todo UTF8-TEXT que se pone en DECLARE, FIELD, ENUM y CODEC se hace con BIND, y no se pone con otros Edge como LABEL.
- El significado de los códigos de un campo de valor en bruto se añade con [ENUM](0x0BDL-enum.md).
- Un campo que señala otro nodo del grafo no se marca aparte. Si un campo de registro es una Reference, esa es la conexión.

## Longitud {#길이}

```
total = 1 + 2 + 2 + 1 WORD   (cuando Edge Id y DECLARE son un ID LOCAL de 1 WORD)
```

## Ejemplo (no normativo) {#예시-비규범}

- Campo de registro: Edge Id 7, DECLARE #1, ancho `0`. TAG 1 + Edge Id 2 + DECLARE 2 + ancho 1 = 6 WORD. Para que acepte solo LOCAL, véase el ejemplo de [CODEC](0x0BEL-codec.md).

```
0BC5 0051 0007 0051 0001 0000
```

- Para un campo de valor en bruto como un hash de contenido, véase el ejemplo de [DECLARE](0x0BBL-declare.md).

## Páginas relacionadas {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [documento de especificación de Codec](../codec-spec.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000BC0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BC000000000
BODY
#1 DECLARE 0x0BC0
#2 FIELD #1 record
#13 CODEC #2 0x0050
#3 FIELD #1 0x0001
#5 ENUM #3 0x0000
#6 ENUM #3 0xFFFF
#7 BIND #1 "FIELD"
#8 BIND #2 "declare"
#9 BIND #3 "width"
#11 BIND #5 "record"
#12 BIND #6 "rest"
```
