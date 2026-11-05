---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara o fim do período de vigência desta versão (lei temporária)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `EFFECTIVE-UNTIL` (BIND `EFFECTIVE-UNTIL` do documento de especificação) |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| Documento de especificação | `0x00000000/codecs/0x00001C90/` (alvo do DECLARE `1C90`) |
| Seção | 14 `1110` (Meta), deslocamento C = 9 na seção |
| Kind | Meta · classe: definição |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Fim do período de vigência desta versão (lei temporária). Se ausente, até que a próxima versão entre em vigor |
| Lado Hugo | `meta/declaration/effective-until.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | registro | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

Declara o fim do período de vigência desta versão (lei temporária). A partir desse instante, esta versão deixa de estar em vigor.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[TAG de extensão de Length]
Payload           Um Value TIME
```

- Codec: Meta `0x1C9L`, classe de definição
- Payload: Value embutido ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) ou [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Se ausente, vale até que a próxima versão entre em vigor.
- Expirado o período de vigência, não há edição em vigor. Edições antigas não voltam a vigorar.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001C90/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
