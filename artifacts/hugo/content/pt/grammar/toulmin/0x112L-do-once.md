---
title: "DO-ONCE (0x112L)"
weight: 274
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "DO-ONCE é um Codec LINK que escreve uma relação do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DO-ONCE é um Codec LINK que escreve uma relação do grafo TOULMIN. Significado: ação executada uma única vez, mesmo com novas tentativas.

| Item | Valor |
|---|---|
| Nome | `DO-ONCE` (BIND do documento de especificação `DO-ONCE`) |
| TAG ID | `0x112L` |
| Codec ID | `0x00001120` |
| Documento de especificação | `0x00000000/codecs/0x00001120/` (alvo do DECLARE `1120`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 18 |
| Kind | Edge · família: TOULMIN, grupo: execução, layout: LINK |
| TAG WORD | `0001 0001 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | ação executada uma única vez, mesmo com novas tentativas |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

O layout é [LINK](_index.md#link) (ID, src, dst, flags, campos condicionais, SPAN).

| Item | Valor |
|---|---|
| TANGEUL | `do fn once when n` |
| src → dst | regra → FuncRef |

- dst é um FuncRef. `do … once` é representado por este Codec. F_ONCE não é usado em flags (se estiver ligado, é rejeitado).
- F_FORCE não é usado (se estiver ligado, é rejeitado).
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1120`). Os campos condicionais do layout LINK e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001120/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000112000000000
BODY
#1 DECLARE 0x1120
#2 BIND #1 "DO-ONCE"
```
