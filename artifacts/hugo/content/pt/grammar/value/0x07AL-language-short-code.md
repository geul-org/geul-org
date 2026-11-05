---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE é o código de idioma comprimido de GEUL que contém, em 1 WORD, um tag BCP 47 ao qual foi atribuído um número no GEUL Language Registry."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `LANGUAGE-SHORT-CODE` (BIND do documento de especificação `LANGUAGE-SHORT-CODE`) |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| Documento de especificação | `0x00000000/codecs/0x000007A0/` (alvo de DECLARE `07A0`) |
| Seção | 3 `0011` (Value), deslocamento C dentro da seção = 26 |
| Kind | Value · família: TEXT |
| TAG WORD | `0000 0111 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Tag BCP 47 escrito com o número do GEUL Language Registry (Payload de 1 WORD) |
| Lado Hugo | `value/text/language-short-code.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | valor bruto de 1 WORD |  | 8678 ENUM. Ex.: `0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE é o código de idioma comprimido de GEUL que contém, em 1 WORD, um tag BCP 47 ao qual foi atribuído um número no GEUL Language Registry. O Payload é exatamente 1 WORD.

## Layout {#레이아웃}

- Código: código direto de Value `0x07AL`. Família TEXT.
- O Payload é um código unsigned de 16 bits em exatamente 1 WORD.

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  2 WORDs no total
Payload WORD 1st (16 bits)           número do GEUL Language Registry (uint16)
```

## Interpretação e validade {#해석과-유효성}

