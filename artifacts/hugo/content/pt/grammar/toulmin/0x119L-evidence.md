---
title: "EVIDENCE (0x119L)"
weight: 281
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EVIDENCE é um Codec Edge TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EVIDENCE é um Codec Edge TOULMIN. Significado: evidência do julgamento. Posição, valor esperado, valor real (Fact).

| Item | Valor |
|---|---|
| Nome | `EVIDENCE` (BIND do documento de especificação `EVIDENCE`) |
| TAG ID | `0x119L` |
| Codec ID | `0x00001190` |
| Documento de especificação | `0x00000000/codecs/0x00001190/` (alvo do DECLARE `1190`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 25 |
| Kind | Edge · família: TOULMIN, grupo: resultado |
| TAG WORD | `0001 0001 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | evidência do julgamento. Posição, valor esperado, valor real (Fact). Layout indefinido |
| Lado Hugo | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Apenas o código foi atribuído e o layout ainda não existe ([TOULMIN](_index.md#열린-문제)).

- O resultado do julgamento fica em um documento diferente do alvo do julgamento ([TOULMIN](_index.md#판정-결과)).

## Documento do Codec {#코덱-문서}

O layout não está definido. O documento do Codec contém apenas um DECLARE (alvo `1190`). FIELD será acrescentado quando o layout for definido.

## Páginas relacionadas {#관련-페이지}

- [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001190/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000119000000000
BODY
#1 DECLARE 0x1190
#2 BIND #1 "EVIDENCE"
```
