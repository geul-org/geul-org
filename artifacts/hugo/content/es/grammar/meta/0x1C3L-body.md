---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Es el registro que termina el HEAD e inicia el BODY."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `BODY` (BIND del documento de especificación `BODY`) |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| Documento de especificación | `0x00000000/codecs/0x00001C30/` (destino de DECLARE `1C30`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 3 |
| Kind | Meta · clase: estructura |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | 1 WORD. Termina el HEAD del documento e inicia el BODY. |
| Lado Hugo | `meta/structure/body.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El documento de especificación no tiene FIELD. No declara campos de Payload.

Es el registro que termina el HEAD e inicia el BODY.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[TAG de extensión de Length]
```

- Codec: Meta `0x1C3L`, clase de estructura
- Payload: ninguno (1 WORD)
- Cantidad: como máximo uno por documento

## Interpretación y validez {#해석과-유효성}

- Si el HEAD está vacío, se omite. Un documento sin `BODY` es todo BODY. Se coloca si el HEAD contiene Meta o Edge de HEAD (el [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) de todo el documento y su QUALIFIER).
- No tiene Payload. Ocupa 1 WORD en total.

## Ejemplo {#예시}

- `0x1C30`

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001C30/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
