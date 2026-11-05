---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER é a Reference de indicação e declaração que aponta o próprio Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `ISSUER-POINTER` (BIND `ISSUER-POINTER` do documento de especificação) |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| Documento de especificação | `0x00000000/codecs/0x00000400/` (alvo do DECLARE `0400`) |
| Seção | 2 `0010` (Reference diversas), deslocamento C na seção = 0 |
| Kind | Reference · classificação: indicação e declaração |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Lado Hugo | `reference/issuer-pointer.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor bruto restante (`0xFFFF`) |  |  |

ISSUER-POINTER é a Reference de indicação e declaração que aponta o próprio Issuer. Torna-se alvo de `BIND` do nome do Issuer, de `LABEL` e de Edge de julgamento.

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[TAG estendida de Length]
Issuer            2/4/16 WORD
```

- A largura do Issuer é todo o Payload. O Codec não divide a largura. É invalid se a largura não for 2, 4 ou 16 WORD, ou se o valor do Issuer couber numa largura mais estreita (forma canônica do Issuer).
- Se o Issuer tiver 16 WORD, o total é de 17 WORD, e é anexado 1 WORD de TAG estendida de Length.
- É uma única posição do Codec `0x040L`. Não há quantificação (Identified).
- O valor do Issuer segue a atribuição de [Issuer](../issuer.md).
- Usos: Subject do BIND em `issuers/`, a lista de Issuer ([endereço de publicação e lista de versões](../publishing.md#issuer-목록)); LABEL do nome de exibição do Issuer; julgamentos sobre o Issuer; signatários, e outras posições em que o próprio Issuer é o alvo.
- A forma de apontar o próprio Issuer é apenas ISSUER-POINTER. É invalid apontar um Issuer com `EXTERNAL-ISSUER-*` usando ID de documento `0` e ID de alvo `0`.

## Exemplo {#예시}

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [Issuer e publicação](../issuer.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x00000400/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
