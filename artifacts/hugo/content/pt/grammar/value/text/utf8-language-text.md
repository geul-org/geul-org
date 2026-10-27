---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT é um texto com idioma, que contém num só Value um registro Value de idioma e um texto UTF-8 (Codec 0x4A/0x4B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT é um texto com idioma. Contém num só Value um registro Value de idioma e uma sequência de bytes UTF-8.

[UTF8-TEXT](/pt/grammar/value/text/utf8-text/) é uma cadeia sem idioma (identificadores, códigos, nomes de arquivo, bytes do texto original), e este formato é um texto com idioma (nomes, títulos, slogans, frases). Os dois são valores diferentes mesmo com bytes iguais. "Paris" (cadeia) e "Paris" (francês) não são iguais. É como o RDF separa `xsd:string` e `rdf:langString`.

## Layout

- Código: códigos diretos de Value `0x4A` (texto com número par de bytes) e `0x4B` (texto com número ímpar de bytes). Família TEXT.

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = o texto tem número ímpar de bytes)
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Language          1 registro Value LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE (com TAG)
Text WORD 1st ... Nth             bytes UTF-8 / se ímpar, 0x00 no final
```

## Interpretação e validade

- O Payload começa com o registro de idioma. A primeira WORD do Payload é lida como TAG, e o trecho desse Length é o registro de idioma; o restante são os bytes do texto. O registro de idioma é obrigatório. Sem idioma, usa-se UTF8-TEXT, e não este formato.
- O registro de idioma é exatamente um registro completo de [LANGUAGE-SHORT-CODE](/pt/grammar/value/text/language-short-code/) (`0x48`) ou [LANGUAGE-BCP47-CODE](/pt/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`). Se for outro Codec ou estiver incompleto, é invalid. A validade do registro de idioma segue as regras desse formato.
- Podem-se usar os dois formatos de idioma. A regra para comparar se é o mesmo idioma é a de [LABEL](/pt/grammar/edge/label/). O SHORT-CODE e a tag BCP 47 correspondente, com um único primary subtag, são o mesmo idioma.
- Não se usa `zxx` (sem conteúdo de idioma). Essa cadeia é UTF8-TEXT. `und` (idioma indefinido) e `mul` (vários idiomas) são textos com idioma e, por isso, podem ser usados.
- Os bytes do texto seguem as mesmas regras de UTF8-TEXT. Devem ser UTF-8 bem formado, proíbe-se o BOM inicial e preserva-se o texto original tal como está, sem impor normalização. Quem compara e indexa os ajusta para NFC ao comparar.
- O número de bytes do texto é `2 × (número de WORD do Payload − número de WORD do registro de idioma) − P`. O P (bit menos significativo do Codec) indica apenas a paridade dos bytes do texto. Se for ímpar, o byte inferior da última WORD deve ser `00`.
- Um texto vazio (0 byte) leva só o registro de idioma num código par.

## Onde se usa

- Valores monolingualtext do Wikidata: `{"text":"Bundesrepublik Deutschland","language":"de"}` torna-se um só destes formatos. Entra tal qual no Object de [TRIPLE](/pt/grammar/edge/triple/) e no Value de [QUALIFIER](/pt/grammar/edge/qualifier/). A propriedade, o rank e o qualifier ficam a cargo do TRIPLE.
- O Object de [LABEL](/pt/grammar/edge/label/) e [ALIAS](/pt/grammar/edge/alias/). Este único valor contém o nome e o idioma.
- Textos de idioma determinado, como títulos de leis e de artigos.

## Correspondência de códigos de idioma (Wikidata)

- Nem todos os códigos de idioma do Wikidata e da Wikimedia são BCP 47 (por exemplo, `simple`, `map-bms`). Transcrevem-se para tags BCP 47 por uma tabela de correspondência. Os códigos que não se podem transcrever tratam-se de modo diferente conforme o uso.
  - Valores (monolingualtext): preserva-se o texto original do datavalue como UTF8-TEXT. Como o valor faz parte da proposição, descartá-lo muda a proposição.
  - Labels, descrições e aliases: pulam-se e deixa-se registro no relatório. Esses Edges só se sustentam com idioma (texto sem idioma é invalid), e o texto original permanece nos dados de origem.
- Até existir o GEUL Language Registry, usa-se LANGUAGE-BCP47-CODE.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver), o registro de idioma e as WORDs do texto. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido ([Length](/pt/grammar/record/)).
- O registro de idioma tem 2 WORD se for SHORT-CODE e `ceil(bytes da tag/2) + 1` WORD se for BCP 47 (`de` 2 WORD, `zh-Hant` 5 WORD).

## Exemplo

Os idiomas são todos LANGUAGE-BCP47-CODE, pois o registry ainda não existe.

| Valor | Bytes do texto | Total de WORD |
|---|---|---|
| "Paris" (fr) | 5 (ímpar) | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (par) | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0ACB` (Codec `0x4B`, `LLLL=0101`, 6 WORD no total), idioma `08C6 6672` (BCP 47 `fr`), texto `5061 7269 7300` (5 bytes, `00` final).
- O terceiro tem 17 WORD no total e por isso usa a extensão de Length (`LLLL=1110` em `0F4A`, TAG estendida `0011`).

## Base normativa

- Language tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`, `und` e `mul` são códigos special do IANA Language Subtag Registry.
- Texto: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Distinção entre cadeia e texto com idioma: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Questões em aberto

- A verificação da gramática da tag BCP 47 pelo schema. Por ora só se vê que é ASCII e não vazia.

## Páginas relacionadas

- [Value](/pt/grammar/value/), [UTF8-TEXT](/pt/grammar/value/text/utf8-text/), [LANGUAGE-SHORT-CODE](/pt/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/pt/grammar/value/text/language-bcp47-code/), [LABEL](/pt/grammar/edge/label/)
