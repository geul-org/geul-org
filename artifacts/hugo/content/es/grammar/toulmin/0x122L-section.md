---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION es un registro de texto original y de delimitación de un documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION es un registro de texto original y de delimitación de un documento TOULMIN. Significado: inicio de sección.

| Elemento | Valor |
|---|---|
| Nombre | `SECTION` (BIND `SECTION` del documento de especificación) |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| Documento de especificación | `0x00000000/codecs/0x00001220/` (destino de DECLARE `1220`) |
| Sección | 9 `1001` (formato Edge TOULMIN), desplazamiento dentro de la sección C = 2 |
| Kind | Edge · familia: formato TOULMIN, layout: ID, código de sección de 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | inicio de sección |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Es el inicio de una sección. El código de sección es 1 WORD.

```
ID
código de secc.  1 WORD
```

| Código | Sección | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | regla de expresión condicional |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` no se usa. Las secciones se declaran en el orden de estos códigos.
- El título de la sección es el [PROSE](0x125L-prose.md) que sigue inmediatamente a SECTION.

- ID es el Edge Id y REF es el Edge Id del registro de este documento (campos comunes de [TOULMIN](_index.md#공통-필드)). El Payload sigue a la TAG, sin campos de Issuer ni de número de Codec.

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1220`). La declaración de campos se fijará junto con los documentos de especificación de los Codecs TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE y delimitación](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001220/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
