---
title: "URI (0x074L·0x075L)"
weight: 116
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI é o Value que contém uma sequência de bytes ASCII na gramática de URI da RFC 3986 (URI absoluto, com scheme)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI é o Value que contém uma sequência de bytes ASCII na gramática de URI da RFC 3986 (URI absoluto, com scheme). Usa o par de códigos de bytes pares·ímpares 0x074L/0x075L.

| Item | Valor |
|---|---|
| Nome | `URI` (grupo par/ímpar; os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x074L`·`0x075L` |
| Seção | 3 `0011` (Value), deslocamento C dentro da seção = 20~21 |
| Kind | Value · família: TEXT |
| Descrição do índice | Sequência de bytes ASCII da production `URI` da RFC 3986. Bytes pares·ímpares |
| Lado Hugo | `value/text/uri.md` |

## Membros {#구성원}

Esta página trata em conjunto os dois códigos de um par par/ímpar. O código par é o de valores com número par de bytes, e o ímpar, o de valores com número ímpar ([Registro e TAG WORD](../record.md#가변-길이-바이트열)). Há um documento de Codec por código. Os campos dos dois documentos de Codec são iguais; só diferem o alvo de DECLARE e o nome (BIND).

| TAG ID | Nome | Número de bytes | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x074L` | `URI-EVEN` | par | `0x00000740` | `0x00000000/codecs/0x00000740/` | `0000 0111 0100 LLLL` |
| `0x075L` | `URI-ODD` | ímpar | `0x00000750` | `0x00000000/codecs/0x00000750/` | `0000 0111 0101 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restante, valor bruto (`0xFFFF`) |  |  |

URI é o Value que contém uma sequência de bytes ASCII na gramática `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` da RFC 3986. Como inclui o scheme, a interpretação não precisa de base URI.

## Layout {#레이아웃}

- Código: códigos diretos de Value `0x074L` (número par de bytes) e `0x075L` (número ímpar de bytes). Família TEXT.
- O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0111 010P LLLL      Codec 0x074L/0x075L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## Interpretação e validade {#해석과-유효성}

- A sequência de bytes deve obedecer à gramática `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` da RFC 3986. Pode incluir query e fragment.
- Os terminais da gramática de URI são caracteres US-ASCII. Os caracteres ASCII permitidos são armazenados como estão, e, ao aplicar percent-encoding a octetos, usa-se a forma `pct-encoded = "%" HEXDIG HEXDIG`. Caracteres não ASCII não podem ser colocados diretamente como bytes literais.
- `scheme` e `:` são obrigatórios. Para referências relativas, usa-se [URI-RELATIVE-REF](ietf.geul.org/uri-relative-ref.md) (números de Codec IETF `0x00008000`·`0x00008001`).
- A production URI da RFC 3986 não admite cadeia vazia. Um registro de 0 byte não é válido.
- Dentro de um WORD, o byte alto vem primeiro. Se o número de bytes é ímpar (código ímpar), o byte baixo não usado do último WORD deve ser `00`.
- O número de WORDs do Payload é `ceil(número de bytes/2)`. Se o código é ímpar e o byte baixo do último WORD não é `00`, rejeita-se.

## Base normativa {#표준-근거}

- A sintaxe de `URI`, dos caracteres de URI e do percent-encoding segue a [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- O par de códigos par/ímpar, o zero padding e a disposição de TAG/Length de GEUL em WORDs de 16 bits são regras de framing deste formato.

## Comprimento {#길이}

- O total é 1 WORD de TAG mais o número de WORDs da TAG de extensão de Length (se houver) e do Payload. Até 14 WORD usa-se o comprimento direto; com 15 WORD ou mais, o comprimento estendido `1110`·`1111`, e a TAG de extensão também conta no total ([Length](../record.md)).

## Exemplo {#예시}

- `https://example.com/` tem 20 bytes ASCII (par), logo é `URI-EVEN` (`0x074L`).
- O Payload tem 10 WORDs: `6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.
- Somando 1 WORD de TAG e 10 WORDs de Payload, o total é 11 WORDs, logo `LLLL=1010`. O total é `074A 6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.

## GEUL Archive URI {#geul-archive-uri}

`archive.geul.org` foi concebido como repositório imutável de conteúdo para que GEUL possa referenciar conteúdos grandes, como binários e documentos externos, e ainda não está em operação. O formato de endereço recomendado é `https://archive.geul.org/sha256/{digest}`. A mesma sequência de bytes deve ter o mesmo URI, e, depois de publicado, os bytes de um URI não podem ser alterados.

O Value URI apenas representa a localização ou a cadeia de endereço de um conteúdo externo e não garante a identidade nem a imutabilidade do próprio alvo. Binários e textos que excedem o intervalo máximo de um Value em linha podem ser referenciados por um archive URI. Os metadados do objeto armazenado devem registrar os seguintes itens.

- URI original e momento da coleta
- SHA-256 e Byte Length
- MIME type
- license identifier e version
- Autoria, procedência e avisos
- URI da base da licença e, se necessário, uma cópia dessa base na época da coleta

A possibilidade de coleta é julgada não por o acesso ser gratuito, mas por a permissão de redistribuição estar explicitamente confirmada. Devem ser respeitadas as condições de licença aplicáveis, como atribuição, uso não comercial, proibição de alteração e compartilhamento pela mesma licença. Em documentos e conteúdos registra-se uma licença explícita, como Creative Commons, e em software usa-se, sempre que possível, o SPDX License ID.

Mesmo que o fornecimento seja interrompido por questão de direitos ou por correção, não se podem colocar outros bytes num URI existente. Esse URI deve devolver um tombstone com o motivo e o momento da interrupção, e o digest original e o registro de auditoria devem ser preservados. No entanto, se uma obrigação legal proibir a preservação do registro de auditoria, essa obrigação prevalece.

O archive URI fornece em conjunto o local de acesso e o digest do conteúdo. Essa regra de content-address e de imutabilidade é política do profile GEUL Archive, e a gramática geral do Value URI não depende de `archive.geul.org`.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000740/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000074000000000
BODY
#1 DECLARE 0x0740
#2 FIELD #1 rest
#3 BIND #1 "URI-EVEN"
#4 BIND #2 "bytes"
```

Acima está o documento de Codec de `URI-EVEN` (`0x074L`). O documento de Codec do outro membro (`URI-ODD`) difere apenas no Codec ID do DOC-ID, no alvo de DECLARE e no nome ligado a `#1` (BIND).