- O WORD do Payload é lido como inteiro unsigned de 16 bits.
- Este valor é um tag atribuído pelo GEUL Language Registry. A representação oficial do registro é o documento de especificação deste Codec, `0x00000000/codecs/0x000007A0`. Para cada valor de código há um [ENUM](../edge/0x0BDL-enum.md) no FIELD `code`, e o nome ligado por [BIND](../edge/0x0A3L-bind.md) ao Edge Id desse ENUM é o tag BCP 47 em maiúsculas e minúsculas canônicas.
- O registro é uma lista fechada. Um valor sem ENUM no documento de especificação é invalid. Esta regra do Codec prevalece sobre a regra geral de ENUM (“um valor de código não declarado não é erro”).
- Os alvos da atribuição são os três seguintes.
  - Dentre os registros `Type: language` do IANA Language Subtag Registry, os que não têm `Scope: private-use` (`qaa..qtz`). Collection, macrolanguage e special (`mul`·`und`·`zxx`·`mis`) não são excluídos.
  - Tags registrados integralmente pela IANA: grandfathered e redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan` etc.).
  - Tags combinados válidos observados em fontes públicas CC0 (`pt-BR`, `en-GB`, `be-tarask` etc.). São tags formados apenas por subtags language, extlang, script, region e variant. Tags com extension (`-u-`·`-t-`) e private-use (`-x-`) não são aceitos.
- Um tag sem número não pode ser escrito neste formato. Escreve-se com [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). Dentro do SHORT-CODE não há caminho de escape.
- `0x0000` e `0xFFFF` nunca são atribuídos. Neste Value, ambos são invalid. Nenhum dos dois é usado com o sentido de `null`, `unknown` ou `und`.
- As faixas de valores são convenção de atribuição. O decodificador não deduz o tipo do tag pela faixa do valor. O significado do valor vem apenas do documento de especificação.

| Faixa | Uso |
|---|---|
| `0x0000` | não atribuído (invalid) |
| `0x0001`–`0x3FFF` | tags de um só subtag language |
| `0x4000`–`0x7FFF` | tags com dois ou mais subtags (tags integrais da IANA, tags combinados observados) |
| `0x8000`–`0xFFFE` | transbordo. Quando os blocos acima se enchem, a atribuição continua aqui |
| `0xFFFF` | não atribuído (invalid) |

- A edição inicial atribui os números dentro do bloco na ordem ASCII do tag em minúsculas. No bloco `0x4000`, vêm primeiro os tags integrais da IANA (em ordem ASCII, com grandfathered e redundant misturados) e depois os tags combinados observados (em ordem ASCII). A ordem física do arquivo da IANA e a frequência de uso não são regra de numeração.
- A atribuição só acrescenta (append-only). Um tag novo é acrescentado ao fim do bloco e, quando o bloco se enche, ao fim da faixa de transbordo. O tag (sem distinguir maiúsculas de minúsculas) de um número já atribuído não é alterado, apagado nem reutilizado.
- Um tag novo é incluído acrescentando ENUM e BIND numa nova versão do documento de especificação. Os ENUM e BIND existentes não são alterados. Por isso, qualquer versão é um superconjunto da anterior.
- Quando os 65.534 números se esgotam, não se atribui mais. Os tags novos depois disso escrevem-se com LANGUAGE-BCP47-CODE. A capacidade de expressão não diminui; só se perde o ganho de compressão.
- Mesmo idioma: o SHORT-CODE `n` e o LANGUAGE-BCP47-CODE do tag que o registro associa a `n` (sem distinguir maiúsculas de minúsculas) são o mesmo idioma.
- A edição do registro é a versão do documento de especificação. Cada edição registra, como [SOURCE](../edge/0x0C0L-source.md) no HEAD do documento de especificação, o arquivo de registry da IANA em que se baseou (File-Date, SHA-256). Quando for preciso indicar a edição com que um valor foi interpretado, deixa-se junto essa versão ([CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, `0x000007A0`, ID de versão `n`)).
- Uma especificação de Codec pode conter o mesmo código de 1 WORD como campo de valor bruto sem TAG ([CODEC](../codec-spec.md#codec) do campo de valor bruto). Isso é regra dessa especificação de Codec; a wire form de um Value independente é sempre TAG de 1 WORD + Payload de 1 WORD.

## Base normativa {#표준-근거}

- O significado do tag e a validade dos subtags seguem o [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) e a [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA e IETF mantêm os direitos sobre os registros de protocolo sob CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Os números do registro (atribuição append-only em ordem ASCII, composição dos blocos, `0x0000` e `0xFFFF` não atribuídos, lista fechada), o fato de o ENUM do documento de especificação ser a representação oficial e a distinção em relação ao embedding em campo de valor bruto sem TAG são regras de GEUL.

## Comprimento {#길이}

- O total é exatamente 2 WORDs, 1 WORD de TAG mais 1 WORD de Payload, e usa o comprimento direto `LLLL=0001`. Não há TAG de extensão de Length, descriptor nem padding.
- Se o Payload não for exatamente 1 WORD, rejeita-se.

## Exemplo {#예시}

São os números do registro v2 (documento de especificação `0x00000000/codecs/0x000007A0` versão 2, IANA File-Date 2026-09-17). Foram atribuídos 8.678 (language 8.275, grandfathered 26, redundant 67, combinados observados 310).

| tag | Código | WORDs no total |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- No documento de especificação, `en` é `ENUM #2 0x0784` e o `BIND "en"` ligado ao Edge Id desse ENUM.
- `de-x-formal` (private-use) e `nl-u-sd-bebru` (extension) não têm número, logo escrevem-se com LANGUAGE-BCP47-CODE.

## Problemas em aberto {#열린-문제}

- Interpretação entre edições: ao encontrar um número mais novo que a edição do leitor, descartá-lo como invalid ou tratá-lo como “código desconhecido” preservando o valor original. Por ser append-only, a edição mais recente basta sempre, mas é preciso uma regra para decodificadores offline.
- Forma canônica: um tag com número deve ser escrito com SHORT-CODE (SHOULD/MUST)? Com MUST, a notação fica única, mas, quando sai uma edição nova, os documentos escritos antes deixam de estar na forma canônica.
- Como representar no documento de especificação os tags deprecated e o Preferred-Value (a edição atual não os tem).
- Procedimento para acrescentar tags combinados observados (fonte, limite inferior de observação).

## Páginas relacionadas {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md), [LABEL](../edge/0x0A4L-label.md)
- [Documento de especificação de Codec](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000007A0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (17346 linhas de ENUM·BIND omitidas)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
