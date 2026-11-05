---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Confirmação do direito de contribuir (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `SIGNED-OFF` (BIND `SIGNED-OFF` do documento de especificação) |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| Documento de especificação | `0x00000000/codecs/0x00001E70/` (alvo do DECLARE `1E70`) |
| Seção | 15 `1111` (Meta), deslocamento C = 7 na seção |
| Kind | Meta · classe: verificação |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Confirmação do direito de contribuir. Reference (git `Signed-off-by`, DCO) |
| Lado Hugo | `meta/verification/signed-off.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | registro | qualquer registro (exceto marcador de posição) |  |

Confirmação do direito de contribuir (git `Signed-off-by`, DCO).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[TAG de extensão de Length]
Payload           Uma Reference
```

- Codec: Meta `0x1E7L`, classe de verificação
- Payload: Reference embutida
- Quantidade: vários possíveis

## Interpretação e validade {#해석과-유효성}

- Nos documentos publicados em geul.org não se coloca Reference que aponte para pessoa natural ([Issuer e publicação](../issuer.md#geulorg-공표)). Aponta-se para organização ou Issuer. Como exceção, é permitido apontar para pessoa natural por [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001E70/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
