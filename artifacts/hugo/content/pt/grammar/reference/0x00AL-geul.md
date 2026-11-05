---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL é a Reference de declaração que aponta as entidades que geul.org emite sob CC0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `GEUL` (grupo 5Q. Os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x00AL~0x00EL` |
| Seção | 0 `0000` (entidade Reference), deslocamento C na seção = 10~14 |
| Kind | Reference · classificação: declaração |
| Lado Hugo | `reference/geul.md` |

## Membros {#구성원}

Esta página trata de um conjunto do sistema 5Q, cinco códigos. A quantificação é o deslocamento na seção `C % 5` ([Reference](_index.md#quantifier)). Há um documento de codec por código. Os campos dos cinco documentos de codec são iguais; só diferem o alvo do DECLARE e o nome (BIND).

| TAG ID | Nome | Quantificação | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | valor bruto restante (`0xFFFF`) |  |  |

GEUL é a Reference de declaração que aponta as entidades que geul.org emite sob CC0. É um ID serial cujo número não carrega significado. O identificador que carrega significado nos bits fica a cargo de outro Codec, [GEUL-SIDX](0x00FL-geul-sidx.md) (`0x00FL~0x013L`).

## Layout {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[TAG estendida de Length]
GEUL ID           unsigned big-endian na menor largura
```

- Números pequenos são atribuídos a entidades de alta frequência. Um ID que cabe em 1 WORD ocupa 2 WORD no total.
- A atribuição de IDs e o registro são geridos por geul.org. No registro entra apenas o que vem de fontes CC0.
- Se for Variable, é uma variável anônima desse tipo ([Reference](_index.md) Variable).

## Exemplo {#예시}

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## Problemas em aberto {#열린-문제}

- Regra de atribuição de GEUL ID e formato de publicação do registro.

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [GEUL-SIDX](0x00FL-geul-sidx.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x000000A0/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

Acima está o documento de codec de `GEUL-IDENTIFIED` (`0x00AL`). Os documentos de codec dos outros membros (`GEUL-GENERIC`, `GEUL-FREE-CHOICE`, `GEUL-UNIVERSAL`, `GEUL-VARIABLE`) diferem apenas no Codec ID do DOC-ID, no alvo do DECLARE e no nome ligado em `#1` (BIND).
