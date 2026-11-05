---
title: "RECORDED-BY (0x1CFL)"
weight: 463
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Registra o agente que registrou o documento (git committer)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `RECORDED-BY` (BIND `RECORDED-BY` do documento de especificação) |
| TAG ID | `0x1CFL` |
| Codec ID | `0x00001CF0` |
| Documento de especificação | `0x00000000/codecs/0x00001CF0/` (alvo do DECLARE `1CF0`) |
| Seção | 14 `1110` (Meta), deslocamento C = 15 na seção |
| Kind | Meta · classe: proveniência |
| TAG WORD | `0001 1100 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Agente do registro. Reference (git committer) |
| Lado Hugo | `meta/provenance/recorded-by.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | registro | qualquer registro (exceto marcador de posição) |  |

Registra o agente que registrou o documento (git committer).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1111 LLLL      Codec 0x1CFL
[TAG de extensão de Length]
Payload           Um registro Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL etc.)
```

- Codec: Meta `0x1CFL`, classe de proveniência
- Payload: Reference embutida
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- A Reference não distingue o Codec. Pode ser uma pessoa, uma organização, um modelo ou um motor de regras ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md) etc.).
- Nos documentos publicados em geul.org não se coloca Reference que aponte para pessoa natural ([Issuer e publicação](../issuer.md#geulorg-공표)). Aponta-se para organização ou Issuer. Como exceção, é permitido apontar para pessoa natural por [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).
- Se for LOCAL, o alvo é descrito no BODY.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001CF0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CF000000000
BODY
#1 DECLARE 0x1CF0
#2 FIELD #1 record
#3 BIND #1 "RECORDED-BY"
#4 BIND #2 "actor"
```
