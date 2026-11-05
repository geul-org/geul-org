---
title: "WIKIDATA-PID (0x019L~0x01DL)"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID es un Reference de declaración que señala una propiedad (Property) de Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `WIKIDATA-PID` (grupo 5Q. Los nombres por código están en la tabla de miembros más abajo) |
| TAG ID | `0x019L~0x01DL` |
| Sección | 0 `0000` (entidad Reference), desplazamiento dentro de la sección C = 25~29 |
| Kind | Reference · clasificación: declaración |
| Lado Hugo | `reference/wikidata-pid.md` |

## Miembros {#구성원}

Esta página trata un conjunto del sistema 5Q, cinco códigos a la vez. La cuantificación es el desplazamiento dentro de la sección `C % 5` ([Reference](_index.md#quantifier)). Hay un documento de Codec por código. Los campos de los cinco documentos de Codec son iguales; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Cuantificación | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x019L` | `WIKIDATA-PID-IDENTIFIED` | Identified | `0x00000190` | `0x00000000/codecs/0x00000190/` | `0000 0001 1001 LLLL` |
| `0x01AL` | `WIKIDATA-PID-GENERIC` | Generic | `0x000001A0` | `0x00000000/codecs/0x000001A0/` | `0000 0001 1010 LLLL` |
| `0x01BL` | `WIKIDATA-PID-FREE-CHOICE` | Free-choice | `0x000001B0` | `0x00000000/codecs/0x000001B0/` | `0000 0001 1011 LLLL` |
| `0x01CL` | `WIKIDATA-PID-UNIVERSAL` | Universal | `0x000001C0` | `0x00000000/codecs/0x000001C0/` | `0000 0001 1100 LLLL` |
| `0x01DL` | `WIKIDATA-PID-VARIABLE` | Variable | `0x000001D0` | `0x00000000/codecs/0x000001D0/` | `0000 0001 1101 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `pid` | #2 | resto en valor en bruto (`0xFFFF`) |  |  |

WIKIDATA-PID es un Reference de declaración que señala una propiedad (Property) de Wikidata. Se escribe como entero sin signo la parte numérica del identificador P, quitando la `P`.

## Layout {#레이아웃}

```
TAG WORD          0000 0001 1001 LLLL      Codec 0x019L~0x01DL (Identified 0x019L)
[TAG de extensión de Length]
PID               unsigned big-endian del ancho más corto
```

- El PID se escribe con el ancho más corto. Los números de propiedad actuales caben en 1 WORD, es decir, 2 WORD en total, y si superan 65535 pasan naturalmente a 3 WORD.
- Se usa sobre todo en la posición de Predicate de [TRIPLE](../edge/0x0AAL-triple.md) y en la de Property de [QUALIFIER](../edge/0x0ABL-qualifier.md).

## Ejemplo {#예시}

| Propiedad | WORD sequence |
|---|---|
| `P31` (instancia de) | `0191 001F` |
| `P279` (subclase de) | `0191 0117` |
| `P569` (fecha de nacimiento) | `0191 0239` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-QID](0x014L-wikidata-qid.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000190/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000019000000000
BODY
#1 DECLARE 0x0190
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-PID-IDENTIFIED"
#4 BIND #2 "pid"
```

Lo anterior es el documento de Codec de `WIKIDATA-PID-IDENTIFIED` (`0x019L`). En los documentos de Codec de los demás miembros (`WIKIDATA-PID-GENERIC`, `WIKIDATA-PID-FREE-CHOICE`, `WIKIDATA-PID-UNIVERSAL`, `WIKIDATA-PID-VARIABLE`) solo difieren el Codec ID del DOC-ID, el destino de DECLARE y el nombre asociado en `#1` (BIND).
