---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE es un Edge de enunciado direccional que conecta una Reference con un registro Object para definir o vincular qué es esa Reference."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `REFERENCE-NODE` (BIND del documento de especificación `REFERENCE-NODE`) |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| Documento de especificación | `0x00000000/codecs/0x00000A00/` (destino de DECLARE `0A00`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 0 |
| Kind | Edge · familia: enunciado, grupo: señalamiento y nombre |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Vínculo direccional en el que Subject, una Reference, señala a Object |
| Lado Hugo | `edge/reference-node.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | cualquier registro (excepto marcadores de posición) |  |
| 2 | `object` | #3 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference), `060F` toda la sección 3 (comodín, Value), `080F` toda la sección 4 (comodín, Value) |  |

REFERENCE-NODE es un Edge de enunciado direccional que conecta una Reference con un registro Object para definir o vincular qué es esa Reference. Codec `0x0A0L`.

Subject señala a Object. Este vínculo no es [SAME-NODE](0x0A1L-same-node.md), que afirma identidad semántica, ni significa que los bytes de los dos registros sean iguales.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference o Value
```

## Interpretación y validez {#해석과-유효성}

- Subject debe ser exactamente un registro [Reference](../reference/_index.md) completo. Su límite se encuentra con el Length del propio Subject; si no es una Reference o está incompleto, es invalid.
- Object debe ser exactamente un registro Reference o Value completo. Su límite se encuentra con el Length del propio Object; si es Edge o Meta, o está incompleto, es invalid.
- Si Object es una Reference, la cadena de Reference que se sigue mediante vínculos REFERENCE-NODE no debe ser cíclica y un LOCAL debe resolverse al final. Un ciclo de resolución y un LOCAL dangling son invalid.
- Si en un mismo documento un LOCAL ID se vincula a Object en conflicto, es invalid. El ámbito, el ID, el ancho mínimo y las reglas de fusión de LOCAL siguen [LOCAL](../reference/0x005L-local.md).
- No todas las Reference tienen que estar vinculadas por REFERENCE-NODE.
- El uso representativo es `LOCAL → UTF8-LANGUAGE-TEXT`. Cuando se pone un LOCAL en Object de [LABEL](0x0A4L-label.md), el texto se resuelve con este vínculo del mismo documento.

La dirección en que Subject señala a Object no debe interpretarse al revés. El significado y las reglas detalladas de SAME y DIFFERENT los fija cada formato por separado.

## Longitud {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` es el número de WORD del TAG de extensión de Length, `N_id` el número de WORD del registro LOCAL del Edge Id, y `N_subject`·`N_object` el número total de WORD de cada registro. El cursor tras leer Subject y Object debe coincidir exactamente con el final del Edge.

## Ejemplo (no normativo) {#예시-비규범}

Edge Id `0008`, Subject es LOCAL 1, Object es un [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) de `Donald Trump` (en).

- El Edge Id es `0051 0008`, 2 WORD.
- Subject es `0051 0001`, 2 WORD.
- Object es idioma `0761 656E` (BCP47 `en`) + texto de 12 bytes (par), es decir `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), 9 WORD en total. El TAG es `0788`.
- El Edge es TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. El TAG es `0A0D`.

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000A00/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
