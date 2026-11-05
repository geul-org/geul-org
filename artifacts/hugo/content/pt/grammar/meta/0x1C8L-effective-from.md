---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara a data de entrada em vigor desta versão."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `EFFECTIVE-FROM` (BIND `EFFECTIVE-FROM` do documento de especificação) |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| Documento de especificação | `0x00000000/codecs/0x00001C80/` (alvo do DECLARE `1C80`) |
| Seção | 14 `1110` (Meta), deslocamento C = 8 na seção |
| Kind | Meta · classe: definição |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Data de entrada em vigor desta versão. Value GREGORIAN-DATE ou POSIX-TIMESTAMP. Se ausente, o instante de publicação |
| Lado Hugo | `meta/declaration/effective-from.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | registro | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS | |

Declara a data de entrada em vigor desta versão. A data de entrada em vigor difere do instante de publicação ([revisão](../document.md#개정)).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[TAG de extensão de Length]
Payload           Um Value TIME
```

- Codec: Meta `0x1C8L`, classe de definição
- Payload: Value embutido ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) ou [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Se ausente, vigora a partir do instante de publicação.
- Se houver [EFFECTIVE-UNTIL](0x1C9L-effective-until.md), este deve ser anterior a ele.
- Se a data de entrada em vigor diferir por artigo, registra-se separadamente no Edge do artigo com os QUALIFIER P580 (início) e P582 (fim) ([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).
- Este valor é lido quando se interpreta o documento em relação a um ponto no tempo.

## Exemplo {#예시}

- Em vigor em 1970-01-02: `0x1C83 0x06A2 0x0000 0x0001`

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001C80/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
