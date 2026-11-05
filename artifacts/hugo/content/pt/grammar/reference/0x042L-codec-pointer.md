---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER é a Reference de indicação e declaração que aponta uma versão de um documento de codec publicado por um Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER é a Reference de indicação e declaração que aponta uma versão de um documento de codec publicado por um Issuer. O documento de codec não tem ID de documento; ele aponta a si mesmo e à sua versão por CODEC-POINTER.

| Item | Valor |
|---|---|
| Nome | `CODEC-POINTER` (BIND `CODEC-POINTER` do documento de especificação) |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| Documento de especificação | `0x00000000/codecs/0x00000420/` (alvo do DECLARE `0420`) |
| Seção | 2 `0010` (Reference diversas), deslocamento C na seção = 2 |
| Kind | Reference · classificação: indicação e declaração |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Uma versão de um codec de Issuer. Issuer + Codec ID de 2 WORD + ID de versão de 2 WORD, sem ID de alvo |
| Lado Hugo | `reference/codec-pointer.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor bruto restante (`0xFFFF`) |  |  |
| 2 | `codec` | #3 | valor bruto de 2 WORD |  |  |
| 3 | `version` | #4 | valor bruto de 2 WORD |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[TAG estendida de Length]
Issuer            2/4/16 WORD
Codec ID          2 WORD
ID da versão      2 WORD
```

## Interpretação e validade {#해석과-유효성}

- A largura do Issuer é o que resta do Payload depois de subtrair 4 WORD do Codec ID e do ID da versão. O Payload tem 6, 8 ou 20 WORD; qualquer outro comprimento é invalid. É invalid se o valor do Issuer couber numa largura mais estreita (forma canônica do Issuer).
- Se o Issuer tiver 16 WORD, o total é de 21 WORD, e é anexado 1 WORD de TAG estendida de Length.
- O Codec ID tem 32 bits. O Codec ID de um código direto de GEUL é o valor do seu TAG WORD (L=0) escrito em 32 bits (TRIPLE `0x0AAL` → `0x00000AA0`). O Codec ID de um codec de Issuer é o número de Codec do registro, e o Issuer o define sem repetição dentro do seu `codecs/`, independentemente do Kind ([endereço de publicação e lista de versões](../publishing.md#id-표기)).
- O ID de versão `0` é a versão mais recente. Os demais valores ficam fixados nessa versão.
- É uma única posição do Codec `0x042L`. Não há quantificação (Identified). Por ser a seção 2, não se lê como quantificação nem como sistema.
- Onde se usa: Meta [DOC-ID](../meta/0x1C7L-doc-id.md) do documento de codec; [PUBLICATION](../edge/0x0B8L-publication.md), DEPRECATION e TOMBSTONE da lista de versões do codec; [IMPORT-DOC](../meta/0x1E4L-import-doc.md) que importa um documento de codec. Nessas posições substitui o DOC-POINTER.
- O endereço de publicação é `/.well-known/geul/<Issuer>/codecs/<Codec ID>/<ID da versão>.geul` ([endereço de publicação e lista de versões](../publishing.md#공표-주소)).

## Exemplo {#예시}

Codec TRIPLE do Issuer GEUL `0x00000000` (Codec ID `0x00000AA0`).

| Versão | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| mais recente (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + Codec ID 2 + ID da versão 2 = 7 WORD, `LLLL=0110`. O TAG é `0000 0100 0010 0110` = `0426`.

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [Documento de especificação de Codec](../codec-spec.md)
- [endereço de publicação e lista de versões](../publishing.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x00000420/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
