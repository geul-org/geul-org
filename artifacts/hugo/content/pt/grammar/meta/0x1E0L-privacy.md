---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Registra o nível de dados pessoais do documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `PRIVACY` (BIND `PRIVACY` do documento de especificação) |
| TAG ID | `0x1E0L` |
| Codec ID | `0x00001E00` |
| Documento de especificação | `0x00000000/codecs/0x00001E00/` (alvo do DECLARE `1E00`) |
| Seção | 15 `1111` (Meta), deslocamento C = 0 na seção |
| Kind | Meta · classe: política |
| TAG WORD | `0001 1110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Nível de dados pessoais |
| Lado Hugo | `meta/policy/privacy.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | valor bruto 1 WORD |  |  |

Registra o nível de dados pessoais do documento.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[TAG de extensão de Length]
Nível             1 WORD
```

- Codec: Meta `0x1E0L`, classe de política
- Payload: valor bruto (nível, 1 WORD)
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Não altera a interpretação. Define apenas o tratamento.

## Problemas em aberto {#열린-문제}

- Tabela de códigos de nível (correspondência com a classificação da lei de proteção de dados pessoais).

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001E00/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
