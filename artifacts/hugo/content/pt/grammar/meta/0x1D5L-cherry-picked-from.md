---
title: "CHERRY-PICKED-FROM (0x1D5L)"
weight: 469
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Registra o hash de conteúdo da versão original da qual se trouxe uma alteração de outra linhagem (git cherry-pick -x)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `CHERRY-PICKED-FROM` (BIND `CHERRY-PICKED-FROM` do documento de especificação) |
| TAG ID | `0x1D5L` |
| Codec ID | `0x00001D50` |
| Documento de especificação | `0x00000000/codecs/0x00001D50/` (alvo do DECLARE `1D50`) |
| Seção | 14 `1110` (Meta), deslocamento C = 21 na seção |
| Kind | Meta · classe: linhagem |
| TAG WORD | `0001 1101 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Hash de conteúdo da versão original da qual se trouxe uma alteração de outra linhagem (git cherry-pick `-x`) |
| Lado Hugo | `meta/lineage/cherry-picked-from.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | registro | `07C0` SHA-256-DIGEST |  |

Registra o hash de conteúdo da versão original da qual se trouxe uma alteração de outra linhagem (git cherry-pick `-x`).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0101 LLLL      Codec 0x1D5L
[TAG de extensão de Length]
Payload           Um Value SHA-256-DIGEST (16 WORDs)
```

- Codec: Meta `0x1D5L`, classe de linhagem
- Payload: Value embutido ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Quantidade: vários possíveis

## Interpretação e validade {#해석과-유효성}

- O formato de digest é embutido como Value para deixar espaço à troca do algoritmo de hash. Atualmente o hash de conteúdo é apenas SHA-256.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001D50/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D5000000000
BODY
#1 DECLARE 0x1D50
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "CHERRY-PICKED-FROM"
#4 BIND #2 "digest"
```
