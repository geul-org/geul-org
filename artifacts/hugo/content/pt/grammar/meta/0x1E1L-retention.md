---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Registra o prazo de conservação do documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `RETENTION` (BIND `RETENTION` do documento de especificação) |
| TAG ID | `0x1E1L` |
| Codec ID | `0x00001E10` |
| Documento de especificação | `0x00000000/codecs/0x00001E10/` (alvo do DECLARE `1E10`) |
| Seção | 15 `1111` (Meta), deslocamento C = 1 na seção |
| Kind | Meta · classe: política |
| TAG WORD | `0001 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Prazo de conservação |
| Lado Hugo | `meta/policy/retention.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | registro | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE, `06D0` DURATION-SECONDS |  |

Registra o prazo de conservação do documento.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[TAG de extensão de Length]
Payload           Instante de expiração (GREGORIAN-DATE etc.) ou duração (DURATION-SECONDS)
```

- Codec: Meta `0x1E1L`, classe de política
- Payload: Value embutido (família TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) etc., ou [DURATION-SECONDS](../value/0x06DL-duration-seconds.md))
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Se for duração, conta-se a partir de [RECORDED-AT](0x1D0L-recorded-at.md).

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001E10/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
