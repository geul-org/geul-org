---
title: "EXTERNAL-POINTER-4WORD (0x02AL~0x02EL)"
weight: 42
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER es un Reference de designación que señala el LOCAL ID de un documento importado con IMPORT-DOC en HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER es un Reference de designación que señala el LOCAL ID de un documento importado con IMPORT-DOC en HEAD.

| Elemento | Valor |
|---|---|
| Nombre | `EXTERNAL-POINTER-4WORD` (grupo 5Q. Los nombres por código están en la tabla de miembros más abajo) |
| TAG ID | `0x02AL~0x02EL` |
| Sección | 1 `0001` (Reference EXTERNAL), desplazamiento dentro de la sección C = 10~14 |
| Kind | Reference · clasificación: designación |
| Lado Hugo | `reference/external-pointer.md` (esa página trata también [EXTERNAL-POINTER-1WORD](0x020L-external-pointer-1word.md) y [EXTERNAL-POINTER-2WORD](0x025L-external-pointer-2word.md)) |

## Miembros {#구성원}

Esta página trata un conjunto del sistema 5Q, cinco códigos a la vez. La cuantificación es el desplazamiento dentro de la sección `C % 5` ([Reference](_index.md#quantifier)). Hay un documento de Codec por código. Los campos de los cinco documentos de Codec son iguales; solo difieren el destino de DECLARE y el nombre (BIND).

| TAG ID | Nombre | Cuantificación | Codec ID | Documento de especificación | TAG WORD |
|---|---|---|---|---|---|
| `0x02AL` | `EXTERNAL-POINTER-4WORD-IDENTIFIED` | Identified | `0x000002A0` | `0x00000000/codecs/0x000002A0/` | `0000 0010 1010 LLLL` |
| `0x02BL` | `EXTERNAL-POINTER-4WORD-GENERIC` | Generic | `0x000002B0` | `0x00000000/codecs/0x000002B0/` | `0000 0010 1011 LLLL` |
| `0x02CL` | `EXTERNAL-POINTER-4WORD-FREE-CHOICE` | Free-choice | `0x000002C0` | `0x00000000/codecs/0x000002C0/` | `0000 0010 1100 LLLL` |
| `0x02DL` | `EXTERNAL-POINTER-4WORD-UNIVERSAL` | Universal | `0x000002D0` | `0x00000000/codecs/0x000002D0/` | `0000 0010 1101 LLLL` |
| `0x02EL` | `EXTERNAL-POINTER-4WORD-VARIABLE` | Variable | `0x000002E0` | `0x00000000/codecs/0x000002E0/` | `0000 0010 1110 LLLL` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([Documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato aceptado (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | valor en bruto de 4 WORD |  |  |
| 2 | `target-id` | #3 | resto en valor en bruto (`0xFFFF`) |  |  |

EXTERNAL-POINTER es un Reference de designación que señala el LOCAL ID de un documento importado con [IMPORT-DOC](../meta/0x1E4L-import-doc.md) en HEAD.

## Layout {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (sección 1)
[TAG de extensión de Length]
IMPORT ID         ancho fijado por el Codec (1/2/4 WORD)
ID de destino     todo el resto. LOCAL ID del documento importado, en el ancho más corto
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Nombre | Ancho del IMPORT ID |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- El ancho lo fija el número de sistema: si sistema − 6 (`C / 5`, con `C` el desplazamiento dentro de la sección) es 0, 1 o 2, el ancho es 1, 2 o 4 WORD. La cuantificación es `C % 5`.

- Se usa el Codec más estrecho en el que quepa el valor del IMPORT ID.
- El IMPORT ID es el valor que asignó el `IMPORT-DOC` de este documento. En EXTERNAL-POINTER no se escribe el Issuer. El Issuer y el ID de documento se obtienen de ese `IMPORT-DOC`. La versión también la fija ese `IMPORT-DOC` (fija o la más reciente).
- Si es el mismo LOCAL ID del documento importado, es el mismo objeto tanto si dentro de ese documento se usa como LOCAL como si aquí se usa como EXTERNAL-POINTER.
- Si es Variable, es la variable LOCAL del documento importado.

## Validez {#유효성}

- Es invalid si en este documento no hay un `IMPORT-DOC` que haya asignado ese IMPORT ID.
- Si el IMPORT ID cabe en un Codec más estrecho y se usa uno más ancho, se rechaza por non-minimal.
- Es invalid si el ID de destino es `0`. El propio documento importado se señala con [DOC-POINTER](0x041L-doc-pointer.md).
- Se prohíbe un WORD `0x0000` inicial en el ID de destino.

## Ejemplo {#예시}

| Destino | WORD sequence |
|---|---|
| LOCAL 5 del IMPORT ID 1 | `0202 0001 0005` |
| LOCAL 65536 del IMPORT ID 1 | `0203 0001 0001 0000` |
| LOCAL 5 del IMPORT ID 70000 | `0253 0001 1170 0005` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [LOCAL](0x005L-local.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x000002A0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000002A000000000
BODY
#1 DECLARE 0x02A0
#2 FIELD #1 0x0004
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-4WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

Lo anterior es el documento de Codec de `EXTERNAL-POINTER-4WORD-IDENTIFIED` (`0x02AL`). En los documentos de Codec de los demás miembros (`EXTERNAL-POINTER-4WORD-GENERIC`, `EXTERNAL-POINTER-4WORD-FREE-CHOICE`, `EXTERNAL-POINTER-4WORD-UNIVERSAL`, `EXTERNAL-POINTER-4WORD-VARIABLE`) solo difieren el Codec ID del DOC-ID, el destino de DECLARE y el nombre asociado en `#1` (BIND).
