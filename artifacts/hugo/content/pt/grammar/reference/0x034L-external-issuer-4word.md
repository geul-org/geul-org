---
title: "EXTERNAL-ISSUER-4WORD (0x034L~0x038L)"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER é a Reference de indicação e declaração que cita, num único registro e sem IMPORT, o LOCAL ID de um documento publicado por um Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER é a Reference de indicação e declaração que cita, num único registro e sem IMPORT, o LOCAL ID de um documento publicado por um Issuer.

| Item | Valor |
|---|---|
| Nome | `EXTERNAL-ISSUER-4WORD` (grupo 5Q. Os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x034L~0x038L` |
| Seção | 1 `0001` (Reference EXTERNAL), deslocamento C na seção = 20~24 |
| Kind | Reference · classificação: indicação e declaração |
| Lado Hugo | `reference/external-issuer.md` (essa página trata também de [EXTERNAL-ISSUER-2WORD](0x02FL-external-issuer-2word.md) e [EXTERNAL-ISSUER-16WORD](0x039L-external-issuer-16word.md)) |

## Membros {#구성원}

Esta página trata de um conjunto do sistema 5Q, cinco códigos. A quantificação é o deslocamento na seção `C % 5` ([Reference](_index.md#quantifier)). Há um documento de codec por código. Os campos dos cinco documentos de codec são iguais; só diferem o alvo do DECLARE e o nome (BIND).

| TAG ID | Nome | Quantificação | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x034L` | `EXTERNAL-ISSUER-4WORD-IDENTIFIED` | Identified | `0x00000340` | `0x00000000/codecs/0x00000340/` | `0000 0011 0100 LLLL` |
| `0x035L` | `EXTERNAL-ISSUER-4WORD-GENERIC` | Generic | `0x00000350` | `0x00000000/codecs/0x00000350/` | `0000 0011 0101 LLLL` |
| `0x036L` | `EXTERNAL-ISSUER-4WORD-FREE-CHOICE` | Free-choice | `0x00000360` | `0x00000000/codecs/0x00000360/` | `0000 0011 0110 LLLL` |
| `0x037L` | `EXTERNAL-ISSUER-4WORD-UNIVERSAL` | Universal | `0x00000370` | `0x00000000/codecs/0x00000370/` | `0000 0011 0111 LLLL` |
| `0x038L` | `EXTERNAL-ISSUER-4WORD-VARIABLE` | Variable | `0x00000380` | `0x00000000/codecs/0x00000380/` | `0000 0011 1000 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor bruto de 4 WORD |  |  |
| 2 | `doc` | #3 | valor bruto de 4 WORD |  |  |
| 3 | `target-id` | #4 | valor bruto restante (`0xFFFF`) |  |  |

EXTERNAL-ISSUER é a Reference de indicação e declaração que cita, sem IMPORT, o LOCAL ID de um documento publicado por um Issuer. Um único registro completa o sentido e segue a versão mais recente.

## Layout {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (seção 1)
[TAG estendida de Length]
Issuer            largura definida pelo Codec (2/4/16 WORD)
ID do documento   4 WORD
ID do alvo        todo o restante. LOCAL ID desse documento, na menor largura
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Nome | Largura do Issuer |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (registrado em geul.org, domínio comprovado) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (registrado em geul.org, sem comprovação) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (calculado a partir da chave pública) |

- A largura é determinada pelo número do sistema: se sistema − 9 (`C / 5 − 3` do deslocamento `C` na seção) for 0, 1, 2, a largura é 2, 4, 16 WORD. A quantificação é `C % 5`.
- O Issuer ID é um valor inteiro. Valor igual é o mesmo Issuer. O Issuer é escrito na menor largura em que o valor cabe, e escolhe-se o Codec dessa largura (4 WORD somente a partir de `2^32`, 16 WORD somente a partir de `2^64`). Uma notação de largura maior é invalid ([Issuer](../issuer.md)).
- O registro e a gestão de Issuer ficam a cargo de geul.org.
- A versão não é registrada; segue-se a mais recente. Para fixar a versão, usam-se [IMPORT-DOC](../meta/0x1E4L-import-doc.md) e [EXTERNAL-POINTER](0x020L-external-pointer-1word.md).
- A localização se encontra pela regra de endereço de publicação ([endereço de publicação e lista de versões](../publishing.md)).
- Se o LOCAL ID desse documento é o mesmo, é o mesmo alvo, tanto se usado como LOCAL dentro desse documento quanto como EXTERNAL-ISSUER em outro documento (ou como EXTERNAL-POINTER após IMPORT).
- Aponta apenas LOCAL do documento. O próprio documento é apontado por [DOC-POINTER](0x041L-doc-pointer.md) e o próprio Issuer por [ISSUER-POINTER](0x040L-issuer-pointer.md). Por isso o ID do alvo não é `0`. O ID de documento `0` é o documento de índice das definições de termos do Issuer.

## Validade {#유효성}

- É invalid se a largura do Issuer não corresponde ao Codec, ou se o valor cabe numa largura mais estreita.
- É invalid se o ID do alvo for `0`. O ID de alvo `0` (o próprio documento) fica a cargo do DOC-POINTER.
- WORD `0x0000` à frente no ID do alvo é proibido.

## Exemplo {#예시}

| Alvo | WORD sequence |
|---|---|
| Issuer `0x00000002`, documento `0x…0002`, LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, documento `0x…0002`, LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer e publicação](../issuer.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x00000340/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000034000000000
BODY
#1 DECLARE 0x0340
#2 FIELD #1 0x0004
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-4WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

Acima está o documento de codec de `EXTERNAL-ISSUER-4WORD-IDENTIFIED` (`0x034L`). Os documentos de codec dos outros membros (`EXTERNAL-ISSUER-4WORD-GENERIC`, `EXTERNAL-ISSUER-4WORD-FREE-CHOICE`, `EXTERNAL-ISSUER-4WORD-UNIVERSAL`, `EXTERNAL-ISSUER-4WORD-VARIABLE`) diferem apenas no Codec ID do DOC-ID, no alvo do DECLARE e no nome ligado em `#1` (BIND).
