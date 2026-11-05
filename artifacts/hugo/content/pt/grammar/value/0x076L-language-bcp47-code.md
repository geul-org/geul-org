---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE é o Value que contém um language tag BCP 47 completo como sequência de bytes ASCII."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE é o Value que contém um language tag BCP 47 completo como sequência de bytes ASCII. Usa o par de códigos de bytes pares·ímpares 0x076L/0x077L.

| Item | Valor |
|---|---|
| Nome | `LANGUAGE-BCP47-CODE` (grupo par/ímpar; os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x076L`·`0x077L` |
| Seção | 3 `0011` (Value), deslocamento C dentro da seção = 22~23 |
| Kind | Value · família: TEXT |
| Descrição do índice | Sequência de bytes ASCII de um language tag BCP 47 completo em canonical casing. Bytes pares·ímpares |
| Lado Hugo | `value/text/language-bcp47-code.md` |

## Membros {#구성원}

Esta página trata em conjunto os dois códigos de um par par/ímpar. O código par é o de valores com número par de bytes, e o ímpar, o de valores com número ímpar ([Registro e TAG WORD](../record.md#가변-길이-바이트열)). Há um documento de Codec por código. Os campos dos dois documentos de Codec são iguais; só diferem o alvo de DECLARE e o nome (BIND).

| TAG ID | Nome | Número de bytes | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | par | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | ímpar | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restante, valor bruto (`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE é o Value que contém um language tag BCP 47 completo. Usa-se para escrever o idioma com exatidão, até script, region e variant.

## Layout {#레이아웃}

- Código: códigos diretos de Value `0x076L` (número par de bytes) e `0x077L` (número ímpar de bytes). Família TEXT.
- O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](_index.md)).
- O Payload não é texto UTF-8, mas a sequência de bytes ASCII do tag BCP 47.

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## Interpretação e validade {#해석과-유효성}

- A sequência de bytes deve ser um language tag BCP 47 bem formado (well-formed) da RFC 5646. Não se admite cadeia vazia.
- O Payload usa apenas letras ASCII, dígitos e hyphen-minus `-`. O separador é obrigatoriamente o `-` ASCII; `_`, espaços e caracteres não ASCII não são permitidos.
- A comparação de tags BCP 47 não distingue maiúsculas de minúsculas. O canonical profile de GEUL usa `-` para todos os separadores e serializa os subtags language/extlang/variant/extension/private-use em minúsculas, o script em Titlecase e a region em maiúsculas.
- Estar bem formado não basta. A validade de subtags registrados e de grandfathered tags é julgada com base em um snapshot específico do IANA Language Subtag Registry, e a data do snapshot ou a versão do registry deve ser preservada em conjunto.
- Tags private-use e subtags private-use são permitidos se estiverem bem formados na gramática da RFC 5646. No entanto, o significado depende de acordo entre as partes e não é definido pelo registry da IANA, de modo que não se garante interoperabilidade pública.
- Se, no mesmo snapshot, um subtag deprecated ou um grandfathered tag tem Preferred-Value, a forma canonical de GEUL escreve esse valor substituto em canonical casing. Um tag na notação deprecated original pode ser interpretado como entrada, mas não é a forma de armazenamento canonical.
- Como BCP 47 é um profile ASCII, não se aplica a exigência de Unicode normalization, como UTF-8 NFC.
- Dentro de um WORD, o byte alto vem primeiro. Se o número de bytes é ímpar (código ímpar), o byte baixo não usado do último WORD deve ser `00`.
- O número de WORDs do Payload é `ceil(número de bytes/2)`. Se o código é ímpar e o byte baixo do último WORD não é `00`, rejeita-se.

## Base normativa {#표준-근거}

- A gramática do language tag, a interpretação sem distinção de maiúsculas e minúsculas e o conceito de deprecated/Preferred-Value seguem a [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- O registry que julga a validade do tag é o [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- O par de códigos par/ímpar, o zero padding, a política de armazenamento em canonical casing e o cálculo de Length são regras de framing de GEUL.

## Comprimento {#길이}

- O total é 1 WORD de TAG mais o número de WORDs da TAG de extensão de Length (se houver) e do Payload. Até 14 WORD usa-se o comprimento direto; com 15 WORD ou mais, o comprimento estendido `1110`·`1111`, e a TAG de extensão também conta no total ([Length](../record.md)).

## Relação com LANGUAGE-SHORT-CODE {#language-short-code와의-관계}

- Um tag que tem número no GEUL Language Registry pode ser escrito em 1 WORD com [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md).
- Um tag sem número no registro (inclusive tags com extension ou private-use) escreve-se com LANGUAGE-BCP47-CODE. Também se usa LANGUAGE-BCP47-CODE quando é preciso preservar o texto original do tag completo.
- O SHORT-CODE `n` e o LANGUAGE-BCP47-CODE do tag que o registro associa a `n` (sem distinguir maiúsculas de minúsculas) são o mesmo idioma.

## Exemplo {#예시}

- `ko-KR` tem 5 bytes ASCII (ímpar), logo é `LANGUAGE-BCP47-CODE-ODD` (`0x077L`), e o Payload é `6B6F 2D4B 5200`.
- Com 1 WORD de TAG e 3 WORDs de Payload, o total é 4 WORDs e `LLLL=0011`. O total é `0773 6B6F 2D4B 5200`.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000760/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

Acima está o documento de Codec de `LANGUAGE-BCP47-CODE-EVEN` (`0x076L`). O documento de Codec do outro membro (`LANGUAGE-BCP47-CODE-ODD`) difere apenas no Codec ID do DOC-ID, no alvo de DECLARE e no nome ligado a `#1` (BIND).
