---
title: "LABEL (0x134L)"
weight: 308
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LABEL é um Codec LINK que escreve uma relação do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL é um Codec LINK que escreve uma relação do grafo TOULMIN. Significado: nó → TEXT, notação de nome.

| Item | Valor |
|---|---|
| Nome | `LABEL` (BIND do documento de especificação `LABEL`) |
| TAG ID | `0x134L` |
| Codec ID | `0x00001340` |
| Documento de especificação | `0x00000000/codecs/0x00001340/` (alvo do DECLARE `1340`) |
| Seção | 9 `1001` (Edge, formato TOULMIN), deslocamento dentro da seção C = 20 |
| Kind | Edge · família: formato TOULMIN, layout: LINK |
| TAG WORD | `0001 0011 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | nó → TEXT, notação de nome |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

O layout é [LINK](_index.md#link) (ID, src, dst, flags, campos condicionais, SPAN).

| Item | Valor |
|---|---|
| TANGEUL | nome entre crases |
| src → dst | nó → TEXT. Notação de nome |

- dst é o REF de um registro TEXT. Se um nome entre crases deve virar um [LABEL](../edge/0x0A4L-label.md) ou [BIND](../edge/0x0A3L-bind.md) de enunciado é um problema em aberto ([TOULMIN](_index.md#열린-문제)).
- F_FORCE não é usado (se estiver ligado, é rejeitado).
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1340`). Os campos condicionais do layout LINK e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001340/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000134000000000
BODY
#1 DECLARE 0x1340
#2 BIND #1 "LABEL"
```
