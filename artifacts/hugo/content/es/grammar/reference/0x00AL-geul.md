---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL es un Reference de declaración que señala las entidades que geul.org emite bajo CC0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `GEUL` (grupo 5Q. Los nombres por código están en la tabla de miembros más abajo) |
| TAG ID | `0x00AL~0x00EL` |
| Sección | 0 `0000` (entidad Reference), desplazamiento dentro de la sección C = 10~14 |
| Kind | Reference · clasificación: declaración |
| Lado Hugo | `reference/geul.md` |

## Miembros {#구성원}

Esta página trata un conjunto del sistema 5Q, cinco códigos a la vez. La cuantificación es el desplazamiento dentro de la sección `C % 5` ([Reference](_index.md#quantifier)). Hay un documento de Codec por código. Los campos de los cinco documentos de Codec son iguales; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Cuantificación | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | resto en valor en bruto (`0xFFFF`) |  |  |

GEUL es un Reference de declaración que señala las entidades que geul.org emite bajo CC0. Es un ID de serie cuyo número no lleva significado. El identificador que lleva significado en sus bits corresponde a otro Codec, [GEUL-SIDX](0x00FL-geul-sidx.md) (`0x00FL~0x013L`).

## Layout {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[TAG de extensión de Length]
GEUL ID           unsigned big-endian del ancho más corto
```

- Los números pequeños se asignan a entidades de alta frecuencia. Un ID que cabe en 1 WORD ocupa 2 WORD en total.
- geul.org administra la asignación de ID y el registro. En el registro solo entra lo que procede de fuentes CC0.
- Si es Variable, es una variable anónima de ese tipo (Variable en [Reference](_index.md)).

## Ejemplo {#예시}

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## Problemas abiertos {#열린-문제}

- Reglas de asignación de GEUL ID y formato de publicación del registro.

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [GEUL-SIDX](0x00FL-geul-sidx.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x000000A0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

Lo anterior es el documento de Codec de `GEUL-IDENTIFIED` (`0x00AL`). En los documentos de Codec de los demás miembros (`GEUL-GENERIC`, `GEUL-FREE-CHOICE`, `GEUL-UNIVERSAL`, `GEUL-VARIABLE`) solo difieren el Codec ID del DOC-ID, el destino de DECLARE y el nombre asociado en `#1` (BIND).
