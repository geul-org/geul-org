---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI é o Value que contém uma sequência de bytes ASCII da gramática de URI da RFC 3986 (URI absoluta com scheme). Usa o par de Codecs de bytes par/ímpar 0x44/0x45."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI é o Value que contém uma sequência de bytes ASCII da gramática `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` da RFC 3986. Como inclui o scheme, a interpretação não precisa de base URI.

## Layout

- Código: códigos diretos de Value `0x44` (número par de bytes) e `0x45` (número ímpar de bytes). Família TEXT.
- O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](/pt/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth          bytes da URI / padding zero final
```

## Interpretação e validade

- A sequência de bytes deve estar de acordo com a gramática `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` da RFC 3986. Pode incluir query e fragment.
- Os terminais da gramática de URI são caracteres US-ASCII. Os caracteres ASCII permitidos guardam-se tal como estão e, ao fazer percent-encoding de um octet, usa-se a forma `pct-encoded = "%" HEXDIG HEXDIG`. Não se pode pôr caracteres não ASCII diretamente como byte literal.
- Deve incluir obrigatoriamente o `scheme` e o `:`. A referência relativa usa [URI-RELATIVE-REF](/pt/grammar/value/text/uri-relative-ref/) (números de formato IETF `0x8000` e `0x8001`).
- A produção URI da RFC 3986 não admite cadeia vazia. Um registro de 0 byte não é válido.
- Dentro da WORD, o byte superior vem primeiro. Se o número de bytes for ímpar (código ímpar), o byte inferior não usado da última WORD deve ser `00`.
- O número de WORDs do Payload é `ceil(número de bytes/2)`. Se for um código ímpar e o byte inferior da última WORD não for `00`, rejeita-se.

## Base normativa

- A gramática de `URI`, dos caracteres de URI e do percent-encoding segue a [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- O par de Codecs par/ímpar, o zero padding e a TAG/Length do GEUL com a disposição de WORD de 16 bits são regras de framing deste formato.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver) e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Length](/pt/grammar/record/)).

## Exemplo

- `https://example.com/` tem 20 bytes ASCII (par), então é `URI-EVEN` (`0x44`).
- O Payload são 10 WORD: `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.
- Somando 1 WORD de TAG e 10 WORD de Payload, são 11 WORD no total, então `LLLL=1010`. O registro inteiro é `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.

## GEUL Archive URI

O `archive.geul.org` é um repositório de conteúdo imutável planejado para que o GEUL possa referenciar conteúdos grandes, como binários e documentos externos. Ainda não está em operação. O formato de endereço recomendado é `https://archive.geul.org/sha256/{digest}`. A mesma sequência de bytes deve ter a mesma URI e, depois de publicada, não se podem trocar os bytes dessa URI.

O Value URI apenas representa a localização ou a cadeia de endereço de um conteúdo externo e não garante a identidade nem a imutabilidade do alvo em si. Binários e textos que ultrapassam o tamanho máximo de um Value inline podem ser referenciados por uma archive URI. Nos metadados do objeto armazenado devem registrar-se os seguintes itens.

- URI original e instante de coleta
- SHA-256 e Byte Length
- MIME type
- license identifier e version
- Autor, origem e avisos
- URI do fundamento da licença e, se necessário, uma cópia do fundamento à época da coleta

A possibilidade de coletar julga-se não por se poder acessar gratuitamente, mas por se confirmar explicitamente a permissão de redistribuição. Devem respeitar-se as condições da licença aplicável, como atribuição de autoria, uso não comercial, proibição de modificação e compartilhamento pela mesma licença. Nos documentos e conteúdos registra-se uma licença explícita, como a Creative Commons, e nos programas usa-se, sempre que possível, o SPDX License ID.

Mesmo que se interrompa o fornecimento por questões de direitos ou correção, não se podem pôr outros bytes na URI existente. Essa URI deve devolver um tombstone com o motivo e o instante da interrupção e preservar o digest original e o registro de auditoria. No entanto, se uma obrigação legal proibir a preservação do registro de auditoria, prevalece essa obrigação.

A archive URI fornece juntos o local de acesso e o digest do conteúdo. Essas regras de content-address e de imutabilidade são a política do profile GEUL Archive, e a gramática geral do Value URI não depende do `archive.geul.org`.
