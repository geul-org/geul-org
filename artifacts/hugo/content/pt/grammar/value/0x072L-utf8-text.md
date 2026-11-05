---
title: "UTF8-TEXT (0x072L·0x073L)"
weight: 114
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT é o Value que contém uma cadeia UTF-8 sem idioma."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT é o Value que contém uma cadeia UTF-8 sem idioma. Usa o par de códigos de bytes pares·ímpares 0x072L/0x073L.

| Item | Valor |
|---|---|
| Nome | `UTF8-TEXT` (grupo par/ímpar; os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x072L`·`0x073L` |
| Seção | 3 `0011` (Value), deslocamento C dentro da seção = 18~19 |
| Kind | Value · família: TEXT |
| Descrição do índice | Sequência de bytes UTF-8 válida (valid) que não implica normalização. Bytes pares·ímpares |
| Lado Hugo | `value/text/utf8-text.md` |

## Membros {#구성원}

Esta página trata em conjunto os dois códigos de um par par/ímpar. O código par é o de valores com número par de bytes, e o ímpar, o de valores com número ímpar ([Registro e TAG WORD](../record.md#가변-길이-바이트열)). Há um documento de Codec por código. Os campos dos dois documentos de Codec são iguais; só diferem o alvo de DECLARE e o nome (BIND).

| TAG ID | Nome | Número de bytes | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x072L` | `UTF8-TEXT-EVEN` | par | `0x00000720` | `0x00000000/codecs/0x00000720/` | `0000 0111 0010 LLLL` |
| `0x073L` | `UTF8-TEXT-ODD` | ímpar | `0x00000730` | `0x00000000/codecs/0x00000730/` | `0000 0111 0011 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restante, valor bruto (`0xFFFF`) |  |  |

UTF8-TEXT é o Value que contém uma sequência de bytes UTF-8 válida (valid) conforme a RFC 3629. Usa-se para cadeias sem idioma, como identificadores, códigos e nomes de arquivo.

## Layout {#레이아웃}

- Código: códigos diretos de Value `0x072L` (número par de bytes) e `0x073L` (número ímpar de bytes). Família TEXT.
- O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0111 001P LLLL      Codec 0x072L/0x073L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## Interpretação e validade {#해석과-유효성}

- A sequência de bytes deve ser UTF-8 bem formado (well-formed) na forma mais curta (shortest-form), conforme a gramática da RFC 3629. O resultado da decodificação contém apenas Unicode scalar values no intervalo `U+0000..U+10FFFF`, sem o intervalo de surrogates `U+D800..U+DFFF`.
- Um U+FEFF no início do Payload (sequência de bytes UTF-8 `EF BB BF`) também é tratado como o mesmo caractere que um U+FEFF em qualquer outra posição, e é permitido. Não se faz o tratamento da signature (BOM) de U+FEFF inicial descrito na RFC 3629. Não é removido nem interpretado como signature; é preservado como no original.
- A Unicode normalization não é imposta. A scalar sequence original decodificada é preservada tal como está.
- A sequência de bytes UTF-8 válida é colocada no Payload sem conversão. Dentro de um WORD, o byte alto vem primeiro. Se o número de bytes é ímpar (código ímpar), o byte baixo não usado do último WORD deve ser `00`.
- O número de WORDs do Payload é `ceil(número de bytes/2)`. Se o código é ímpar e o byte baixo do último WORD não é `00`, rejeita-se.

## Base normativa {#표준-근거}

- O intervalo de scalar do UTF-8 e a sequência de bytes bem formada seguem a [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- O par de códigos par/ímpar, o zero padding e a disposição de TAG/Length de GEUL em WORDs de 16 bits são regras de canonical framing deste formato.

## Comprimento {#길이}

- O total é 1 WORD de TAG mais o número de WORDs da TAG de extensão de Length (se houver) e do Payload. Até 14 WORD usa-se o comprimento direto; com 15 WORD ou mais, o comprimento estendido `1110`·`1111`, e a TAG de extensão também conta no total ([Length](../record.md)).
- Uma cadeia de 0 byte escreve-se como registro de 1 WORD do código par (apenas o TAG WORD) ([Value](_index.md)).

## Exemplo {#예시}

- `A` (`41`) tem 1 byte (ímpar), logo é `UTF8-TEXT-ODD` (`0x073L`), Payload `4100`, 2 WORDs no total, `LLLL=0001`. O total é `0731 4100`.
- A cadeia vazia é `0720` (`UTF8-TEXT-EVEN`, apenas o TAG WORD), 1 WORD.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000720/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000072000000000
BODY
#1 DECLARE 0x0720
#2 FIELD #1 rest
#3 BIND #1 "UTF8-TEXT-EVEN"
#4 BIND #2 "bytes"
```

Acima está o documento de Codec de `UTF8-TEXT-EVEN` (`0x072L`). O documento de Codec do outro membro (`UTF8-TEXT-ODD`) difere apenas no Codec ID do DOC-ID, no alvo de DECLARE e no nome ligado a `#1` (BIND).
