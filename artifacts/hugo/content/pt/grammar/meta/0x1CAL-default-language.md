---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara o idioma padrão do texto do documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `DEFAULT-LANGUAGE` (BIND `DEFAULT-LANGUAGE` do documento de especificação) |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| Documento de especificação | `0x00000000/codecs/0x00001CA0/` (alvo do DECLARE `1CA0`) |
| Seção | 14 `1110` (Meta), deslocamento C = 10 na seção |
| Kind | Meta · classe: definição |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Idioma padrão |
| Lado Hugo | `meta/declaration/default-language.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | registro | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

Declara o idioma padrão do texto do documento. O texto cujo idioma não é indicado separadamente está neste idioma.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[TAG de extensão de Length]
Payload           Um Value de idioma
```

- Codec: Meta `0x1CAL`, classe de definição
- Payload: Value embutido ([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) ou [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Documentos TANGEUL registram a localidade de redação (por exemplo, `en`, `ko`).

## Exemplo {#예시}

- `en`: `0x1CA2 0x0761 0x656E`

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001CA0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
