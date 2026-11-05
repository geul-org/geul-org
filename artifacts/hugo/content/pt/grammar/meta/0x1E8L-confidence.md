---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Registra o grau de confiança do documento inteiro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `CONFIDENCE` (BIND `CONFIDENCE` do documento de especificação) |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| Documento de especificação | `0x00000000/codecs/0x00001E80/` (alvo do DECLARE `1E80`) |
| Seção | 15 `1111` (Meta), deslocamento C = 8 na seção |
| Kind | Meta · classe: verificação |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Grau de confiança |
| Lado Hugo | `meta/verification/confidence.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | registro | `0690` UNSIGNED-DECIMAL |  |

Registra o grau de confiança do documento inteiro. O grau de confiança por registro é escrito com um QUALIFIER anexado ao Edge de destino (a propriedade ainda não está definida, [SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[TAG de extensão de Length]
Payload           Value UNSIGNED-DECIMAL, de 0 a 1
```

- Codec: Meta `0x1E8L`, classe de verificação
- Payload: Value embutido ([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Quem atribuiu o valor é registrado junto, por exemplo com [GENERATED-BY](0x1D3L-generated-by.md).

## Problemas em aberto {#열린-문제}

- A escala (0 a 1) e sua relação com o julgamento do TOULMIN.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001E80/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
