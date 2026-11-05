---
title: "ISSUER-KEY (0x1E5L)"
weight: 485
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Declara a chave pública de um Issuer autoemitido (16 WORDs)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `ISSUER-KEY` (BIND `ISSUER-KEY` do documento de especificação) |
| TAG ID | `0x1E5L` |
| Codec ID | `0x00001E50` |
| Documento de especificação | `0x00000000/codecs/0x00001E50/` (alvo do DECLARE `1E50`) |
| Seção | 15 `1111` (Meta), deslocamento C = 5 na seção |
| Kind | Meta · classe: verificação |
| TAG WORD | `0001 1110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Declaração do ID do algoritmo de assinatura e da chave pública de um Issuer autoemitido |
| Lado Hugo | `meta/verification/issuer-key.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | valor bruto 1 WORD |  | `0x0001` ed25519 |
| 2 | `key` | #3 | valor bruto restante(`0xFFFF`) |  |  |

Declara a chave pública de um Issuer autoemitido (16 WORDs). Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID do algoritmo ‖ chave pública) ([Issuer de 16 WORDs](../issuer.md#16-word-issuer)).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0101 LLLL      Codec 0x1E5L
[TAG de extensão de Length]
ID do algoritmo   1 WORD (0x0001 = Ed25519)
Chave pública     Largura definida pelo algoritmo (Ed25519 16 WORDs)
```

- Codec: Meta `0x1E5L`, classe de verificação
- Payload: valor bruto (ID do algoritmo + chave pública)
- Quantidade: vários possíveis (troca de chave)

## Interpretação e validade {#해석과-유효성}

- Por ser da classe de verificação, fica de fora do hash de conteúdo.
- Issuers de 2 e 4 WORDs usam a chave registrada em geul.org, portanto não é necessário.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001E50/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E5000000000
BODY
#1 DECLARE 0x1E50
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 ENUM #2 0x0001
#5 BIND #1 "ISSUER-KEY"
#6 BIND #2 "algorithm"
#7 BIND #3 "key"
#8 BIND #4 "ed25519"
```
