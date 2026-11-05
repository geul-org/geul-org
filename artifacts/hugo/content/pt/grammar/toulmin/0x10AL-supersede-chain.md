---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN é um Codec Edge TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN é um Codec Edge TOULMIN. Significado: cadeia de prioridade `A > B > C`. Abreviação de SUPERSEDES par a par.

| Item | Valor |
|---|---|
| Nome | `SUPERSEDE-CHAIN` (BIND do documento de especificação `SUPERSEDE-CHAIN`) |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| Documento de especificação | `0x00000000/codecs/0x000010A0/` (alvo do DECLARE `10A0`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 10 |
| Kind | Edge · família: TOULMIN, grupo: relação |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | cadeia de prioridade `A > B > C`. Abreviação de SUPERSEDES par a par. Layout indefinido |
| Lado Hugo | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Apenas o código foi atribuído e o layout ainda não existe ([TOULMIN](_index.md#열린-문제)).

- Por ora, escreve-se um [SUPERSEDES](0x109L-supersedes.md) por par. Se isso basta para a cadeia é um problema em aberto.

## Documento do Codec {#코덱-문서}

O layout não está definido. O documento do Codec contém apenas um DECLARE (alvo `10A0`). FIELD será acrescentado quando o layout for definido.

## Páginas relacionadas {#관련-페이지}

- [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x000010A0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
