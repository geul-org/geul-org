---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Registra o motivo da alteração (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `MESSAGE` (BIND `MESSAGE` do documento de especificação) |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| Documento de especificação | `0x00000000/codecs/0x00001D90/` (alvo do DECLARE `1D90`) |
| Seção | 14 `1110` (Meta), deslocamento C = 25 na seção |
| Kind | Meta · classe: linhagem |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Motivo da alteração. Value UTF8-LANGUAGE-TEXT, um por idioma (git commit message) |
| Lado Hugo | `meta/lineage/message.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | registro | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Registra o motivo da alteração (git commit message).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[TAG de extensão de Length]
Mensagem          1 Value UTF8-LANGUAGE-TEXT
```

- Codec: Meta `0x1D9L`, classe de linhagem
- Payload: Value embutido ([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- Quantidade: no máximo um por idioma

## Interpretação e validade {#해석과-유효성}

- A mensagem e o idioma vão juntos em um UTF8-LANGUAGE-TEXT. Há um único MESSAGE por idioma.
- O documento de especificação de geul.org é escrito com [CODEC](../edge/0x0BEL-codec.md) `0780` e `0790`.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001D90/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
