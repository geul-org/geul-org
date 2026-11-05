---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT é um registro de texto-fonte e de seção de um documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT é um registro de texto-fonte e de seção de um documento TOULMIN. Significado: nome ou cadeia de caracteres.

| Item | Valor |
|---|---|
| Nome | `TEXT` (BIND do documento de especificação `TEXT`) |
| TAG ID | `0x121L` |
| Codec ID | `0x00001210` |
| Documento de especificação | `0x00000000/codecs/0x00001210/` (alvo do DECLARE `1210`) |
| Seção | 9 `1001` (Edge, formato TOULMIN), deslocamento dentro da seção C = 1 |
| Kind | Edge · família: formato TOULMIN, layout: ID, Value UTF8 |
| TAG WORD | `0001 0010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | nome ou cadeia de caracteres |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

É um único nome ou cadeia de caracteres. As listas F_WITH e F_GROUNDS de NODE e os [LABEL](0x134L-label.md) e [IMPORTED-FROM](0x133L-imported-from.md) de LINK apontam para ele por REF.

```
ID
cadeia           registro Value UTF8-TEXT
```

- ID é o Edge Id, e REF é o Edge Id de um registro deste documento (campos comuns de [TOULMIN](_index.md#공통-필드)). O Payload vem logo após a TAG, sem campos de Issuer e de número de Codec.

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1210`). A declaração de campos será definida junto com os documentos de especificação dos Codecs TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE e seções](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001210/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
