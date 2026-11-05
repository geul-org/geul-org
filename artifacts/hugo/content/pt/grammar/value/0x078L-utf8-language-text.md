---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT é um texto com idioma, que contém num só Value um registro Value de idioma e um texto UTF-8 (Codec 0x078L/0x079L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT é um texto com idioma, que contém num só Value um registro Value de idioma e um texto UTF-8 (Codec 0x078L/0x079L).

| Item | Valor |
|---|---|
| Nome | `UTF8-LANGUAGE-TEXT` (grupo par/ímpar; os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x078L`·`0x079L` |
| Seção | 3 `0011` (Value), deslocamento C dentro da seção = 24~25 |
| Kind | Value · família: TEXT |
| Descrição do índice | Texto com idioma. Registro Value de idioma (LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE) e bytes UTF-8. Par ou ímpar quanto aos bytes do texto |
| Lado Hugo | `value/text/utf8-language-text.md` |

## Membros {#구성원}

Esta página trata em conjunto os dois códigos de um par par/ímpar. O código par é o de valores com número par de bytes, e o ímpar, o de valores com número ímpar ([Registro e TAG WORD](../record.md#가변-길이-바이트열)). Há um documento de Codec por código. Os campos dos dois documentos de Codec são iguais; só diferem o alvo de DECLARE e o nome (BIND).

| TAG ID | Nome | Número de bytes | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | par | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | ímpar | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | registro | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | restante, valor bruto (`0xFFFF`) |  |  |

UTF8-LANGUAGE-TEXT é um texto com idioma. Contém num só Value um registro Value de idioma e uma sequência de bytes UTF-8.

[UTF8-TEXT](0x072L-utf8-text.md) é uma cadeia sem idioma (identificador, código, nome de arquivo, bytes originais), e este formato é um texto com idioma (nome, título, lema, frase). Os dois são valores diferentes mesmo que os bytes sejam iguais. "Paris" (cadeia) e "Paris" (em francês) não são iguais. É o mesmo que o RDF separar `xsd:string` de `rdf:langString`.

## Layout {#레이아웃}

- Código: códigos diretos de Value `0x078L` (bytes do texto em número par) e `0x079L` (bytes do texto em número ímpar). Família TEXT.

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = texto com número ímpar de bytes)
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Language          1 registro Value LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE (com TAG)
Text WORD 1st ... Nth             UTF-8 bytes / se ímpar, 0x00 no final
```

## Interpretação e validade {#해석과-유효성}

- O Payload começa com o registro de idioma. Lê-se o primeiro WORD do Payload como TAG; o trecho correspondente ao seu Length é o registro de idioma, e o restante são os bytes do texto. O registro de idioma é obrigatório. Sem idioma, usa-se UTF8-TEXT, e não este formato.
- O registro de idioma é exatamente um registro completo de [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) (`0x07AL`) ou de [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). Se for de outro Codec ou estiver incompleto, é invalid. A validade do registro de idioma segue as regras desse formato.
- Os dois formatos de idioma podem ser usados. A regra para comparar se é o mesmo idioma é igual à de [LABEL](../edge/0x0A4L-label.md). Um SHORT-CODE e o tag BCP 47 que o registro associa a esse número são o mesmo idioma.
- `zxx` (sem conteúdo linguístico) não se usa. Uma cadeia assim é UTF8-TEXT. `und` (idioma indeterminado) e `mul` (vários idiomas) são textos com idioma, logo podem ser usados.
- Os bytes do texto seguem as mesmas regras de UTF8-TEXT. Devem ser UTF-8 bem formado (well-formed), um U+FEFF inicial também é permitido como caractere, a normalização não é imposta e o original é preservado tal como está. Quem compara ou indexa faz a comparação normalizando para NFC.
- O número de bytes do texto é `2 × (número de WORDs do Payload − número de WORDs do registro de idioma) − P`. P (bit menos significativo do Codec) indica apenas se os bytes do texto são pares ou ímpares. Se for ímpar, o byte baixo do último WORD deve ser `00`.
- Um texto vazio (0 byte) é o registro de idioma apenas, com código par.

## Onde se usa {#쓰는-곳}

- Valor monolingualtext do Wikidata: `{"text":"Bundesrepublik Deutschland","language":"de"}` torna-se um só destes formatos. Entra tal como está no Object de [TRIPLE](../edge/0x0AAL-triple.md) e no Value de [QUALIFIER](../edge/0x0ABL-qualifier.md). Propriedade, rank e qualifier ficam a cargo do TRIPLE.
- Object de [LABEL](../edge/0x0A4L-label.md) e [ALIAS](../edge/0x0A5L-alias.md). Este único valor contém o nome e o idioma.
- Textos de idioma determinado, como títulos de leis e de artigos.

## Correspondência de códigos de idioma (Wikidata) {#언어-코드-대응-위키데이터}

- Nem todos os códigos de idioma do Wikidata e da Wikimedia são BCP 47 (por exemplo, `simple`, `map-bms`). Converte-se para tag BCP 47 por uma tabela de correspondência. Os códigos que não podem ser convertidos são tratados de modo diferente conforme o uso.
  - Valor (monolingualtext): preserva-se o texto original do datavalue como UTF8-TEXT. O valor é parte da proposição, e descartá-lo mudaria a proposição.
  - Rótulo, descrição, alias: são ignorados e registrados no relatório. Esses Edges só se sustentam com idioma (texto sem idioma é invalid), e o original permanece nos dados de origem.
- Se o tag convertido tem número no GEUL Language Registry, escreve-se com LANGUAGE-SHORT-CODE; se não, com LANGUAGE-BCP47-CODE.

## Comprimento {#길이}

- O total é a soma de 1 WORD de TAG, da TAG de extensão de Length (se houver), do registro de idioma e dos WORDs do texto. Até 14 WORD usa-se o comprimento direto; com 15 WORD ou mais, o comprimento estendido ([Length](../record.md)).
- O registro de idioma tem 2 WORDs se for SHORT-CODE e `ceil(bytes do tag/2) + 1` WORDs se for BCP 47 (`de` 2 WORDs, `zh-Hant` 5 WORDs).

## Exemplo {#예시}

Os idiomas são todos exemplos no formato LANGUAGE-BCP47-CODE. `fr`, `ko` e `de` têm número no registro, de modo que também poderiam ser escritos com SHORT-CODE (2 WORDs).

| Valor | Bytes do texto | WORDs no total |
|---|---|---|
| "Paris" (fr) | 5 (ímpar) | `0795 0761 6672 5061 7269 7300` |
| "" (ko) | 0 | `0782 0761 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (par) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0795` (Codec `0x079L`, `LLLL=0101`, 6 WORDs no total), idioma `0761 6672` (BCP 47 `fr`), texto `5061 7269 7300` (5 bytes, `00` no final).
- O terceiro tem 17 WORDs no total, portanto usa a extensão de Length (`LLLL=1110` em `078E`, TAG de extensão `0011`).

## Base normativa {#표준-근거}

- Language tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`, `und` e `mul` são códigos especiais (special) do IANA Language Subtag Registry.
- Texto: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Distinção entre cadeia e texto com idioma: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Problemas em aberto {#열린-문제}

- Verificação da gramática do tag BCP 47 no schema. Por ora só se verifica que é ASCII e não vazio.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [UTF8-TEXT](0x072L-utf8-text.md), [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [LABEL](../edge/0x0A4L-label.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000780/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

Acima está o documento de Codec de `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`). O documento de Codec do outro membro (`UTF8-LANGUAGE-TEXT-ODD`) difere apenas no Codec ID do DOC-ID, no alvo de DECLARE e no nome ligado a `#1` (BIND).
