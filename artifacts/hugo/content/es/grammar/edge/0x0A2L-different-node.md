---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE es un Edge de enunciado de no identidad que declara que dos Reference señalan referentes distintos."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `DIFFERENT-NODE` (BIND del documento de especificación `DIFFERENT-NODE`) |
| TAG ID | `0x0A2L` |
| Codec ID | `0x00000A20` |
| Documento de especificación | `0x00000000/codecs/0x00000A20/` (destino de DECLARE `0A20`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 2 |
| Kind | Edge · familia: enunciado, grupo: señalamiento y nombre |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | No identidad en la que dos Reference señalan objetos distintos |
| Lado Hugo | `edge/different-node.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | cualquier registro (excepto marcadores de posición) |  |
| 2 | `object` | #3 | registro | cualquier registro (excepto marcadores de posición) |  |

DIFFERENT-NODE es un Edge de enunciado de no identidad: dos Reference señalan referentes distintos. Codec `0x0A2L`.

No significa que la codificación en bytes, el Codec o el ID de los dos registros Reference sean distintos. Se distingue del vínculo direccional de [REFERENCE-NODE](0x0A0L-reference-node.md) y de la identidad de [SAME-NODE](0x0A1L-same-node.md).

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0010 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference
```

## Interpretación y validez {#해석과-유효성}

- Subject y Object deben ser cada uno exactamente un registro [Reference](../reference/_index.md) completo. El límite se encuentra con el Length de cada registro; si es un Value o un Edge, o está incompleto, es invalid.
- Subject y Object señalan referentes distintos. No se infiere que el referente es distinto solo por una diferencia en la secuencia de bytes, el Codec o el ID de los registros Reference.
- En particular, distintos ID [LOCAL](../reference/0x005L-local.md) son solo Reference distintas, no significan que también sean distintos los referentes de la realidad. No se deduce DIFFERENT solo de la diferencia de LOCAL ID.
- La no identidad es simétrica, irreflexiva y no transitiva. `DIFFERENT(A, B)` es la misma relación que `DIFFERENT(B, A)`. Pero de `DIFFERENT(A, B)` y `DIFFERENT(B, C)` no se infiere `DIFFERENT(A, C)`.
- El orden Subject/Object en el wire es solo un orden de serialización para el framing y no crea dirección semántica. Una implementación debe poder recorrerla en ambos sentidos.
- El cursor tras leer los dos componentes debe coincidir exactamente con el final del Edge.

Aunque la relación en sí es irreflexiva, una afirmación `DIFFERENT(A, A)` estructuralmente valid, o una afirmación en la que chocan SAME y DIFFERENT, no debe borrarse como error de gramática del wire. Estas afirmaciones conservan el contexto y el linaje y se tratan como contradicción en la capa de veredicto. Al interpretar o derivar DIFFERENT se conservan la procedencia, el momento, el world y el policy scope del documento que contiene ese Edge, y no se amplía a una conclusión global que los ignore.

## Longitud {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Ejemplo (no normativo) {#예시-비규범}

Edge Id `000A`, Subject es LOCAL 1, Object es LOCAL 2.

- El Edge es TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. El TAG es `0000 1010 0010 0110` = `0A26`.

```
0A26 0051 000A 0051 0001 0051 0002
```

La diferencia de LOCAL ID en este ejemplo solo sirve para mostrar la codificación. Esta secuencia se convierte en DIFFERENT-NODE únicamente cuando existe aparte la afirmación de que el ID 1 y el ID 2 señalan referentes distintos.

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000A20/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
