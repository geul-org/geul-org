---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION é um registro de texto-fonte e de seção de um documento TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION é um registro de texto-fonte e de seção de um documento TOULMIN. Significado: início de seção.

| Item | Valor |
|---|---|
| Nome | `SECTION` (BIND do documento de especificação `SECTION`) |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| Documento de especificação | `0x00000000/codecs/0x00001220/` (alvo do DECLARE `1220`) |
| Seção | 9 `1001` (Edge, formato TOULMIN), deslocamento dentro da seção C = 2 |
| Kind | Edge · família: formato TOULMIN, layout: ID, código de seção de 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | início de seção |
| Lado Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

É o início de uma seção. O código de seção ocupa 1 WORD.

```
ID
código de seção  1 WORD
```

| Código | Seção | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | regra de expressão condicional |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` não é usado. As seções são declaradas na ordem destes códigos.
- O título da seção é o [PROSE](0x125L-prose.md) logo após SECTION.

- ID é o Edge Id, e REF é o Edge Id de um registro deste documento (campos comuns de [TOULMIN](_index.md#공통-필드)). O Payload vem logo após a TAG, sem campos de Issuer e de número de Codec.

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1220`). A declaração de campos será definida junto com os documentos de especificação dos Codecs TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [SOURCE e seções](_index.md#source와-구획), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001220/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
