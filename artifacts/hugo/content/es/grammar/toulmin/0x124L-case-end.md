---
title: "CASE-END (0x124L)"
weight: 292
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-END es un registro de texto original y de delimitación de un documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-END es un registro de texto original y de delimitación de un documento TOULMIN. Significado: fin del ámbito de un caso.

| Elemento | Valor |
|---|---|
| Nombre | `CASE-END` (BIND `CASE-END` del documento de especificación) |
| TAG ID | `0x124L` |
| Codec ID | `0x00001240` |
| Documento de especificación | `0x00000000/codecs/0x00001240/` (destino de DECLARE `1240`) |
| Sección | 9 `1001` (formato Edge TOULMIN), desplazamiento dentro de la sección C = 4 |
| Kind | Edge · familia: formato TOULMIN, layout: ID, REF (caso) |
| TAG WORD | `0001 0010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | fin del ámbito de un caso |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Es el fin del ámbito de un caso.

```
ID
caso             REF (NODE de CASE-DECLARE)
```

- Para un mismo caso (NODE de [CASE-DECLARE](0x100L-case-declare.md)), su ámbito va entre [CASE-BEGIN](0x123L-case-begin.md) y CASE-END que lo señalan.

- ID es el Edge Id y REF es el Edge Id del registro de este documento (campos comunes de [TOULMIN](_index.md#공통-필드)). El Payload sigue a la TAG, sin campos de Issuer ni de número de Codec.

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1240`). La declaración de campos se fijará junto con los documentos de especificación de los Codecs TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE y delimitación](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001240/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000124000000000
BODY
#1 DECLARE 0x1240
#2 BIND #1 "CASE-END"
```
