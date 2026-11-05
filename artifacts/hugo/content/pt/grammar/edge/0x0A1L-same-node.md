---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE é um Edge de enunciado de identidade, sem direção, que declara que duas References apontam para o mesmo referente."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `SAME-NODE` (BIND `SAME-NODE` do documento de especificação) |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| Documento de especificação | `0x00000000/codecs/0x00000A10/` (alvo do DECLARE `0A10`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 1 |
| Kind | Edge · família: enunciado, grupo: apontamento e nome |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | identidade em que duas References apontam para o mesmo referente |
| Lado Hugo | `edge/same-node.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | qualquer registro (exceto marcador de posição) |  |
| 2 | `object` | #3 | registro | qualquer registro (exceto marcador de posição) |  |

SAME-NODE é um Edge de enunciado de identidade, sem direção, que declara que duas References apontam para o mesmo referente. Codec `0x0A1L`.

Não significa que a codificação em bytes, o Codec ou o ID dos dois registros Reference sejam iguais. Ao contrário de [REFERENCE-NODE](0x0A0L-reference-node.md), que é um binding direcional `Reference → registro`, SAME-NODE expressa a identidade (referential identity) entre duas References.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference
```

## Interpretação e validade {#해석과-유효성}

- Subject e Object são serializados nesta ordem, e cada um deve ser exatamente um registro [Reference](../reference/_index.md) completo. A fronteira é encontrada pelo Length de cada registro.
- Se Subject ou Object for Value, Edge ou um registro incompleto, é invalid.
- A relação SAME-NODE é reflexiva, simétrica e transitiva. A ordem Subject/Object no wire serve ao framing e não cria direção de significado. A implementação deve poder percorrer essa relação nos dois sentidos.
- [LOCAL](../reference/0x005L-local.md) IDs diferentes são apenas References diferentes, e não são prova de que os referentes sejam iguais ou diferentes. Que duas References apontam para o mesmo referente é estabelecido por SAME-NODE.
- A interpretação e a inferência devem preservar a origem, o instante, o world e o policy scope do documento que contém esse Edge e do grafo de julgamento. SAME-NODE não é usado como base de uma fusão global independente do contexto.
- Mesmo havendo SAME-NODE, não se apagam nem se sobrescrevem os registros Reference originais nem a linhagem.
- Mesmo que SAME-NODE e [DIFFERENT-NODE](0x0A2L-different-node.md) coexistam para o mesmo par, o wire não é invalid. O contexto de cada afirmação é preservado e avaliado como conflito.
- Uma Reference Variable é ligada a uma Reference Identified por SAME-NODE para resolver a variável ([Reference](../reference/_index.md) Variable).

## Comprimento {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORDs
```

## Exemplo (não normativo) {#예시-비규범}

O Edge Id é `0009`, Subject é LOCAL 1 e Object é LOCAL 2.

- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORDs, `LLLL=0110`. A TAG é `0000 1010 0001 0110` = `0A16`.

```
0A16 0051 0009 0051 0001 0051 0002
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000A10/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
