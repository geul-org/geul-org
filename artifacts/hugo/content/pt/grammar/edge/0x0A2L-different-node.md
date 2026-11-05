---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE é um Edge de enunciado de não identidade que declara que duas References apontam para referentes diferentes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `DIFFERENT-NODE` (BIND `DIFFERENT-NODE` do documento de especificação) |
| TAG ID | `0x0A2L` |
| Codec ID | `0x00000A20` |
| Documento de especificação | `0x00000000/codecs/0x00000A20/` (alvo do DECLARE `0A20`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 2 |
| Kind | Edge · família: enunciado, grupo: apontamento e nome |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | não identidade em que duas References apontam para referentes diferentes |
| Lado Hugo | `edge/different-node.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | qualquer registro (exceto marcador de posição) |  |
| 2 | `object` | #3 | registro | qualquer registro (exceto marcador de posição) |  |

DIFFERENT-NODE é um Edge de enunciado de não identidade que declara que duas References apontam para referentes diferentes. Codec `0x0A2L`.

Não significa que a codificação em bytes, o Codec ou o ID dos dois registros Reference sejam diferentes. Distingue-se do binding direcional de [REFERENCE-NODE](0x0A0L-reference-node.md) e da identidade de [SAME-NODE](0x0A1L-same-node.md).

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0010 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference
```

## Interpretação e validade {#해석과-유효성}

- Subject e Object devem ser, cada um, exatamente um registro [Reference](../reference/_index.md) completo. A fronteira é encontrada pelo Length de cada registro; se for Value ou Edge, ou estiver incompleto, é invalid.
- Subject e Object apontam para referentes diferentes. Não se infere que os referentes são diferentes apenas pela diferença na sequência de bytes, no Codec ou no ID dos registros Reference.
- Em particular, [LOCAL](../reference/0x005L-local.md) IDs diferentes são apenas References diferentes, e não significam que os referentes na realidade sejam diferentes. Não se deriva DIFFERENT apenas da diferença de LOCAL ID.
- A não identidade é simétrica, irreflexiva e não transitiva. `DIFFERENT(A, B)` é a mesma relação que `DIFFERENT(B, A)`. Porém, de `DIFFERENT(A, B)` e `DIFFERENT(B, C)` não se infere `DIFFERENT(A, C)`.
- A ordem Subject/Object no wire é apenas a ordem de serialização para framing e não cria direção de significado. A implementação deve poder percorrer a relação nos dois sentidos.
- O cursor, depois de ler os dois componentes, deve coincidir exatamente com o fim do Edge.

Embora a própria relação seja irreflexiva, uma afirmação `DIFFERENT(A, A)` estruturalmente válida, ou uma afirmação em que SAME e DIFFERENT colidem, não deve ser eliminada como erro de gramática do wire. Tais afirmações preservam o contexto e a linhagem e são tratadas como contradição na camada de julgamento. Ao interpretar ou derivar DIFFERENT, preservam-se a origem, o instante, o world e o policy scope do documento que contém esse Edge, e não se amplia para uma conclusão global que os ignore.

## Comprimento {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORDs
```

## Exemplo (não normativo) {#예시-비규범}

O Edge Id é `000A`, Subject é LOCAL 1 e Object é LOCAL 2.

- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORDs, `LLLL=0110`. A TAG é `0000 1010 0010 0110` = `0A26`.

```
0A26 0051 000A 0051 0001 0051 0002
```

A diferença de LOCAL ID neste exemplo serve apenas para mostrar a codificação. Esta sequência só se torna DIFFERENT-NODE quando existe, à parte, a afirmação de que o ID 1 e o ID 2 apontam para referentes diferentes.

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000A20/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
