---
title: "USAGE (0x1E3L)"
weight: 483
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indica las restricciones de uso (por ejemplo, prohibido entrenar, prohibido el uso comercial)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `USAGE` (BIND del documento de especificación `USAGE`) |
| TAG ID | `0x1E3L` |
| Codec ID | `0x00001E30` |
| Documento de especificación | `0x00000000/codecs/0x00001E30/` (destino de DECLARE `1E30`) |
| Sección | 15 `1111` (Meta), desplazamiento C dentro de la sección = 3 |
| Kind | Meta · clase: política |
| TAG WORD | `0001 1110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Restricciones de uso |
| Lado Hugo | `meta/policy/usage.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `usage` | #2 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Indica las restricciones de uso (por ejemplo, prohibido entrenar, prohibido el uso comercial).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0011 LLLL      Codec 0x1E3L
[TAG de extensión de Length]
Payload           texto o Reference que expresa la restricción de uso
```

- Codec: Meta `0x1E3L`, clase de política
- Payload: Value o Reference incorporado
- Cantidad: varios posibles

## Problemas abiertos {#열린-문제}

- Tabla de códigos de tipos de restricción.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001E30/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E3000000000
BODY
#1 DECLARE 0x1E30
#2 FIELD #1 record
#3 BIND #1 "USAGE"
#4 BIND #2 "usage"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
