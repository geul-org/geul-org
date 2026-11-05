---
title: "WORLD (0x0B0L)"
weight: 176
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "WORLD é o Edge de enunciado que escreve a cosmovisão."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WORLD é o Edge de enunciado que escreve a cosmovisão. Significado: estrutura para expressar a cosmovisão.

| Item | Valor |
|---|---|
| Nome | `WORLD` (BIND `WORLD` do documento de especificação) |
| TAG ID | `0x0B0L` |
| Codec ID | `0x00000B00` |
| Documento de especificação | `0x00000000/codecs/0x00000B00/` (alvo do DECLARE `0B00`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 16 |
| Kind | Edge · família: enunciado, grupo: estrutura |
| TAG WORD | `0000 1011 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | estrutura para expressar a cosmovisão |
| Lado Hugo | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1011 0000 LLLL      Codec 0x0B0L
[TAG estendida de Length]
TAG do Codec      1 WORD. Subformato
Edge Id           registro Reference LOCAL
componentes       definidos pelo subformato
```

- É um Codec com subformato. 1 WORD de TAG específica do Codec indica o subformato ([registro e TAG WORD](../record.md#레코드-레이아웃)).
- O subformato e os componentes ainda não foram definidos.

## Documento do codec {#코덱-문서}

O layout ainda não foi definido. O documento do codec contém apenas o DECLARE (alvo `0B00`). Os FIELDs serão postos quando o layout for definido.

## Páginas relacionadas {#관련-페이지}

- [TIMELINE](0x0B1L-timeline.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (como declarar um Codec com subformatos)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000B00/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B0000000000
BODY
#1 DECLARE 0x0B00
#2 BIND #1 "WORLD"
```
