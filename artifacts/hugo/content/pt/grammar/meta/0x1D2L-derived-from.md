---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Registra que este documento deriva de documentos ou materiais de outra linhagem."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `DERIVED-FROM` (BIND `DERIVED-FROM` do documento de especificação) |
| TAG ID | `0x1D2L` |
| Codec ID | `0x00001D20` |
| Documento de especificação | `0x00000000/codecs/0x00001D20/` (alvo do DECLARE `1D20`) |
| Seção | 14 `1110` (Meta), deslocamento C = 18 na seção |
| Kind | Meta · classe: linhagem |
| TAG WORD | `0001 1101 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Derivado de registros ou materiais de outra linhagem. Para fixar uma versão específica de um material externo, anexa-se ao [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) do HEAD o QUALIFIER de hash do original (P4092) (git submodule). |
| Lado Hugo | `meta/lineage/derived-from.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | registro | `000F` seção 0 inteira (curinga, Reference), `020F` seção 1 inteira (curinga, Reference), `040F` seção 2 inteira (curinga, Reference), `07C0` SHA-256-DIGEST, `0740` URI-EVEN, `0750` URI-ODD |  |

Registra que este documento deriva de documentos ou materiais de outra linhagem.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[TAG de extensão de Length]
Payload           Reference, ou SHA-256-DIGEST (hash de conteúdo), ou Value URI
```

- Codec: Meta `0x1D2L`, classe de linhagem
- Payload: Reference ou Value embutido
- Quantidade: vários possíveis

## Interpretação e validade {#해석과-유효성}

- Se derivado de um documento GEUL, coloca-se o seu hash de conteúdo ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)); se de material externo, um [URI](../value/0x074L-uri.md). Para fixar por hash a edição de um material externo, anexa-se ao [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) do HEAD o QUALIFIER de hash do original (P4092).
- A origem por registro cabe ao Edge de fundamento [SOURCE](../edge/0x0C0L-source.md); o registro antigo anterior a movimento, divisão ou fusão cabe ao QUALIFIER P1365 do Edge de destino (o valor é o Id do Edge antigo).

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001D20/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
