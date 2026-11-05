---
title: "DOC-4WORD (0x1C2L)"
weight: 450
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD e DOC-4WORD são Meta de estrutura que abrem o documento indicando o número total de WORDs do documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD, DOC-2WORD e DOC-4WORD são Meta de estrutura que abrem o documento indicando o número total de WORDs do documento.

| Item | Valor |
|---|---|
| Nome | `DOC-4WORD` (BIND `DOC-4WORD` do documento de especificação) |
| TAG ID | `0x1C2L` |
| Codec ID | `0x00001C20` |
| Documento de especificação | `0x00000000/codecs/0x00001C20/` (alvo do DECLARE `1C20`) |
| Seção | 14 `1110` (Meta), deslocamento C = 2 na seção |
| Kind | Meta · classe: estrutura |
| TAG WORD | `0001 1100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Início de documento com o comprimento total indicado em 4 WORDs do Payload |
| Lado Hugo | `meta/structure/doc.md` (essa página trata também de [DOC-1WORD](0x1C0L-doc-1word.md) e [DOC-2WORD](0x1C1L-doc-2word.md)) |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | valor bruto 4 WORD | | |

Registro que abre o documento. Indica no Payload o número total de WORDs do documento. Esta página trata em conjunto de `DOC-1WORD` (`0x1C0L`), `DOC-2WORD` (`0x1C1L`) e `DOC-4WORD` (`0x1C2L`).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[TAG de extensão de Length]
Payload           Número total de WORDs. O Codec define a largura: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x1C0L~0x1C2L`, classe de estrutura
- Payload: valor bruto (número total de WORDs do documento, sem sinal)
- Quantidade: um por documento, no início

## Interpretação e validade {#해석과-유효성}

- O comprimento vai do início do registro de abertura até o fim de [END](0x1C4L-end.md).
- Usa-se a menor largura em que o valor cabe. Codificar com uma largura maior é rejeitado como codificação não canônica.
- O comprimento deve ser igual ao da entrada inteira. Um documento é uma entrada.
- O decodificador pode saltar o documento inteiro usando esse comprimento. Não existe Codec que abra sem conhecer o comprimento.
- Ao calcular o hash de conteúdo, reescreve-se com o comprimento sem os Meta da classe de verificação e a largura correspondente ([hash de conteúdo](../document.md#내용-해시)).

## Exemplo {#예시}

- `0x1C01 0x0017`: DOC-1WORD, 23 WORDs no total

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001C20/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C2000000000
BODY
#1 DECLARE 0x1C20
#2 FIELD #1 0x0004
#3 BIND #1 "DOC-4WORD"
#4 BIND #2 "count"
```
