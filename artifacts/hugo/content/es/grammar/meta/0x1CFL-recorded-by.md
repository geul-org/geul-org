---
title: "RECORDED-BY (0x1CFL)"
weight: 463
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Indica el sujeto que registró el documento (git committer)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `RECORDED-BY` (BIND del documento de especificación `RECORDED-BY`) |
| TAG ID | `0x1CFL` |
| Codec ID | `0x00001CF0` |
| Documento de especificación | `0x00000000/codecs/0x00001CF0/` (destino de DECLARE `1CF0`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 15 |
| Kind | Meta · clase: procedencia |
| TAG WORD | `0001 1100 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Sujeto que registra. Reference (git committer) |
| Lado Hugo | `meta/provenance/recorded-by.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | registro | cualquier registro (excepto marcador de posición) |  |

Indica el sujeto que registró el documento (git committer).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1111 LLLL      Codec 0x1CFL
[TAG de extensión de Length]
Payload           un registro Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL, etc.)
```

- Codec: Meta `0x1CFL`, clase de procedencia
- Payload: Reference incorporado
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- El Reference no distingue Codec. Puede ser una persona, una organización, un modelo o un motor de reglas ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md), etc.).
- En los documentos publicados en geul.org no se pone un Reference que señale a una persona física ([Issuer y publicación](../issuer.md#geulorg-공표)). Se señala una organización o un Issuer. Como excepción, se permite señalar a una persona física con [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).
- Si es LOCAL, el objetivo se describe en el BODY.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001CF0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CF000000000
BODY
#1 DECLARE 0x1CF0
#2 FIELD #1 record
#3 BIND #1 "RECORDED-BY"
#4 BIND #2 "actor"
```
