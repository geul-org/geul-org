---
title: "VERB (0x0A9L)"
weight: 169
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB é um Edge de enunciado com verbo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB é um Edge de enunciado com verbo. A forma abreviada é [VERB-SHORT](0x0A8L-verb-short.md) (`0x0A8L`) ([Edge](_index.md#서술-edge)).

| Item | Valor |
|---|---|
| Nome | `VERB` (BIND `VERB` do documento de especificação) |
| TAG ID | `0x0A9L` |
| Codec ID | `0x00000A90` |
| Documento de especificação | `0x00000000/codecs/0x00000A90/` (alvo do DECLARE `0A90`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 9 |
| Kind | Edge · família: enunciado, grupo: proposição |
| TAG WORD | `0000 1010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | enunciado com verbo |
| Lado Hugo | `edge/_index.md` |

## Layout {#레이아웃}

O layout ainda não foi definido. Segue o layout comum de Edge (TAG, [TAG estendida de Length], Edge Id, componentes) ([Edge](_index.md#레이아웃)).

## Documento do codec {#코덱-문서}

O layout ainda não foi definido. O documento do codec contém apenas o DECLARE (alvo `0A90`). Os FIELDs serão postos quando o layout for definido.

## Páginas relacionadas {#관련-페이지}

- [VERB-SHORT](0x0A8L-verb-short.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000A90/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A9000000000
BODY
#1 DECLARE 0x0A90
#2 BIND #1 "VERB"
```
