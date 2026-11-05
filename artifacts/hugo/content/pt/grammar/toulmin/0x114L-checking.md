---
title: "CHECKING (0x114L)"
weight: 276
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CHECKING é um Codec LINK que escreve uma relação do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CHECKING é um Codec LINK que escreve uma relação do grafo TOULMIN. Significado: ligação que apenas julga, sem efeitos colaterais.

| Item | Valor |
|---|---|
| Nome | `CHECKING` (BIND do documento de especificação `CHECKING`) |
| TAG ID | `0x114L` |
| Codec ID | `0x00001140` |
| Documento de especificação | `0x00000000/codecs/0x00001140/` (alvo do DECLARE `1140`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 20 |
| Kind | Edge · família: TOULMIN, grupo: execução, layout: LINK |
| TAG WORD | `0001 0001 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | ligação que apenas julga, sem efeitos colaterais |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

O layout é [LINK](_index.md#link) (ID, src, dst, flags, campos condicionais, SPAN).

| Item | Valor |
|---|---|
| TANGEUL | `checking c` |
| src → dst | regra → caso. Julgamento sem efeitos colaterais |

- dst é o REF de um nó.
- F_FORCE não é usado (se estiver ligado, é rejeitado).
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1140`). Os campos condicionais do layout LINK e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001140/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000114000000000
BODY
#1 DECLARE 0x1140
#2 BIND #1 "CHECKING"
```
