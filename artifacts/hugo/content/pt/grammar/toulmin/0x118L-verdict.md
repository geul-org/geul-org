---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT é um Codec Edge TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT é um Codec Edge TOULMIN. Significado: resultado do julgamento de um nó ou registro. Resultado (Pass, Review, Fail), valor do julgamento, Activated, Excluded, Level.

| Item | Valor |
|---|---|
| Nome | `VERDICT` (BIND do documento de especificação `VERDICT`) |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| Documento de especificação | `0x00000000/codecs/0x00001180/` (alvo do DECLARE `1180`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 24 |
| Kind | Edge · família: TOULMIN, grupo: resultado |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | resultado do julgamento de um nó ou registro. Resultado (Pass, Review, Fail), valor do julgamento, Activated, Excluded, Level. Layout indefinido |
| Lado Hugo | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Apenas o código foi atribuído e o layout ainda não existe ([TOULMIN](_index.md#열린-문제)).

- O julgamento do documento inteiro cabe ao Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`). São Codecs distintos, de Kind diferente.
- O resultado do julgamento fica em um documento diferente do alvo do julgamento ([TOULMIN](_index.md#판정-결과)).

## Documento do Codec {#코덱-문서}

O layout não está definido. O documento do Codec contém apenas um DECLARE (alvo `1180`). FIELD será acrescentado quando o layout for definido.

## Páginas relacionadas {#관련-페이지}

- [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001180/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
