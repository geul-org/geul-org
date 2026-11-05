---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT es un registro de texto original y de delimitación de un documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT es un registro de texto original y de delimitación de un documento TOULMIN. Significado: nombre o cadena.

| Elemento | Valor |
|---|---|
| Nombre | `TEXT` (BIND `TEXT` del documento de especificación) |
| TAG ID | `0x121L` |
| Codec ID | `0x00001210` |
| Documento de especificación | `0x00000000/codecs/0x00001210/` (destino de DECLARE `1210`) |
| Sección | 9 `1001` (formato Edge TOULMIN), desplazamiento dentro de la sección C = 1 |
| Kind | Edge · familia: formato TOULMIN, layout: ID, Value UTF8 |
| TAG WORD | `0001 0010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | nombre o cadena |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Es un nombre o una cadena. Lo señalan por REF las listas F_WITH y F_GROUNDS de NODE, y [LABEL](0x134L-label.md) e [IMPORTED-FROM](0x133L-imported-from.md) de LINK.

```
ID
cadena           registro Value UTF8-TEXT
```

- ID es el Edge Id y REF es el Edge Id del registro de este documento (campos comunes de [TOULMIN](_index.md#공통-필드)). El Payload sigue a la TAG, sin campos de Issuer ni de número de Codec.

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1210`). La declaración de campos se fijará junto con los documentos de especificación de los Codecs TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE y delimitación](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001210/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
