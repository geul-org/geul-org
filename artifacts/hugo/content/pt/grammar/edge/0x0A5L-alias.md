---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS é um Edge de enunciado que liga ao Object um outro nome (alias) do alvo Subject."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `ALIAS` (BIND `ALIAS` do documento de especificação) |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| Documento de especificação | `0x00000000/codecs/0x00000A50/` (alvo do DECLARE `0A50`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 5 |
| Kind | Edge · família: enunciado, grupo: apontamento e nome |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Liga outro nome (alias) de Subject. O layout é igual ao de LABEL |
| Lado Hugo | `edge/alias.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | qualquer registro (exceto marcador de posição) |  |
| 2 | `object` | #3 | registro | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

ALIAS é um Edge de enunciado que liga ao Object um outro nome (alias) do alvo Subject. Codec `0x0A5L`.

[LABEL](0x0A4L-label.md) é o nome representativo naquele idioma (no máximo um por idioma), e ALIAS é outro nome do mesmo alvo (vários por idioma, o "also known as" do Wikidata). Serve principalmente para busca. O layout e a validade são iguais aos de LABEL.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 Value UTF8-LANGUAGE-TEXT ou 1 registro Reference LOCAL
```

## Interpretação e validade {#해석과-유효성}

- As regras de Subject e Object são iguais às de [LABEL](0x0A4L-label.md) (Object é [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) ou um LOCAL que se resolve para ele).
- Pode haver vários ALIAS para o mesmo Subject e idioma. A ordem é a ordem no documento.
- Não se põe como ALIAS o mesmo texto do LABEL do mesmo Subject e idioma (basta um LABEL para o nome representativo). Esta regra é uma recomendação.
- O documento de especificação do geul.org restringe Object por [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, igual a LABEL).

## Exemplo (não normativo) {#예시-비규범}

Edge Id `0003`, Subject Q42 (`0141 002A`), Object `DNA` (en): idioma `0761 656E` (BCP47 `en`) + texto de 3 bytes (ímpar) → `UTF8-LANGUAGE-TEXT-ODD` (`0x079L`), `0794 0761 656E 444E 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORDs, `LLLL=1001`. A TAG é `0A59`.

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [DESCRIPTION](0x0A6L-description.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000A50/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
