---
title: "CONSENT (0x1E2L)"
weight: 482
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Registra o escopo e o fundamento do consentimento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `CONSENT` (BIND `CONSENT` do documento de especificação) |
| TAG ID | `0x1E2L` |
| Codec ID | `0x00001E20` |
| Documento de especificação | `0x00000000/codecs/0x00001E20/` (alvo do DECLARE `1E20`) |
| Seção | 15 `1111` (Meta), deslocamento C = 2 na seção |
| Kind | Meta · classe: política |
| TAG WORD | `0001 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Escopo e fundamento do consentimento |
| Lado Hugo | `meta/policy/consent.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `consent` | #2 | registro | `000F` seção 0 inteira (curinga, Reference), `020F` seção 1 inteira (curinga, Reference), `040F` seção 2 inteira (curinga, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Registra o escopo e o fundamento do consentimento.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0010 LLLL      Codec 0x1E2L
[TAG de extensão de Length]
Payload           Reference ou texto que aponta para o fundamento do consentimento
```

- Codec: Meta `0x1E2L`, classe de política
- Payload: Reference ou Value embutido
- Quantidade: vários possíveis

## Problemas em aberto {#열린-문제}

- Estrutura da expressão do escopo (finalidade, prazo, fornecimento a terceiros).

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001E20/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E2000000000
BODY
#1 DECLARE 0x1E20
#2 FIELD #1 record
#3 BIND #1 "CONSENT"
#4 BIND #2 "consent"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
