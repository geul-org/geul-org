---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL é um Edge de enunciado que liga ao Object um único nome (label), em um idioma específico, do alvo Subject."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `LABEL` (BIND `LABEL` do documento de especificação) |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| Documento de especificação | `0x00000000/codecs/0x00000A40/` (alvo do DECLARE `0A40`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 4 |
| Kind | Edge · família: enunciado, grupo: apontamento e nome |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Liga o nome (label) de Subject em um idioma. Object é UTF8-LANGUAGE-TEXT |
| Lado Hugo | `edge/label.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | qualquer registro (exceto marcador de posição) |  |
| 2 | `object` | #3 | registro | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

LABEL é um Edge de enunciado que liga ao Object um único nome (label), em um idioma específico, do alvo Subject. Codec `0x0A4L`. Não é um Edge que representa o lemma da lexicologia geral.

O nome e o seu idioma ficam em um único Object, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). Não há campo de valor bruto.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 Value UTF8-LANGUAGE-TEXT ou 1 registro Reference LOCAL
```

## Interpretação e validade {#해석과-유효성}

- Subject é exatamente um registro Reference completo. A fronteira é encontrada pelo Length do próprio Subject; se não for Reference ou estiver incompleto, é invalid.
- Object é exatamente um registro [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) (`0x078L`·`0x079L`) completo. As regras de idioma e texto (ambos os formatos de idioma são permitidos, comparação de mesmo idioma) seguem esse formato.
- Object também pode ser uma Reference LOCAL. Nesse caso, ela deve ser resolvida para UTF8-LANGUAGE-TEXT pelo binding [REFERENCE-NODE](0x0A0L-reference-node.md) do mesmo documento. Se não for resolvida, ou se for resolvida para um alvo de outro tipo, é invalid.
- O documento de especificação do geul.org escreve esta restrição com [CODEC](0x0BEL-codec.md) (Object = `0780`·`0790`·`0050`). O alvo de resolução de LOCAL não é expresso por CODEC.
- Se Object não for um dos dois formatos acima, ou se o registro estiver incompleto, é invalid. Um texto sem idioma (UTF8-TEXT) não pode ser LABEL. Um nome para máquina sem idioma é escrito como [BIND](0x0A3L-bind.md). Um nome comum a vários idiomas é escrito com o idioma `mul`.
- Para o mesmo Subject e idioma há no máximo um LABEL. Outros nomes são escritos como [ALIAS](0x0A5L-alias.md).

## Comprimento {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORDs
```

- O registro de idioma e o número de bytes do texto de Object ficam a cargo do registro Object, não do Edge. O cursor, depois de ler o último registro, deve coincidir exatamente com o fim do Edge.

## Exemplo (não normativo) {#예시-비규범}

O código de idioma `0784` de `en` é o número do GEUL Language Registry v2 (documento de especificação `0x00000000/codecs/0x000007A0`, versão 2).

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id `0007`, Subject Q22686 (`0141 589E`), Object `Donald Trump` (en).

- Object é o idioma `07A1 0784` (SHORT-CODE, 2 WORDs) + texto de 12 bytes (par, 6 WORDs), portanto `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), 9 WORDs no total: `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`.
- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORDs, `LLLL=1101`. A TAG é `0A4D`.

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id `0008`, Subject Q155 (`0141 009B`), Object `Brasil` (pt-BR).

- Object é o idioma `0773 7074 2D42 5200` (BCP47 `pt-BR`, 4 WORDs) + texto de 6 bytes (par, 3 WORDs), portanto 8 WORDs no total: `0787 0773 7074 2D42 5200 4272 6173 696C`.
- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORDs, `LLLL=1100`. A TAG é `0A4C`.

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md), [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000A40/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
