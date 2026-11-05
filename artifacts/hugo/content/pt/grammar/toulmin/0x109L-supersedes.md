---
title: "SUPERSEDES (0x109L)"
weight: 265
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDES é um Codec LINK que escreve uma relação do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDES é um Codec LINK que escreve uma relação do grafo TOULMIN. Significado: relação de exclusão. Se o atacante estiver Active, o alvo é retirado deterministicamente da agregação. Uma cadeia (`A > B > C`) é escrita com um SUPERSEDES por par.

| Item | Valor |
|---|---|
| Nome | `SUPERSEDES` (BIND do documento de especificação `SUPERSEDES`) |
| TAG ID | `0x109L` |
| Codec ID | `0x00001090` |
| Documento de especificação | `0x00000000/codecs/0x00001090/` (alvo do DECLARE `1090`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 9 |
| Kind | Edge · família: TOULMIN, grupo: relação, layout: LINK |
| TAG WORD | `0001 0000 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | relação de exclusão. Se o atacante estiver Active, o alvo é retirado deterministicamente da agregação. Uma cadeia (`A > B > C`) é escrita com um SUPERSEDES por par |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

O layout é [LINK](_index.md#link) (ID, src, dst, flags, campos condicionais, SPAN).

| Item | Valor |
|---|---|
| TANGEUL | `X supersedes Y` |
| src → dst | regra → regra. Se Active, retira o alvo da agregação |

- Uma cadeia SUPERSEDES `A > B > C` é escrita com um SUPERSEDES por par. A forma abreviada [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) ainda não tem layout.
- F_FORCE não é usado (se estiver ligado, é rejeitado).
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1090`). Os campos condicionais do layout LINK e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001090/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000109000000000
BODY
#1 DECLARE 0x1090
#2 BIND #1 "SUPERSEDES"
```
