---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL es el Value que representa los valores lógicos false y true."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `BOOL` (documento de especificación BIND `BOOL`) |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| Documento de especificación | `0x00000000/codecs/0x00000600/` (destino de DECLARE `0600`) |
| Sección | 3 `0011` (Value), desplazamiento C dentro de la sección = 0 |
| Kind | Value · familia: NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | false o true en 1 WORD fijo |
| Lado Hugo | `value/numeric/bool.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | valor en bruto, 1 WORD |  | `0x0000` false, `0x0001` true |

BOOL es el Value que representa los valores lógicos false y true. Su código directo de Value es `0x060L` y su familia es NUMERIC. Es un tipo distinto de SIGNED-INTEGER y UNSIGNED-INTEGER, que contienen los números 0 y 1.

## Layout {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  total 2 WORD
Payload           1 WORD  Boolean Code
```

## Interpretación y validez {#해석과-유효성}

- El Payload `0000` es false y `0001` es true.
- No hay padding ni descriptor.
- El Payload es exactamente `0000` o `0001`. Cualquier otro valor de 16 bits se rechaza como invalid.
- Cualquier otra representación de Length se rechaza como invalid.

## Longitud {#길이}

- El total es exactamente 2 WORD: 1 WORD de TAG más 1 WORD de Payload, y usa la longitud directa `LLLL=0001`. No hay TAG de extensión de Length, descriptor ni padding.
- Si el Payload no es exactamente 1 WORD, se rechaza.

## Ejemplo {#예시}

| Registro completo (TAG + Payload) | Payload | Veredicto |
|---|---|---|
| `0601 0000` | `0000` | false, canónico |
| `0601 0001` | `0001` | true, canónico |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| TAG con Length distinto de `0001` + `0000` o `0001` | `0000` o `0001` | invalid |

## Estatus del formato {#형식-지위}

- Esta representación, que une la code word de 16 bits `0000`/`0001` con un TAG de GEUL, es un perfil escalar propio de GEUL.
- El valor lógico en sí es universal, pero no se afirma que exista un único estándar industrial que corresponda a esta representación de 1 WORD.

## Texto original del documento de especificación {#규격-문서-원문}

Es el aspecto del documento de especificación `0x00000000/codecs/0x00000600/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
