---
title: "MODIFIED-AT (0x1CEL)"
weight: 462
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Registra o instante em que o documento foi modificado."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `MODIFIED-AT` (BIND `MODIFIED-AT` do documento de especificação) |
| TAG ID | `0x1CEL` |
| Codec ID | `0x00001CE0` |
| Documento de especificação | `0x00000000/codecs/0x00001CE0/` (alvo do DECLARE `1CE0`) |
| Seção | 14 `1110` (Meta), deslocamento C = 14 na seção |
| Kind | Meta · classe: proveniência |
| TAG WORD | `0001 1100 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Instante de modificação. Value TIME |
| Lado Hugo | `meta/provenance/modified-at.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | registro | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Registra o instante em que o documento foi modificado.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1110 LLLL      Codec 0x1CEL
[TAG de extensão de Length]
Payload           Um Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS etc.)
```

- Codec: Meta `0x1CEL`, classe de proveniência
- Payload: Value embutido (família TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md) etc.)
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- O formato é escolhido entre os Value da família TIME. Se for necessária precisão, usa-se um formato em nanossegundos definido pelo Issuer (por exemplo, [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001CE0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CE000000000
BODY
#1 DECLARE 0x1CE0
#2 FIELD #1 record
#3 BIND #1 "MODIFIED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
