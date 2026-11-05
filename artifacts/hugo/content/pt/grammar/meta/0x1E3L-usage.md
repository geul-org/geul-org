---
title: "USAGE (0x1E3L)"
weight: 483
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Registra restrições de uso (por exemplo, proibição de treinamento, proibição de uso comercial)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `USAGE` (BIND `USAGE` do documento de especificação) |
| TAG ID | `0x1E3L` |
| Codec ID | `0x00001E30` |
| Documento de especificação | `0x00000000/codecs/0x00001E30/` (alvo do DECLARE `1E30`) |
| Seção | 15 `1111` (Meta), deslocamento C = 3 na seção |
| Kind | Meta · classe: política |
| TAG WORD | `0001 1110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Restrição de uso |
| Lado Hugo | `meta/policy/usage.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `usage` | #2 | registro | `000F` seção 0 inteira (curinga, Reference), `020F` seção 1 inteira (curinga, Reference), `040F` seção 2 inteira (curinga, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Registra restrições de uso (por exemplo, proibição de treinamento, proibição de uso comercial).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0011 LLLL      Codec 0x1E3L
[TAG de extensão de Length]
Payload           Texto ou Reference que expressa a restrição de uso
```

- Codec: Meta `0x1E3L`, classe de política
- Payload: Value ou Reference embutido
- Quantidade: vários possíveis

## Problemas em aberto {#열린-문제}

- Tabela de códigos dos tipos de restrição.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001E30/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E3000000000
BODY
#1 DECLARE 0x1E30
#2 FIELD #1 record
#3 BIND #1 "USAGE"
#4 BIND #2 "usage"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
