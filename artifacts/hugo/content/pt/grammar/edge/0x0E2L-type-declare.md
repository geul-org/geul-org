---
title: "TYPE-DECLARE (0x0E2L)"
weight: 226
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TYPE-DECLARE é o Codec do grupo de declaração dos Edge de execução."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TYPE-DECLARE é o Codec do grupo de declaração dos Edge de execução. Significado: declaração de tipo.

| Item | Valor |
|---|---|
| Nome | `TYPE-DECLARE` (BIND `TYPE-DECLARE` do documento de especificação) |
| TAG ID | `0x0E2L` |
| Codec ID | `0x00000E20` |
| Documento de especificação | `0x00000000/codecs/0x00000E20/` (alvo do DECLARE `0E20`) |
| Seção | 7 `0111` (Edge de execução), deslocamento C = 2 dentro da seção |
| Kind | Edge · família: execução, grupo: declaração |
| TAG WORD | `0000 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição de índice | Declaração de tipo. Símbolo e composição (lista de símbolos de campo, valores de enumeração, alvo do alias) |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Símbolo e composição (lista de símbolos de campo, valores de enumeração, alvo do alias).

- Os componentes são referenciados pelo LOCAL ID (REF) deste documento. REF `0` significa ausência. Onde se espera uma expressão, coloca-se um Edge de expressão ou um símbolo ([Edge](_index.md#실행-edge)).
- O código de operador, a representação de tipos e o layout do Payload ainda não foram definidos (problemas em aberto de [Edge](_index.md#실행-edge)).

## Documento do Codec {#코덱-문서}

O layout ainda não foi definido. O documento do Codec contém apenas o DECLARE (alvo `0E20`). Os FIELD serão incluídos quando o layout for definido.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de execução](_index.md#실행-edge), [FUNCTION-DECLARE](0x0E1L-function-declare.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000E20/latest.geul` lido com `geul show` (hexadecimais em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E2000000000
BODY
#1 DECLARE 0x0E20
#2 BIND #1 "TYPE-DECLARE"
```
