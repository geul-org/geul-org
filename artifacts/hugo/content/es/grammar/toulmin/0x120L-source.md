---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE es un registro de texto original y de delimitación de un documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE es un registro de texto original y de delimitación de un documento TOULMIN. Significado: texto original de la redacción.

| Elemento | Valor |
|---|---|
| Nombre | `SOURCE` (BIND `SOURCE` del documento de especificación) |
| TAG ID | `0x120L` |
| Codec ID | `0x00001200` |
| Documento de especificación | `0x00000000/codecs/0x00001200/` (destino de DECLARE `1200`) |
| Sección | 9 `1001` (formato Edge TOULMIN), desplazamiento dentro de la sección C = 0 |
| Kind | Edge · familia: formato TOULMIN, layout: ID, WORD de ancho de SPAN, Value UTF8 |
| TAG WORD | `0001 0010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | texto original de la redacción |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Es el texto original completo de la redacción. Todo SPAN es un rango de bytes dentro de este texto.

```
ID
WORD ancho SPAN  2 bits altos = ancho (00=1, 01=2, 10=4, 11=8 WORD), 14 bits restantes = 0
texto original   registro Value UTF8-TEXT
```

- SOURCE es el primer registro de BODY. Hay uno por documento.
- SPAN consta de dos campos: el byte de inicio y el número de bytes. Cada campo es un entero sin signo del ancho que fija el WORD de ancho de SPAN (1/2/4/8 WORD).
- Es un Codec distinto del Edge de fundamento [SOURCE](../edge/0x0C0L-source.md) (`0x0C0L`).

- ID es el Edge Id y REF es el Edge Id del registro de este documento (campos comunes de [TOULMIN](_index.md#공통-필드)). El Payload sigue a la TAG, sin campos de Issuer ni de número de Codec.

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1200`). La declaración de campos se fijará junto con los documentos de especificación de los Codecs TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE y delimitación](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001200/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
