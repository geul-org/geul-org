---
title: "CASE-BEGIN (0x123L)"
weight: 291
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-BEGIN é um registro de texto-fonte e de seção de um documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-BEGIN é um registro de texto-fonte e de seção de um documento TOULMIN. Significado: início do escopo de um caso.

| Item | Valor |
|---|---|
| Nome | `CASE-BEGIN` (BIND do documento de especificação `CASE-BEGIN`) |
| TAG ID | `0x123L` |
| Codec ID | `0x00001230` |
| Documento de especificação | `0x00000000/codecs/0x00001230/` (alvo do DECLARE `1230`) |
| Seção | 9 `1001` (Edge, formato TOULMIN), deslocamento dentro da seção C = 3 |
| Kind | Edge · família: formato TOULMIN, layout: ID, REF (caso) |
| TAG WORD | `0001 0010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | início do escopo de um caso |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

É o início do escopo de um caso.

```
ID
caso             REF(NODE CASE-DECLARE)
```

- O escopo de um caso (NODE [CASE-DECLARE](0x100L-case-declare.md)) fica entre CASE-BEGIN e [CASE-END](0x124L-case-end.md), que apontam para ele.

- ID é o Edge Id, e REF é o Edge Id de um registro deste documento (campos comuns de [TOULMIN](_index.md#공통-필드)). O Payload vem logo após a TAG, sem campos de Issuer e de número de Codec.

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1230`). A declaração de campos será definida junto com os documentos de especificação dos Codecs TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE e seções](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001230/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000123000000000
BODY
#1 DECLARE 0x1230
#2 BIND #1 "CASE-BEGIN"
```
