---
title: "ENTRY (0x115L)"
weight: 277
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ENTRY é um Codec NODE que escreve um nó do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENTRY é um Codec NODE que escreve um nó do grafo TOULMIN. Significado: ponto de entrada externo. Executa ou julga um caso.

| Item | Valor |
|---|---|
| Nome | `ENTRY` (BIND do documento de especificação `ENTRY`) |
| TAG ID | `0x115L` |
| Codec ID | `0x00001150` |
| Documento de especificação | `0x00000000/codecs/0x00001150/` (alvo do DECLARE `1150`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 21 |
| Kind | Edge · família: TOULMIN, grupo: execução, layout: NODE |
| TAG WORD | `0001 0001 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | ponto de entrada externo. Executa ou julga um caso |
| Lado Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

O layout é [NODE](_index.md#node). O cabeçalho de 1 WORD determina role, level, a forma da Claim e os campos condicionais.

| Item | Valor |
|---|---|
| TANGEUL | provides x |
| Nó | ponto de entrada externo |

- role deve ser 0.
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1150`). Os campos condicionais do layout NODE e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001150/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000115000000000
BODY
#1 DECLARE 0x1150
#2 BIND #1 "ENTRY"
```
