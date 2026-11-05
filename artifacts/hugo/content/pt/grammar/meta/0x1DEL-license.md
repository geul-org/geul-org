---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Registra a licença deste documento e das obras contidas na sequência de bytes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `LICENSE` (BIND `LICENSE` do documento de especificação) |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| Documento de especificação | `0x00000000/codecs/0x00001DE0/` (alvo do DECLARE `1DE0`) |
| Seção | 14 `1110` (Meta), deslocamento C = 30 na seção |
| Kind | Meta · classe: política |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Licença. Reference |
| Lado Hugo | `meta/policy/license.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | registro | `000F` seção 0 inteira (curinga, Reference), `020F` seção 1 inteira (curinga, Reference), `040F` seção 2 inteira (curinga, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

Registra a licença deste documento e das obras contidas na sequência de bytes.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[TAG de extensão de Length]
Payload           Reference que aponta para a licença, ou identificador SPDX em UTF8-TEXT, ou Value URI
```

- Codec: Meta `0x1DEL`, classe de política
- Payload: Reference ou Value embutido ([UTF8-TEXT](../value/0x072L-utf8-text.md), [URI](../value/0x074L-uri.md))
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Os documentos publicados em geul.org são CC0. Nas publicações privadas, quem decide é o Issuer ([Issuer](../issuer.md)).
- Registra-se a licença original da obra de origem.

## Problemas em aberto {#열린-문제}

- Resta decidir se o identificador SPDX será posto como texto ou como Reference de entidade GEUL.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001DE0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
