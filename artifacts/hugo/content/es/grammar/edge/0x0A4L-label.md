---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL es un Edge de enunciado que conecta con Object un nombre (label) en un idioma concreto del objeto Subject."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `LABEL` (BIND del documento de especificación `LABEL`) |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| Documento de especificación | `0x00000000/codecs/0x00000A40/` (destino de DECLARE `0A40`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 4 |
| Kind | Edge · familia: enunciado, grupo: señalamiento y nombre |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Conexión del nombre (label) de Subject en un idioma. Object es UTF8-LANGUAGE-TEXT |
| Lado Hugo | `edge/label.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | cualquier registro (excepto marcadores de posición) |  |
| 2 | `object` | #3 | registro | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

LABEL es un Edge de enunciado que conecta con Object un nombre (label) en un idioma concreto del objeto Subject. Codec `0x0A4L`. No es un Edge que exprese el lemma de la lexicografía general.

El nombre y su idioma van en un solo Object, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). No hay campo de valor en bruto.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 Value UTF8-LANGUAGE-TEXT o registro Reference LOCAL
```

## Interpretación y validez {#해석과-유효성}

- Subject es exactamente un registro Reference completo. Su límite se encuentra con el Length del propio Subject; si no es una Reference o está incompleto, es invalid.
- Object es exactamente un registro [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) (`0x078L`·`0x079L`) completo. Las reglas del idioma y del texto (se admiten los dos formatos de idioma, comparación del mismo idioma) siguen a ese formato.
- Object también puede ser una Reference LOCAL. En ese caso debe resolverse a UTF8-LANGUAGE-TEXT mediante un vínculo [REFERENCE-NODE](0x0A0L-reference-node.md) del mismo documento. Si no se resuelve o se resuelve a otra clase de objeto, es invalid.
- El documento de especificación de geul.org escribe esta restricción como [CODEC](0x0BEL-codec.md) (Object = `0780`·`0790`·`0050`). El destino de resolución de LOCAL no se expresa con CODEC.
- Si Object no es uno de los dos formatos anteriores, o el registro está incompleto, es invalid. Un texto sin idioma (UTF8-TEXT) no puede ser LABEL. Un nombre para máquinas sin idioma se escribe como [BIND](0x0A3L-bind.md). Un nombre común a varios idiomas se escribe con el idioma `mul`.
- Para el mismo Subject e idioma hay como máximo un LABEL. Los otros nombres se escriben como [ALIAS](0x0A5L-alias.md).

## Longitud {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- El registro de idioma de Object y el número de bytes del texto los asume el registro Object, no el Edge. El cursor tras leer todos los registros debe coincidir exactamente con el final del Edge.

## Ejemplo (no normativo) {#예시-비규범}

El código de idioma `0784` para `en` es el número del GEUL Language Registry v2 (documento de especificación `0x00000000/codecs/0x000007A0`, versión 2).

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id `0007`, Subject Q22686 (`0141 589E`), Object `Donald Trump` (en).

- Object es idioma `07A1 0784` (SHORT-CODE, 2 WORD) + texto de 12 bytes (par, 6 WORD), es decir `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), 9 WORD en total: `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`.
- El Edge es TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. El TAG es `0A4D`.

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id `0008`, Subject Q155 (`0141 009B`), Object `Brasil` (pt-BR).

- Object es idioma `0773 7074 2D42 5200` (BCP47 `pt-BR`, 4 WORD) + texto de 6 bytes (par, 3 WORD), 8 WORD en total: `0787 0773 7074 2D42 5200 4272 6173 696C`.
- El Edge es TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. El TAG es `0A4C`.

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md), [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000A40/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
