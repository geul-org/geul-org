---
title: "END (0x1C4L)"
weight: 452
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Es el registro que cierra el documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `END` (BIND del documento de especificación `END`) |
| TAG ID | `0x1C4L` |
| Codec ID | `0x00001C40` |
| Documento de especificación | `0x00000000/codecs/0x00001C40/` (destino de DECLARE `1C40`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 4 |
| Kind | Meta · clase: estructura |
| TAG WORD | `0001 1100 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | 1 WORD. Cierra el documento. |
| Lado Hugo | `meta/structure/end.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El documento de especificación no tiene FIELD. No declara campos de Payload.

Es el registro que cierra el documento.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0100 LLLL      Codec 0x1C4L
[TAG de extensión de Length]
```

- Codec: Meta `0x1C4L`, clase de estructura
- Payload: ninguno (1 WORD)
- Cantidad: uno por documento, al final

## Interpretación y validez {#해석과-유효성}

- Es obligatorio. Su posición se comprueba con la longitud de [DOC](0x1C0L-doc-1word.md) (`DOC-*`).
- Si la entrada termina sin END, el documento está truncado. Considerar válido o no el contenido de un documento truncado es política del decodificador.
- No viene nada después.

## Ejemplo {#예시}

- `0x1C40`

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001C40/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C4000000000
BODY
#1 DECLARE 0x1C40
#2 BIND #1 "END"
```
