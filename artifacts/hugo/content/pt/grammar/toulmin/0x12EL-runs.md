---
title: "RUNS (0x12EL)"
weight: 302
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RUNS é um Codec LINK que escreve uma relação do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RUNS é um Codec LINK que escreve uma relação do grafo TOULMIN. Significado: ponto de entrada → caso, execução.

| Item | Valor |
|---|---|
| Nome | `RUNS` (BIND do documento de especificação `RUNS`) |
| TAG ID | `0x12EL` |
| Codec ID | `0x000012E0` |
| Documento de especificação | `0x00000000/codecs/0x000012E0/` (alvo do DECLARE `12E0`) |
| Seção | 9 `1001` (Edge, formato TOULMIN), deslocamento dentro da seção C = 14 |
| Kind | Edge · família: formato TOULMIN, layout: LINK |
| TAG WORD | `0001 0010 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | ponto de entrada → caso, execução |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

O layout é [LINK](_index.md#link) (ID, src, dst, flags, campos condicionais, SPAN).

| Item | Valor |
|---|---|
| TANGEUL | ponto de entrada `run c` |
| src → dst | ponto de entrada → caso (execução) |

- dst é o REF de um nó.
- F_FORCE não é usado (se estiver ligado, é rejeitado).
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `12E0`). Os campos condicionais do layout LINK e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x000012E0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012E000000000
BODY
#1 DECLARE 0x12E0
#2 BIND #1 "RUNS"
```
