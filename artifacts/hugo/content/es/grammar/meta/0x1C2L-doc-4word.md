---
title: "DOC-4WORD (0x1C2L)"
weight: 450
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD y DOC-4WORD son Meta de estructura que abren el documento indicando el número total de WORD del documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD, DOC-2WORD y DOC-4WORD son Meta de estructura que abren el documento indicando el número total de WORD del documento.

| Elemento | Valor |
|---|---|
| Nombre | `DOC-4WORD` (BIND del documento de especificación `DOC-4WORD`) |
| TAG ID | `0x1C2L` |
| Codec ID | `0x00001C20` |
| Documento de especificación | `0x00000000/codecs/0x00001C20/` (destino de DECLARE `1C20`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 2 |
| Kind | Meta · clase: estructura |
| TAG WORD | `0001 1100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Inicio de documento con la longitud total indicada en 4 WORD de Payload |
| Lado Hugo | `meta/structure/doc.md` (ese lado trata también [DOC-1WORD](0x1C0L-doc-1word.md) y [DOC-2WORD](0x1C1L-doc-2word.md)) |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | valor en bruto, 4 WORD |  |  |

Es el registro que abre el documento. Indica en el Payload el número total de WORD del documento. En esta página se tratan juntos `DOC-1WORD` (`0x1C0L`), `DOC-2WORD` (`0x1C1L`) y `DOC-4WORD` (`0x1C2L`).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[TAG de extensión de Length]
Payload           número total de WORD. El Codec fija el ancho: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x1C0L~0x1C2L`, clase de estructura
- Payload: valor en bruto (número total de WORD del documento, unsigned)
- Cantidad: uno por documento, al principio

## Interpretación y validez {#해석과-유효성}

- La longitud va desde el inicio del registro de apertura hasta el final de [END](0x1C4L-end.md).
- Se usa el ancho más estrecho en que quepa el valor. Si se codifica con un ancho mayor, se rechaza por codificación no canónica.
- La longitud debe ser igual a la entrada completa. Un documento es una entrada.
- El decodificador puede saltar el documento entero con esta longitud. No existe un Codec que abra sin conocer la longitud.
- Al calcular el hash de contenido, se reescribe con la longitud sin los Meta de la clase de verificación y el ancho que corresponde a ella ([hash de contenido](../document.md#내용-해시)).

## Ejemplo {#예시}

- `0x1C01 0x0017`: DOC-1WORD, 23 WORD en total

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001C20/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C2000000000
BODY
#1 DECLARE 0x1C20
#2 FIELD #1 0x0004
#3 BIND #1 "DOC-4WORD"
#4 BIND #2 "count"
```
