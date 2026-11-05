---
title: "WIKIDATA-PID (0x019L~0x01DL)"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID é a Reference de declaração que aponta uma propriedade (Property) do Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `WIKIDATA-PID` (grupo 5Q. Os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x019L~0x01DL` |
| Seção | 0 `0000` (entidade Reference), deslocamento C na seção = 25~29 |
| Kind | Reference · classificação: declaração |
| Lado Hugo | `reference/wikidata-pid.md` |

## Membros {#구성원}

Esta página trata de um conjunto do sistema 5Q, cinco códigos. A quantificação é o deslocamento na seção `C % 5` ([Reference](_index.md#quantifier)). Há um documento de codec por código. Os campos dos cinco documentos de codec são iguais; só diferem o alvo do DECLARE e o nome (BIND).

| TAG ID | Nome | Quantificação | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x019L` | `WIKIDATA-PID-IDENTIFIED` | Identified | `0x00000190` | `0x00000000/codecs/0x00000190/` | `0000 0001 1001 LLLL` |
| `0x01AL` | `WIKIDATA-PID-GENERIC` | Generic | `0x000001A0` | `0x00000000/codecs/0x000001A0/` | `0000 0001 1010 LLLL` |
| `0x01BL` | `WIKIDATA-PID-FREE-CHOICE` | Free-choice | `0x000001B0` | `0x00000000/codecs/0x000001B0/` | `0000 0001 1011 LLLL` |
| `0x01CL` | `WIKIDATA-PID-UNIVERSAL` | Universal | `0x000001C0` | `0x00000000/codecs/0x000001C0/` | `0000 0001 1100 LLLL` |
| `0x01DL` | `WIKIDATA-PID-VARIABLE` | Variable | `0x000001D0` | `0x00000000/codecs/0x000001D0/` | `0000 0001 1101 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `pid` | #2 | valor bruto restante (`0xFFFF`) |  |  |

WIKIDATA-PID é a Reference de declaração que aponta uma propriedade (Property) do Wikidata. Escreve-se como inteiro sem sinal a parte numérica do P-ID, sem o `P`.

## Layout {#레이아웃}

```
TAG WORD          0000 0001 1001 LLLL      Codec 0x019L~0x01DL (Identified 0x019L)
[TAG estendida de Length]
PID               unsigned big-endian na menor largura
```

- O PID é escrito na menor largura. Os números de propriedade atuais cabem em 1 WORD e ocupam 2 WORD no total; ao passar de 65535, crescem naturalmente para 3 WORD.
- Usa-se principalmente na posição de Predicate de [TRIPLE](../edge/0x0AAL-triple.md) e na posição de Property de [QUALIFIER](../edge/0x0ABL-qualifier.md).

## Exemplo {#예시}

| Propriedade | WORD sequence |
|---|---|
| `P31` (instance of) | `0191 001F` |
| `P279` (subclass of) | `0191 0117` |
| `P569` (date of birth) | `0191 0239` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-QID](0x014L-wikidata-qid.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x00000190/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000019000000000
BODY
#1 DECLARE 0x0190
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-PID-IDENTIFIED"
#4 BIND #2 "pid"
```

Acima está o documento de codec de `WIKIDATA-PID-IDENTIFIED` (`0x019L`). Os documentos de codec dos outros membros (`WIKIDATA-PID-GENERIC`, `WIKIDATA-PID-FREE-CHOICE`, `WIKIDATA-PID-UNIVERSAL`, `WIKIDATA-PID-VARIABLE`) diferem apenas no Codec ID do DOC-ID, no alvo do DECLARE e no nome ligado em `#1` (BIND).
