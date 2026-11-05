---
title: "RAISE (0x0F8L)"
weight: 248
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "RAISE é o Codec do grupo de erros dos Edge de execução."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RAISE é o Codec do grupo de erros dos Edge de execução. Significado: lançamento de erro.

| Item | Valor |
|---|---|
| Nome | `RAISE` (BIND `RAISE` do documento de especificação) |
| TAG ID | `0x0F8L` |
| Codec ID | `0x00000F80` |
| Documento de especificação | `0x00000000/codecs/0x00000F80/` (alvo do DECLARE `0F80`) |
| Seção | 7 `0111` (Edge de execução), deslocamento C = 24 dentro da seção |
| Kind | Edge · família: execução, grupo: erro |
| TAG WORD | `0000 1111 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição de índice | Lançamento de erro. Valor do erro |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Valor do erro.

- Os componentes são referenciados pelo LOCAL ID (REF) deste documento. REF `0` significa ausência. Onde se espera uma expressão, coloca-se um Edge de expressão ou um símbolo ([Edge](_index.md#실행-edge)).
- O código de operador, a representação de tipos e o layout do Payload ainda não foram definidos (problemas em aberto de [Edge](_index.md#실행-edge)).

## Documento do Codec {#코덱-문서}

O layout ainda não foi definido. O documento do Codec contém apenas o DECLARE (alvo `0F80`). Os FIELD serão incluídos quando o layout for definido.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de execução](_index.md#실행-edge), [TRY](0x0F9L-try.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000F80/latest.geul` lido com `geul show` (hexadecimais em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F8000000000
BODY
#1 DECLARE 0x0F80
#2 BIND #1 "RAISE"
```
