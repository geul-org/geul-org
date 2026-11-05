---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Registra o nível de divulgação do documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `ACCESS` (BIND `ACCESS` do documento de especificação) |
| TAG ID | `0x1DFL` |
| Codec ID | `0x00001DF0` |
| Documento de especificação | `0x00000000/codecs/0x00001DF0/` (alvo do DECLARE `1DF0`) |
| Seção | 14 `1110` (Meta), deslocamento C = 31 na seção |
| Kind | Meta · classe: política |
| TAG WORD | `0001 1101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Nível de divulgação |
| Lado Hugo | `meta/policy/access.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | valor bruto 1 WORD |  | `0x0000` public, `0x0001` internal, `0x0002` confidential |

Registra o nível de divulgação do documento.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[TAG de extensão de Length]
Nível             1 WORD (0 público, 1 interno, 2 confidencial, demais Reserved)
```

- Codec: Meta `0x1DFL`, classe de política
- Payload: valor bruto (nível, 1 WORD)
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Documentos confidenciais não são publicados ([Issuer](../issuer.md)).
- Não altera a interpretação. Define apenas o tratamento.

## Problemas em aberto {#열린-문제}

- Tabela de códigos de nível.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001DF0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
