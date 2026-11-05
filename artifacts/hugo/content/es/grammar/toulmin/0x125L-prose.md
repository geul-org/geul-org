---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE es un registro de texto original y de delimitación de un documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE es un registro de texto original y de delimitación de un documento TOULMIN. Significado: párrafo descriptivo.

| Elemento | Valor |
|---|---|
| Nombre | `PROSE` (BIND `PROSE` del documento de especificación) |
| TAG ID | `0x125L` |
| Codec ID | `0x00001250` |
| Documento de especificación | `0x00000000/codecs/0x00001250/` (destino de DECLARE `1250`) |
| Sección | 9 `1001` (formato Edge TOULMIN), desplazamiento dentro de la sección C = 5 |
| Kind | Edge · familia: formato TOULMIN, layout: ID, SPAN |
| TAG WORD | `0001 0010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | párrafo descriptivo |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Es un párrafo descriptivo, no una regla. Solo señala un rango (SPAN) del texto original.

```
ID
SPAN             ancho fijado por SOURCE × 2 (byte de inicio, número de bytes)
```

- ID es el Edge Id y REF es el Edge Id del registro de este documento (campos comunes de [TOULMIN](_index.md#공통-필드)). El Payload sigue a la TAG, sin campos de Issuer ni de número de Codec.

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1250`). El ancho de SPAN lo fija SOURCE y no se puede declarar con FIELD, por lo que la declaración de campos es un problema abierto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE y delimitación](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001250/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
