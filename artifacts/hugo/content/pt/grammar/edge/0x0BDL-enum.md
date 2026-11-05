---
title: "ENUM (0x0BDL)"
weight: 189
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM é o Edge de enunciado que atribui um significado a um valor de código de um campo de valor bruto."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `ENUM` (BIND `ENUM` do documento de especificação) |
| TAG ID | `0x0BDL` |
| Codec ID | `0x00000BD0` |
| Documento de especificação | `0x00000000/codecs/0x00000BD0/` (alvo do DECLARE `0BD0`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 29 |
| Kind | Edge · família: enunciado, grupo: outros |
| TAG WORD | `0000 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Um valor de código de um campo de valor bruto. Campo, valor de código |
| Lado Hugo | `edge/enum.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | registro | `0050` LOCAL |  |
| 2 | `code` | #3 | valor bruto restante (`0xFFFF`) |  |  |

ENUM é o Edge de enunciado que atribui um significado a um valor de código de um campo de valor bruto. Codec `0x0BDL`.

Junto com [FIELD](0x0BCL-field.md), é o vocabulário para escrever especificações de Codec. O layout é embutido no decodificador ([documento de especificação de Codec](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1101 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
campo             registro Reference LOCAL que aponta para o Edge FIELD
valor de código   valor bruto. Mesmo número de WORDs que a largura desse FIELD
```

## Interpretação e validade {#해석과-유효성}

- O campo deve ser um FIELD de valor bruto (largura `n ≥ 1`). Não se anexa ENUM a um campo de registro. O significado de um registro é dito pelo Codec desse registro.
- O valor de código tem exatamente a largura desse FIELD. A fronteira é verificada pelo Length do registro ENUM.
- Em um campo, o mesmo valor de código não é declarado duas vezes.
- O nome do valor de código liga-se ao Edge Id do ENUM por [BIND](0x0A3L-bind.md). Todo UTF8-TEXT anexado a DECLARE, FIELD, ENUM e CODEC é feito por BIND, e não se anexa por outros Edges como LABEL.
- Um valor de código não declarado não é erro. O visualizador mostra o valor bruto tal como está. Fechar ou não os valores permitidos cabe à especificação do Codec, e o vocabulário atual não tem marca de fechamento.

## Comprimento {#길이}

```
total = 1 + N_len + N_id + N_field + n WORDs
```

## Exemplo (não normativo) {#예시-비규범}

Declara-se o código `0x0001` no campo de categoria do motivo (FIELD #4, valor bruto de 1 WORD) da especificação de TOMBSTONE. Edge Id 10. O nome é ligado à parte por BIND. Como a tabela de códigos da categoria do motivo ainda não foi definida, o valor de código é um exemplo.

- TAG 1 + Edge Id 2 + campo 2 + valor de código 1 = 6 WORDs, `LLLL = 0101`.

```
0BD5 0051 000A 0051 0004 0001
```

A especificação de TRIPLE põe no campo Rank (FIELD #5) três ENUMs (`0`·`1`·`2`) e liga-os por BIND a `normal`·`preferred`·`deprecated` ([TRIPLE](0x0AAL-triple.md)).

## Páginas relacionadas {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [FIELD](0x0BCL-field.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [documento de especificação de Codec](../codec-spec.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000BD0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BD000000000
BODY
#1 DECLARE 0x0BD0
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "ENUM"
#5 BIND #2 "field"
#6 BIND #3 "code"
#7 CODEC #2 0x0050
```
