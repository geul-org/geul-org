---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE é um registro de texto-fonte e de seção de um documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE é um registro de texto-fonte e de seção de um documento TOULMIN. Significado: texto-fonte original.

| Item | Valor |
|---|---|
| Nome | `SOURCE` (BIND do documento de especificação `SOURCE`) |
| TAG ID | `0x120L` |
| Codec ID | `0x00001200` |
| Documento de especificação | `0x00000000/codecs/0x00001200/` (alvo do DECLARE `1200`) |
| Seção | 9 `1001` (Edge, formato TOULMIN), deslocamento dentro da seção C = 0 |
| Kind | Edge · família: formato TOULMIN, layout: ID, WORD de largura do SPAN, Value UTF8 |
| TAG WORD | `0001 0010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | texto-fonte original |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

É o texto-fonte original por inteiro. Todo SPAN é um intervalo de bytes dentro deste texto.

```
ID
WORD de largura  2 bits superiores = largura (00=1, 01=2, 10=4, 11=8 WORD), 14 bits restantes = 0
texto-fonte      registro Value UTF8-TEXT
```

- SOURCE é o primeiro registro de BODY. Há um por documento.
- SPAN tem dois campos: byte inicial e número de bytes. Cada campo é um inteiro unsigned com a largura (1/2/4/8 WORD) definida pelo WORD de largura do SPAN.
- É um Codec diferente do Edge de fundamento [SOURCE](../edge/0x0C0L-source.md) (`0x0C0L`).

- ID é o Edge Id, e REF é o Edge Id de um registro deste documento (campos comuns de [TOULMIN](_index.md#공통-필드)). O Payload vem logo após a TAG, sem campos de Issuer e de número de Codec.

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1200`). A declaração de campos será definida junto com os documentos de especificação dos Codecs TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE e seções](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001200/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
