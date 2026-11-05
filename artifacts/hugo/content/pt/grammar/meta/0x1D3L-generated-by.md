---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Registra o agente que produziu o documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `GENERATED-BY` (BIND `GENERATED-BY` do documento de especificação) |
| TAG ID | `0x1D3L` |
| Codec ID | `0x00001D30` |
| Documento de especificação | `0x00000000/codecs/0x00001D30/` (alvo do DECLARE `1D30`) |
| Seção | 14 `1110` (Meta), deslocamento C = 19 na seção |
| Kind | Meta · classe: linhagem |
| TAG WORD | `0001 1101 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Agente gerador. Pessoa, modelo ou motor de regras |
| Lado Hugo | `meta/lineage/generated-by.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | registro | qualquer registro (exceto marcador de posição) |  |
| 2 | `version` | #5 | registro | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0000` ABSENT (campo opcional) |  |

Registra o agente que produziu o documento. Pode ser uma pessoa, um modelo ou um motor de regras.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[TAG de extensão de Length]
Agente gerador    Reference (pessoa, modelo, motor de regras)
Versão            Value UTF8-TEXT, ou marca de omissão 0x0000 (campo opcional)
```

- Codec: Meta `0x1D3L`, classe de linhagem
- Payload: Reference embutida + texto de versão (opcional)
- Quantidade: vários possíveis

## Interpretação e validade {#해석과-유효성}

- Se for um modelo, registra-se também a versão do modelo.
- Se a versão for desconhecida ou não for posta, omite-se essa posição e usa-se ABSENT (`0x0000`) (campo opcional de [CODEC](../edge/0x0BEL-codec.md)). A especificação `0x1D30` de geul.org tem dois campos de registro: agent (sem CODEC) e version (`0720`, `0730`, `0000`).
- Para a versão-fonte (commit) de um programa, o formato de [TRANSFORMED-BY](0x1D4L-transformed-by.md) (digest, obrigatório) é mais preciso. A versão de GENERATED-BY registra em texto o que não é um ID de commit, como o nome e a versão de um modelo.
- Nos documentos publicados em geul.org não se coloca Reference que aponte para pessoa natural ([Issuer e publicação](../issuer.md#geulorg-공표)). Aponta-se para organização ou Issuer. Como exceção, é permitido apontar para pessoa natural por [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001D30/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
