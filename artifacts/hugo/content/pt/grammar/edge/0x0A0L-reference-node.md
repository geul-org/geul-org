---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE é um Edge de enunciado direcional que liga uma Reference a um registro Object, definindo ou vinculando o que essa Reference é."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `REFERENCE-NODE` (BIND `REFERENCE-NODE` do documento de especificação) |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| Documento de especificação | `0x00000000/codecs/0x00000A00/` (alvo do DECLARE `0A00`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 0 |
| Kind | Edge · família: enunciado, grupo: apontamento e nome |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | binding direcional em que Subject, uma Reference, aponta para Object |
| Lado Hugo | `edge/reference-node.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | qualquer registro (exceto marcador de posição) |  |
| 2 | `object` | #3 | registro | `000F` seção 0 inteira (curinga, Reference), `020F` seção 1 inteira (curinga, Reference), `040F` seção 2 inteira (curinga, Reference), `060F` seção 3 inteira (curinga, Value), `080F` seção 4 inteira (curinga, Value) |  |

REFERENCE-NODE é um Edge de enunciado direcional que liga uma Reference a um registro Object, definindo ou vinculando o que essa Reference é. Codec `0x0A0L`.

Subject aponta para Object. Esse binding não é o [SAME-NODE](0x0A1L-same-node.md), que afirma identidade semântica, nem significa que os bytes dos dois registros sejam iguais.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference ou Value
```

## Interpretação e validade {#해석과-유효성}

- Subject deve ser exatamente um registro [Reference](../reference/_index.md) completo. A fronteira é encontrada pelo Length do próprio Subject; se não for Reference ou estiver incompleto, é invalid.
- Object deve ser exatamente um registro Reference ou Value completo. A fronteira é encontrada pelo Length do próprio Object; se for Edge ou Meta, ou estiver incompleto, é invalid.
- Se Object for uma Reference, a cadeia de References seguida pelo binding REFERENCE-NODE não deve ser circular, e o LOCAL deve ser resolvido até o fim. Ciclo de resolução e LOCAL dangling são invalid.
- Se, em um mesmo documento, um LOCAL ID for vinculado a Objects conflitantes, é invalid. O âmbito do LOCAL, o ID, a largura mínima e as regras de mesclagem seguem [LOCAL](../reference/0x005L-local.md).
- Nem toda Reference precisa ser vinculada por REFERENCE-NODE.
- O uso representativo é `LOCAL → UTF8-LANGUAGE-TEXT`. Quando se põe um LOCAL no Object de [LABEL](0x0A4L-label.md), o texto é resolvido por este binding do mesmo documento.

A direção em que Subject aponta para Object não deve ser interpretada ao contrário. O significado e as regras detalhadas de SAME e DIFFERENT são definidos separadamente por cada formato.

## Comprimento {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORDs
```

`N_len` é o número de WORDs da TAG estendida de Length, `N_id` é o número de WORDs do registro LOCAL do Edge Id, e `N_subject` e `N_object` são o número total de WORDs de cada registro. O cursor, depois de ler Subject e Object, deve coincidir exatamente com o fim do Edge.

## Exemplo (não normativo) {#예시-비규범}

O Edge Id é `0008`, Subject é LOCAL 1, e Object é um [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) com `Donald Trump` (en).

- O Edge Id é `0051 0008`, 2 WORDs.
- Subject é `0051 0001`, 2 WORDs.
- Object é o idioma `0761 656E` (BCP47 `en`) + texto de 12 bytes (par), portanto `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), 9 WORDs no total. A TAG é `0788`.
- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORDs, `LLLL=1101`. A TAG é `0A0D`.

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000A00/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
