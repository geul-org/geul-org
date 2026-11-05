---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indica el sujeto que creó el documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `GENERATED-BY` (BIND del documento de especificación `GENERATED-BY`) |
| TAG ID | `0x1D3L` |
| Codec ID | `0x00001D30` |
| Documento de especificación | `0x00000000/codecs/0x00001D30/` (destino de DECLARE `1D30`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 19 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Sujeto generador. Una persona, un modelo, un motor de reglas |
| Lado Hugo | `meta/lineage/generated-by.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | registro | cualquier registro (excepto marcador de posición) |  |
| 2 | `version` | #5 | registro | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0000` ABSENT (campo opcional) |  |

Indica el sujeto que creó el documento. Puede ser una persona, un modelo o un motor de reglas.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[TAG de extensión de Length]
Sujeto generador  Reference (persona, modelo, motor de reglas)
Versión           Value UTF8-TEXT, o marca de omisión 0x0000 (campo opcional)
```

- Codec: Meta `0x1D3L`, clase de linaje
- Payload: Reference incorporado + texto de versión (opcional)
- Cantidad: varios posibles

## Interpretación y validez {#해석과-유효성}

- Si es un modelo, se indica también la versión del modelo.
- Si no se conoce la versión o no se quiere poner, se omite ese lugar y se usa ABSENT (`0x0000`) (campo opcional de [CODEC](../edge/0x0BEL-codec.md)). La especificación `0x1D30` de geul.org es de dos campos de registro: agent (sin CODEC) y version (`0720`, `0730`, `0000`).
- Para la versión de código fuente de un programa (commit), el formato de [TRANSFORMED-BY](0x1D4L-transformed-by.md) (resumen, obligatorio) es más exacto. La versión de GENERATED-BY se usa para escribir como texto lo que no es un ID de commit, como el nombre y la versión de un modelo.
- En los documentos publicados en geul.org no se pone un Reference que señale a una persona física ([Issuer y publicación](../issuer.md#geulorg-공표)). Se señala una organización o un Issuer. Como excepción, se permite señalar a una persona física con [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001D30/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
