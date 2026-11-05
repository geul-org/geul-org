---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Registra, em um diff (DELTA-BASE), o LOCAL ID (Edge Id) dos registros a retirar do BODY do snapshot-base («exclusão do artigo X»)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `DELTA-REMOVE` (BIND `DELTA-REMOVE` do documento de especificação) |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| Documento de especificação | `0x00000000/codecs/0x00001DC0/` (alvo do DECLARE `1DC0`) |
| Seção | 14 `1110` (Meta), deslocamento C = 28 na seção |
| Kind | Meta · classe: linhagem |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Lista de LOCAL ID (Edge Id) a retirar do BODY-base em um diff |
| Lado Hugo | `meta/lineage/delta-remove.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | valor bruto restante(`0xFFFF`) |  |  |

Registra, em um diff ([DELTA-BASE](0x1DBL-delta-base.md)), o LOCAL ID (Edge Id) dos registros a retirar do BODY do snapshot-base («exclusão do artigo X»).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[TAG de extensão de Length]
LOCAL ID a excluir  Registro LOCAL Reference × 1 ou mais
```

- Codec: Meta `0x1DCL`, classe de linhagem
- Payload: um ou mais registros Reference [LOCAL](../reference/0x005L-local.md)
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Só se coloca em documentos que têm `DELTA-BASE`.
- Cada LOCAL ID deve ser um Edge Id presente no BODY do snapshot-base. Se não existir, é inválido. Colocar o mesmo ID duas vezes é inválido.
- Colocar o mesmo Edge Id novamente no BODY do mesmo diff é inválido (não se pode excluir e revisar ao mesmo tempo).
- Um LOCAL ID excluído não é reatribuído a outro alvo em versões posteriores ([revisão](../document.md#개정)).
- A ausência de um registro no BODY do diff significa «sem alteração». Por isso a exclusão só se expressa com este Meta.
- Os Edge de HEAD ([SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) do documento inteiro e seu QUALIFIER) não são escritos. O HEAD é substituído por inteiro pelo HEAD do diff ([armazenamento por diff](../document.md#diff-저장)).

## Exemplo {#예시}

Exclusão de LOCAL `#7` e `#12`:

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4`(Meta `0x1DCL`, `LLLL=0100`, 5 WORD), LOCAL Reference `0051 0007`, `0051 000C`.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001DC0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
