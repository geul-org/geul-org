---
title: "EXCEPT-DECLARE (0x105L)"
weight: 261
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXCEPT-DECLARE é um Codec NODE que escreve um nó do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXCEPT-DECLARE é um Codec NODE que escreve um nó do grafo TOULMIN. Significado: declaração de exceção. Ataca sem conclusão própria. O Level padrão é Review.

| Item | Valor |
|---|---|
| Nome | `EXCEPT-DECLARE` (BIND do documento de especificação `EXCEPT-DECLARE`) |
| TAG ID | `0x105L` |
| Codec ID | `0x00001050` |
| Documento de especificação | `0x00000000/codecs/0x00001050/` (alvo do DECLARE `1050`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 5 |
| Kind | Edge · família: TOULMIN, grupo: declaração, layout: NODE |
| TAG WORD | `0001 0000 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | declaração de exceção. Ataca sem conclusão própria. O Level padrão é Review |
| Lado Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

O layout é [NODE](_index.md#node). O cabeçalho de 1 WORD determina role, level, a forma da Claim e os campos condicionais.

| Item | Valor |
|---|---|
| TANGEUL | except rule |
| Nó | exceção (Defeater) |

- role deve ser 2 (except). Se level for 0 (Unset), usa-se o padrão do motor, Review.
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1050`). Os campos condicionais do layout NODE e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001050/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000105000000000
BODY
#1 DECLARE 0x1050
#2 BIND #1 "EXCEPT-DECLARE"
```
