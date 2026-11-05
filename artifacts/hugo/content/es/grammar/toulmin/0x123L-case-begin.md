---
title: "CASE-BEGIN (0x123L)"
weight: 291
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-BEGIN es un registro de texto original y de delimitación de un documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-BEGIN es un registro de texto original y de delimitación de un documento TOULMIN. Significado: inicio del ámbito de un caso.

| Elemento | Valor |
|---|---|
| Nombre | `CASE-BEGIN` (BIND `CASE-BEGIN` del documento de especificación) |
| TAG ID | `0x123L` |
| Codec ID | `0x00001230` |
| Documento de especificación | `0x00000000/codecs/0x00001230/` (destino de DECLARE `1230`) |
| Sección | 9 `1001` (formato Edge TOULMIN), desplazamiento dentro de la sección C = 3 |
| Kind | Edge · familia: formato TOULMIN, layout: ID, REF (caso) |
| TAG WORD | `0001 0010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | inicio del ámbito de un caso |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Es el inicio del ámbito de un caso.

```
ID
caso             REF (NODE de CASE-DECLARE)
```

- Para un mismo caso (NODE de [CASE-DECLARE](0x100L-case-declare.md)), su ámbito va entre CASE-BEGIN y [CASE-END](0x124L-case-end.md) que lo señalan.

- ID es el Edge Id y REF es el Edge Id del registro de este documento (campos comunes de [TOULMIN](_index.md#공통-필드)). El Payload sigue a la TAG, sin campos de Issuer ni de número de Codec.

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1230`). La declaración de campos se fijará junto con los documentos de especificación de los Codecs TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE y delimitación](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001230/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000123000000000
BODY
#1 DECLARE 0x1230
#2 BIND #1 "CASE-BEGIN"
```
