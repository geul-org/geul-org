---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara a edição da especificação GEUL que o documento segue."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `SPEC-VERSION` (BIND `SPEC-VERSION` do documento de especificação) |
| TAG ID | `0x1C5L` |
| Codec ID | `0x00001C50` |
| Documento de especificação | `0x00000000/codecs/0x00001C50/` (alvo do DECLARE `1C50`) |
| Seção | 14 `1110` (Meta), deslocamento C = 5 na seção |
| Kind | Meta · classe: definição |
| TAG WORD | `0001 1100 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Edição da especificação GEUL seguida. O Payload é o próprio inteiro sem sinal na menor largura. v1 é `0x0001` (registro `0x1C51 0x0001`) |
| Lado Hugo | `meta/declaration/spec-version.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | valor bruto restante (`0xFFFF`) | | |

Declara a edição da especificação GEUL que o documento segue. Este valor determina como ler os demais registros.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[TAG de extensão de Length]
Payload           Edição da especificação. v1 = 0x0001
```

- Codec: Meta `0x1C5L`, classe de definição
- Payload: valor bruto (inteiro sem sinal na menor largura)
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Não depende de códigos de Value. Para que o decodificador de qualquer edição possa lê-lo, usa-se apenas um inteiro, sem Value embutido.
- Se a edição for desconhecida, o decodificador rejeita ou emite um aviso.
- Se ausente, o decodificador lê com a edição que conhece. Documentos publicados o registram.

## Exemplo {#예시}

- `0x1C51 0x0001`: GEUL v1

## Problemas em aberto {#열린-문제}

- Correspondência com a versão do documento do livro de Codecs ([documento de especificação](../codec-spec.md)).

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001C50/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
