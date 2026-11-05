---
title: "HAS (0x12DL)"
weight: 301
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "HAS é um Codec LINK que escreve uma relação do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

HAS é um Codec LINK que escreve uma relação do grafo TOULMIN. Significado: item de definição → campo.

| Item | Valor |
|---|---|
| Nome | `HAS` (BIND do documento de especificação `HAS`) |
| TAG ID | `0x12DL` |
| Codec ID | `0x000012D0` |
| Documento de especificação | `0x00000000/codecs/0x000012D0/` (alvo do DECLARE `12D0`) |
| Seção | 9 `1001` (Edge, formato TOULMIN), deslocamento dentro da seção C = 13 |
| Kind | Edge · família: formato TOULMIN, layout: LINK |
| TAG WORD | `0001 0010 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | item de definição → campo |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

O layout é [LINK](_index.md#link) (ID, src, dst, flags, campos condicionais, SPAN).

| Item | Valor |
|---|---|
| TANGEUL | Definitions `has` |
| src → dst | item de definição → campo |

- dst é o REF de um nó.
- F_FORCE não é usado (se estiver ligado, é rejeitado).
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `12D0`). Os campos condicionais do layout LINK e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x000012D0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012D000000000
BODY
#1 DECLARE 0x12D0
#2 BIND #1 "HAS"
```
