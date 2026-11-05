---
title: "WIKIDATA-QID (0x014L~0x018L)"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID es un Reference de declaración que señala un elemento (Item) de Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `WIKIDATA-QID` (grupo 5Q. Los nombres por código están en la tabla de miembros más abajo) |
| TAG ID | `0x014L~0x018L` |
| Sección | 0 `0000` (entidad Reference), desplazamiento dentro de la sección C = 20~24 |
| Kind | Reference · clasificación: declaración |
| Lado Hugo | `reference/wikidata-qid.md` |

## Miembros {#구성원}

Esta página trata un conjunto del sistema 5Q, cinco códigos a la vez. La cuantificación es el desplazamiento dentro de la sección `C % 5` ([Reference](_index.md#quantifier)). Hay un documento de Codec por código. Los campos de los cinco documentos de Codec son iguales; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Cuantificación | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x014L` | `WIKIDATA-QID-IDENTIFIED` | Identified | `0x00000140` | `0x00000000/codecs/0x00000140/` | `0000 0001 0100 LLLL` |
| `0x015L` | `WIKIDATA-QID-GENERIC` | Generic | `0x00000150` | `0x00000000/codecs/0x00000150/` | `0000 0001 0101 LLLL` |
| `0x016L` | `WIKIDATA-QID-FREE-CHOICE` | Free-choice | `0x00000160` | `0x00000000/codecs/0x00000160/` | `0000 0001 0110 LLLL` |
| `0x017L` | `WIKIDATA-QID-UNIVERSAL` | Universal | `0x00000170` | `0x00000000/codecs/0x00000170/` | `0000 0001 0111 LLLL` |
| `0x018L` | `WIKIDATA-QID-VARIABLE` | Variable | `0x00000180` | `0x00000000/codecs/0x00000180/` | `0000 0001 1000 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `qid` | #2 | resto en valor en bruto (`0xFFFF`) |  |  |

WIKIDATA-QID es un Reference de declaración que señala un elemento (Item) de Wikidata. Se escribe como entero sin signo la parte numérica del identificador Q, quitando la `Q`.

## Layout {#레이아웃}

```
TAG WORD          0000 0001 0100 LLLL      Codec 0x014L~0x018L (Identified 0x014L)
[TAG de extensión de Length]
QID               unsigned big-endian del ancho más corto
```

- El QID se escribe con el ancho más corto. De `Q1` a `Q65535` son 2 WORD en total; por encima, 3 WORD.
- Los datos de Wikidata son CC0.
- Si es Variable, es una variable anónima del tipo que señala ese elemento (Variable en [Reference](_index.md)).

## Ejemplo {#예시}

| Elemento | WORD sequence |
|---|---|
| `Q5` (ser humano) | `0141 0005` |
| `Q76` (Barack Obama) | `0141 004C` |
| `Q884` (Corea del Sur) | `0141 0374` |
| `Q317521` (Elon Musk) | `0142 0004 D851` |
| `Q30461` (presidente), Variable | `0181 76FD` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-PID](0x019L-wikidata-pid.md), [TRIPLE](../edge/0x0AAL-triple.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000140/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000014000000000
BODY
#1 DECLARE 0x0140
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-QID-IDENTIFIED"
#4 BIND #2 "qid"
```

Lo anterior es el documento de Codec de `WIKIDATA-QID-IDENTIFIED` (`0x014L`). En los documentos de Codec de los demás miembros (`WIKIDATA-QID-GENERIC`, `WIKIDATA-QID-FREE-CHOICE`, `WIKIDATA-QID-UNIVERSAL`, `WIKIDATA-QID-VARIABLE`) solo difieren el Codec ID del DOC-ID, el destino de DECLARE y el nombre asociado en `#1` (BIND).
