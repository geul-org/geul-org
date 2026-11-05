---
title: "IF (0x0F2L)"
weight: 242
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "IF é o Codec do grupo de instruções dos Edge de execução."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IF é o Codec do grupo de instruções dos Edge de execução. Significado: ramificação condicional.

| Item | Valor |
|---|---|
| Nome | `IF` (BIND `IF` do documento de especificação) |
| TAG ID | `0x0F2L` |
| Codec ID | `0x00000F20` |
| Documento de especificação | `0x00000000/codecs/0x00000F20/` (alvo do DECLARE `0F20`) |
| Seção | 7 `0111` (Edge de execução), deslocamento C = 18 dentro da seção |
| Kind | Edge · família: execução, grupo: instrução |
| TAG WORD | `0000 1111 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição de índice | Ramificação condicional. Condição, BLOCK verdadeiro, falso (BLOCK·IF, 0 se não houver) |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Condição, BLOCK verdadeiro, falso (BLOCK·IF, 0 se não houver).

- Os componentes são referenciados pelo LOCAL ID (REF) deste documento. REF `0` significa ausência. Onde se espera uma expressão, coloca-se um Edge de expressão ou um símbolo ([Edge](_index.md#실행-edge)).
- O código de operador, a representação de tipos e o layout do Payload ainda não foram definidos (problemas em aberto de [Edge](_index.md#실행-edge)).

## Documento do Codec {#코덱-문서}

O layout ainda não foi definido. O documento do Codec contém apenas o DECLARE (alvo `0F20`). Os FIELD serão incluídos quando o layout for definido.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de execução](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000F20/latest.geul` lido com `geul show` (hexadecimais em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F2000000000
BODY
#1 DECLARE 0x0F20
#2 BIND #1 "IF"
```
