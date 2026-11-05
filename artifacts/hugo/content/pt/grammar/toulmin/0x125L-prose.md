---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE é um registro de texto-fonte e de seção de um documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE é um registro de texto-fonte e de seção de um documento TOULMIN. Significado: parágrafo descritivo.

| Item | Valor |
|---|---|
| Nome | `PROSE` (BIND do documento de especificação `PROSE`) |
| TAG ID | `0x125L` |
| Codec ID | `0x00001250` |
| Documento de especificação | `0x00000000/codecs/0x00001250/` (alvo do DECLARE `1250`) |
| Seção | 9 `1001` (Edge, formato TOULMIN), deslocamento dentro da seção C = 5 |
| Kind | Edge · família: formato TOULMIN, layout: ID, SPAN |
| TAG WORD | `0001 0010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | parágrafo descritivo |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

É um parágrafo descritivo que não é regra. Aponta apenas para um intervalo (SPAN) do texto-fonte.

```
ID
SPAN             largura definida por SOURCE × 2 (byte inicial, número de bytes)
```

- ID é o Edge Id, e REF é o Edge Id de um registro deste documento (campos comuns de [TOULMIN](_index.md#공통-필드)). O Payload vem logo após a TAG, sem campos de Issuer e de número de Codec.

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1250`). Como a largura do SPAN é definida por SOURCE, ela não pode ser declarada com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE e seções](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001250/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
