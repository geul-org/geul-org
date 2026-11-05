---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE es un Edge de enunciado de identidad, sin dirección, que declara que dos Reference señalan el mismo referente."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `SAME-NODE` (BIND del documento de especificación `SAME-NODE`) |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| Documento de especificación | `0x00000000/codecs/0x00000A10/` (destino de DECLARE `0A10`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 1 |
| Kind | Edge · familia: enunciado, grupo: señalamiento y nombre |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Identidad en la que dos Reference señalan el mismo objeto |
| Lado Hugo | `edge/same-node.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | cualquier registro (excepto marcadores de posición) |  |
| 2 | `object` | #3 | registro | cualquier registro (excepto marcadores de posición) |  |

SAME-NODE es un Edge de enunciado de identidad, sin dirección, que declara que dos Reference señalan el mismo referente. Codec `0x0A1L`.

No significa que la codificación en bytes, el Codec o el ID de los dos registros Reference sean iguales. A diferencia de [REFERENCE-NODE](0x0A0L-reference-node.md), que es un vínculo direccional `Reference → registro`, SAME-NODE expresa la identidad (referential identity) entre dos Reference.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference
```

## Interpretación y validez {#해석과-유효성}

- Subject y Object se serializan en este orden, y cada uno debe ser exactamente un registro [Reference](../reference/_index.md) completo. El límite se encuentra con el Length de cada registro.
- Si Subject u Object es un Value, un Edge o un registro incompleto, es invalid.
- La relación SAME-NODE es reflexiva, simétrica y transitiva. El orden Subject/Object en el wire es para el framing y no crea dirección semántica. Una implementación debe poder recorrer esta relación en ambos sentidos.
- Distintos ID [LOCAL](../reference/0x005L-local.md) son solo Reference distintas, no prueba de que el referente sea igual o distinto. Que dos Reference señalan el mismo referente se establece con SAME-NODE.
- La interpretación y la inferencia deben conservar la procedencia, el momento, el world y el policy scope del documento que contiene ese Edge y del grafo de veredicto. SAME-NODE no se usa como base de una fusión global independiente del contexto.
- Aunque exista SAME-NODE, no se borran ni se sobrescriben los registros Reference originales ni el linaje.
- Que SAME-NODE y [DIFFERENT-NODE](0x0A2L-different-node.md) coexistan para el mismo par no hace invalid al wire. Se conserva el contexto de cada afirmación y se evalúa como conflicto.
- Una Reference Variable se une con una Reference Identified mediante SAME-NODE para resolver la variable ([Reference](../reference/_index.md) Variable).

## Longitud {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Ejemplo (no normativo) {#예시-비규범}

Edge Id `0009`, Subject es LOCAL 1, Object es LOCAL 2.

- El Edge es TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. El TAG es `0000 1010 0001 0110` = `0A16`.

```
0A16 0051 0009 0051 0001 0051 0002
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000A10/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
