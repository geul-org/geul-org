---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION é um Edge de enunciado que liga ao Object uma única descrição, em um idioma específico, do alvo Subject."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `DESCRIPTION` (BIND `DESCRIPTION` do documento de especificação) |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| Documento de especificação | `0x00000000/codecs/0x00000A60/` (alvo do DECLARE `0A60`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 6 |
| Kind | Edge · família: enunciado, grupo: apontamento e nome |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Liga a descrição (description) de Subject em um idioma. O layout é igual ao de LABEL |
| Lado Hugo | `edge/description.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | qualquer registro (exceto marcador de posição) |  |
| 2 | `object` | #3 | registro | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

DESCRIPTION é um Edge de enunciado que liga ao Object uma única descrição, em um idioma específico, do alvo Subject. Codec `0x0A6L`.

A descrição é uma frase curta que distingue o alvo (description do Wikidata, por exemplo "capital e maior cidade da Alemanha"). Não é uma definição nem uma afirmação sobre o alvo. Uma proposição sobre o alvo é escrita como [TRIPLE](0x0AAL-triple.md). O layout é igual ao de [LABEL](0x0A4L-label.md). A descrição e o seu idioma ficam em um único Object, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). Não há campo de valor bruto.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 Value UTF8-LANGUAGE-TEXT ou 1 registro Reference LOCAL
```

## Interpretação e validade {#해석과-유효성}

- As regras de Subject e Object são iguais às de [LABEL](0x0A4L-label.md). Subject é exatamente um registro Reference completo. Object é exatamente um registro UTF8-LANGUAGE-TEXT (`0x078L`·`0x079L`) completo, ou uma Reference LOCAL que se resolve para UTF8-LANGUAGE-TEXT pelo binding [REFERENCE-NODE](0x0A0L-reference-node.md) do mesmo documento.
- Um texto sem idioma (UTF8-TEXT) não pode ser DESCRIPTION. Como a descrição é única por idioma, essa regra só se sustenta com idioma. Uma descrição comum a vários idiomas é escrita com o idioma `mul`.
- Para o mesmo Subject e idioma há no máximo um DESCRIPTION.
- A descrição serve para distinguir de outros alvos com o mesmo nome. É desejável que o par LABEL e DESCRIPTION não se repita em dois alvos no mesmo idioma, mas a especificação não verifica isso (o Wikidata também apenas recomenda, sem impor).
- O documento de especificação do geul.org restringe Object por [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, igual a LABEL).

## Comprimento {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORDs
```

- O registro de idioma e o número de bytes do texto de Object ficam a cargo do registro Object. O cursor, depois de ler o último registro, deve coincidir exatamente com o fim do Edge.
- Como a descrição é mais longa que o label, é fácil que tanto Object quanto o Edge passem de 15 WORDs. Nesse caso usa-se a extensão de Length ([registro](../record.md)).

## Exemplo (não normativo) {#예시-비규범}

Edge Id `0009`, Subject Q64 (`0141 0040`), Object `capital and largest city of Germany` (en). O idioma é um exemplo no formato LANGUAGE-BCP47-CODE (`en` tem o número de registro `0x0784`, portanto também pode ser usado como SHORT-CODE).

- Object é o idioma `0761 656E` (BCP47 `en`, 2 WORDs) + texto de 35 bytes (ímpar, 18 WORDs), portanto `0x079L`, TAG 1 + TAG estendida 1 + 20 = 22 WORDs, `079E 0016 …`.
- O Edge tem TAG 1 + TAG estendida 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORDs, portanto `LLLL=1110`, TAG `0A6E`, TAG estendida `001C`.

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Correspondência com o Wikidata {#위키데이터-대응}

- `descriptions` do item (uma por idioma) → um DESCRIPTION por idioma. O código de idioma é convertido pela mesma tabela de correspondência de códigos de idioma de LABEL.

## Problemas em aberto {#열린-문제}

- Se há casos em que se deveria permitir uma descrição UTF8-TEXT sem idioma (por ora não se permite).

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000A60/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
