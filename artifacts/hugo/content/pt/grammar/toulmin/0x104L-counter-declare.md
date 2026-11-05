---
title: "COUNTER-DECLARE (0x104L)"
weight: 260
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "COUNTER-DECLARE é um Codec NODE que escreve um nó do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COUNTER-DECLARE é um Codec NODE que escreve um nó do grafo TOULMIN. Significado: declaração de contestação. Ataca com conclusão própria. O Level padrão é Fail.

| Item | Valor |
|---|---|
| Nome | `COUNTER-DECLARE` (BIND do documento de especificação `COUNTER-DECLARE`) |
| TAG ID | `0x104L` |
| Codec ID | `0x00001040` |
| Documento de especificação | `0x00000000/codecs/0x00001040/` (alvo do DECLARE `1040`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 4 |
| Kind | Edge · família: TOULMIN, grupo: declaração, layout: NODE |
| TAG WORD | `0001 0000 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | declaração de contestação. Ataca com conclusão própria. O Level padrão é Fail |
| Lado Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

O layout é [NODE](_index.md#node). O cabeçalho de 1 WORD determina role, level, a forma da Claim e os campos condicionais.

| Item | Valor |
|---|---|
| TANGEUL | counter rule |
| Nó | contestação (Rebuttal) |

- role deve ser 1 (counter). Se level for 0 (Unset), usa-se o padrão do motor, Fail.
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1040`). Os campos condicionais do layout NODE e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001040/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000104000000000
BODY
#1 DECLARE 0x1040
#2 BIND #1 "COUNTER-DECLARE"
```
