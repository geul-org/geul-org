---
title: "BINARY (0x0EAL)"
weight: 234
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "BINARY é o Codec do grupo de expressões dos Edge de execução."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY é o Codec do grupo de expressões dos Edge de execução. Significado: expressão binária.

| Item | Valor |
|---|---|
| Nome | `BINARY` (BIND `BINARY` do documento de especificação) |
| TAG ID | `0x0EAL` |
| Codec ID | `0x00000EA0` |
| Documento de especificação | `0x00000000/codecs/0x00000EA0/` (alvo do DECLARE `0EA0`) |
| Seção | 7 `0111` (Edge de execução), deslocamento C = 10 dentro da seção |
| Kind | Edge · família: execução, grupo: expressão |
| TAG WORD | `0000 1110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição de índice | Expressão binária. Operador de 1 WORD, esquerda, direita |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Operador de 1 WORD, esquerda, direita.

- Os componentes são referenciados pelo LOCAL ID (REF) deste documento. REF `0` significa ausência. Onde se espera uma expressão, coloca-se um Edge de expressão ou um símbolo ([Edge](_index.md#실행-edge)).
- O código de operador, a representação de tipos e o layout do Payload ainda não foram definidos (problemas em aberto de [Edge](_index.md#실행-edge)).

## Documento do Codec {#코덱-문서}

O layout ainda não foi definido. O documento do Codec contém apenas o DECLARE (alvo `0EA0`). Os FIELD serão incluídos quando o layout for definido.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de execução](_index.md#실행-edge), [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000EA0/latest.geul` lido com `geul show` (hexadecimais em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000EA000000000
BODY
#1 DECLARE 0x0EA0
#2 BIND #1 "BINARY"
```
