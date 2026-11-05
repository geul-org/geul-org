---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Registra um nome imutável atribuído a uma versão (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `TAG` (BIND `TAG` do documento de especificação) |
| TAG ID | `0x1DAL` |
| Codec ID | `0x00001DA0` |
| Documento de especificação | `0x00000000/codecs/0x00001DA0/` (alvo do DECLARE `1DA0`) |
| Seção | 14 `1110` (Meta), deslocamento C = 26 na seção |
| Kind | Meta · classe: linhagem |
| TAG WORD | `0001 1101 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Nome imutável atribuído a uma versão. Value TEXT e hash de conteúdo (git annotated tag) |
| Lado Hugo | `meta/lineage/tag.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | registro | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | registro | `07C0` SHA-256-DIGEST, `0000` ABSENT (campo opcional) |  |

Registra um nome imutável atribuído a uma versão (git annotated tag).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[TAG de extensão de Length]
Nome              Value UTF8-TEXT-*
Alvo              Value SHA-256-DIGEST, ou marca de omissão 0x0000 (campo opcional). Se omitido, esta versão
```

- Codec: Meta `0x1DAL`, classe de linhagem
- Payload: Value embutido (texto + hash de conteúdo opcional)
- Quantidade: vários possíveis

## Interpretação e validade {#해석과-유효성}

- O nome é [UTF8-TEXT](../value/0x072L-utf8-text.md) e o alvo é [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md).
- Se o alvo for omitido (ABSENT `0x0000`, campo opcional de [CODEC](../edge/0x0BEL-codec.md)), é um nome atribuído ao próprio documento. O hash de conteúdo de um documento não pode ser escrito dentro dele mesmo. A especificação `0x1DA0` de geul.org tem dois campos de registro: name (`0720`, `0730`) e target (`07C0`, `0000`).
- O mesmo nome não é reutilizado em outra versão.

## Exemplo {#예시}

- Nome `v1`, esta versão: `1DA3 0721 7631 0000`

## Problemas em aberto {#열린-문제}

- Resta decidir se um TAG é necessário mesmo havendo ID de versão (número de ordem).

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001DA0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
