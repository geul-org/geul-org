---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE é o Codec do grupo de declaração dos Edge de execução."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE é o Codec do grupo de declaração dos Edge de execução. Significado: declaração de função.

| Item | Valor |
|---|---|
| Nome | `FUNCTION-DECLARE` (BIND `FUNCTION-DECLARE` do documento de especificação) |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| Documento de especificação | `0x00000000/codecs/0x00000E10/` (alvo do DECLARE `0E10`) |
| Seção | 7 `0111` (Edge de execução), deslocamento C = 1 dentro da seção |
| Kind | Edge · família: execução, grupo: declaração |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição de índice | Declaração de função. Símbolo, lista de símbolos de parâmetro, tipo de retorno, corpo (BLOCK) |
| Lado Hugo | `edge/_index.md` |

## Componentes {#구성요소}

Símbolo, lista de símbolos de parâmetro, tipo de retorno, corpo (BLOCK).

- Os componentes são referenciados pelo LOCAL ID (REF) deste documento. REF `0` significa ausência. Onde se espera uma expressão, coloca-se um Edge de expressão ou um símbolo ([Edge](_index.md#실행-edge)).
- O código de operador, a representação de tipos e o layout do Payload ainda não foram definidos (problemas em aberto de [Edge](_index.md#실행-edge)).

## Documento do Codec {#코덱-문서}

O layout ainda não foi definido. O documento do Codec contém apenas o DECLARE (alvo `0E10`). Os FIELD serão incluídos quando o layout for definido.

## Páginas relacionadas {#관련-페이지}

- [Edge — Edge de execução](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000E10/latest.geul` lido com `geul show` (hexadecimais em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
