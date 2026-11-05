---
title: "IMPORTED-FROM (0x133L)"
weight: 307
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "IMPORTED-FROM é um Codec LINK que escreve uma relação do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IMPORTED-FROM é um Codec LINK que escreve uma relação do grafo TOULMIN. Significado: alias → caminho (TEXT).

| Item | Valor |
|---|---|
| Nome | `IMPORTED-FROM` (BIND do documento de especificação `IMPORTED-FROM`) |
| TAG ID | `0x133L` |
| Codec ID | `0x00001330` |
| Documento de especificação | `0x00000000/codecs/0x00001330/` (alvo do DECLARE `1330`) |
| Seção | 9 `1001` (Edge, formato TOULMIN), deslocamento dentro da seção C = 19 |
| Kind | Edge · família: formato TOULMIN, layout: LINK |
| TAG WORD | `0001 0011 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | alias → caminho (TEXT) |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

O layout é [LINK](_index.md#link) (ID, src, dst, flags, campos condicionais, SPAN).

| Item | Valor |
|---|---|
| TANGEUL | `see a from path` |
| src → dst | alias → caminho (TEXT) |

- dst é o REF de um registro TEXT.
- F_FORCE não é usado (se estiver ligado, é rejeitado).
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1330`). Os campos condicionais do layout LINK e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001330/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000133000000000
BODY
#1 DECLARE 0x1330
#2 BIND #1 "IMPORTED-FROM"
```
