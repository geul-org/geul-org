---
title: "FIELD (0x0BCL)"
weight: 188
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD é o Edge de enunciado que declara um campo do Payload de um Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `FIELD` (BIND `FIELD` do documento de especificação) |
| TAG ID | `0x0BCL` |
| Codec ID | `0x00000BC0` |
| Documento de especificação | `0x00000000/codecs/0x00000BC0/` (alvo do DECLARE `0BC0`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 28 |
| Kind | Edge · família: enunciado, grupo: outros |
| TAG WORD | `0000 1011 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Um campo do Payload. O DECLARE a que pertence, largura: registro (Length da TAG) ou valor bruto de n WORDs |
| Lado Hugo | `edge/field.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `declare` | #2 | registro | `0050` LOCAL |  |
| 2 | `width` | #3 | valor bruto 1 WORD |  | `0x0000` record, `0xFFFF` rest |

FIELD é o Edge de enunciado que declara um campo do Payload de um Codec. Codec `0x0BCL`.

O FIELD aponta para o seu próprio [DECLARE](0x0BBL-declare.md). Os FIELDs que apontam para um mesmo DECLARE compõem o Payload na ordem do documento. O layout é embutido no decodificador ([documento de especificação de Codec](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1100 LLLL
Edge Id           registro Reference LOCAL
DECLARE           registro Reference LOCAL. O Edge DECLARE a que este campo pertence
largura           1 WORD. 0 = registro, n (1~65534) = valor bruto de n WORDs, 0xFFFF = valor bruto restante
```

## Interpretação e validade {#해석과-유효성}

- DECLARE aponta para um Edge DECLARE do mesmo documento. Um FIELD pertence a um único DECLARE. A ordem não é escrita à parte, e é a ordem em que os registros FIELD estão no documento.
- O documento de especificação de FIELD declara DECLARE como um campo de largura `0` (registro) e CODEC `0050` (LOCAL). Por isso, no grafo do visualizador, é desenhado como ligação FIELD → DECLARE.
- A largura `0` é um campo de registro. Começa com uma TAG WORD e lê tantos WORDs quanto o Length dessa TAG (regras de interpretação de [DECLARE](0x0BBL-declare.md)).
- A largura `n` (1~65534) é um campo de valor bruto. É sempre exatamente n WORDs.
- A largura `0xFFFF` é um valor bruto restante. Põe-se um só no DECLARE, e pode estar no início, no meio ou no fim. A largura é o que resta dos WORDs definidos pelo Length da TAG do registro exterior menos as larguras dos campos seguintes. Por isso, todos os campos depois do campo restante devem ser valores brutos de largura fixa (um registro só tem o seu fim conhecido se for lido desde o início). Pode ser 0 WORD. Não se anexa ENUM.
- O Kind e o Codec que o campo aceita são indicados com [CODEC](0x0BEL-codec.md). Um campo de registro sem CODEC aceita qualquer registro, e com CODEC deve ser um deles. Se um CODEC for posto em um campo de valor bruto, esse valor bruto é interpretado como esse Value sem a TAG.
- O nome do campo liga-se ao Edge Id do FIELD por [BIND](0x0A3L-bind.md) (por exemplo, `doc`, `hash`). Todo UTF8-TEXT anexado a DECLARE, FIELD, ENUM e CODEC é feito por BIND, e não se anexa por outros Edges como LABEL.
- O significado dos códigos de um campo de valor bruto é anexado por [ENUM](0x0BDL-enum.md).
- Um campo que aponta para outro nó no grafo não é marcado à parte. Se o campo de registro é uma Reference, essa é a ligação.

## Comprimento {#길이}

```
total = 1 + 2 + 2 + 1 WORDs   (quando Edge Id e DECLARE são IDs LOCAL de 1 WORD)
```

## Exemplo (não normativo) {#예시-비규범}

- Campo de registro: Edge Id 7, DECLARE #1, largura `0`. TAG 1 + Edge Id 2 + DECLARE 2 + largura 1 = 6 WORDs. Para aceitar apenas LOCAL, veja o exemplo de [CODEC](0x0BEL-codec.md).

```
0BC5 0051 0007 0051 0001 0000
```

- Para um campo de valor bruto como o hash de conteúdo, veja o exemplo de [DECLARE](0x0BBL-declare.md).

## Páginas relacionadas {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [documento de especificação de Codec](../codec-spec.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000BC0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BC000000000
BODY
#1 DECLARE 0x0BC0
#2 FIELD #1 record
#13 CODEC #2 0x0050
#3 FIELD #1 0x0001
#5 ENUM #3 0x0000
#6 ENUM #3 0xFFFF
#7 BIND #1 "FIELD"
#8 BIND #2 "declare"
#9 BIND #3 "width"
#11 BIND #5 "record"
#12 BIND #6 "rest"
```
