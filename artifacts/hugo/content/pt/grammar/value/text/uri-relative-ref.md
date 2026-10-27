---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF é o Value que contém uma sequência de bytes ASCII da gramática relative-ref da RFC 3986. Usa os números de formato 0x8000/0x8001 do Issuer IETF."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF é o Value que contém uma sequência de bytes ASCII da gramática `relative-ref` da RFC 3986. A base URI e o resultado já resolvido (resolve) não vão no Payload.

## Layout

- Código: `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0020` IETF, número de formato `0x8000` (número par de bytes) e `0x8001` (número ímpar de bytes). Família TEXT.
- O número de bytes é determinado pelo bit menos significativo do número de formato e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](/pt/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Issuer            1 WORD  0x0020 (IETF)
Número de formato 1 WORD  0x8000/0x8001
Payload WORD 1st ... Nth          bytes de relative-ref / padding zero final
```

## Interpretação e validade

- A sequência de bytes deve estar de acordo com a gramática `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` da RFC 3986.
- Os terminais da gramática de URI são caracteres US-ASCII. Os caracteres ASCII permitidos guardam-se tal como estão e, ao fazer percent-encoding de um octet, usa-se a forma `pct-encoded = "%" HEXDIG HEXDIG`. Não se pode pôr caracteres não ASCII diretamente como byte literal.
- Como `relative-part` pode ser `path-empty`, uma sequência de bytes vazia também é um `relative-ref` válido pela gramática.
- A base URI, o contexto de resolução e o resultado do resolve são um contexto externo a este formato.
- Dentro da WORD, o byte superior vem primeiro. Se o número de bytes for ímpar (código ímpar), o byte inferior não usado da última WORD deve ser `00`.
- O número de WORDs do Payload é `ceil(número de bytes/2)`. Se for um código ímpar e o byte inferior da última WORD não for `00`, rejeita-se.

## Base normativa

- A gramática de `relative-ref`, dos caracteres de URI e do percent-encoding segue a [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- O par de Codecs par/ímpar, o zero padding e a TAG/Length do GEUL com a disposição de WORD de 16 bits são regras de framing deste formato. A base URI e o resultado da resolução da referência são contexto da RFC, mas não vão no Payload.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver), 1 WORD de Issuer, 1 WORD de número de formato e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Length](/pt/grammar/record/)).
- 0 byte é permitido semanticamente como `relative-ref` vazio, sem WORD de Payload. A sua disposição física está nas questões em aberto abaixo.

## Exemplo

- `a/b?x=1` tem 7 bytes (ímpar), então o número de formato é `0x8001` e o Payload é `612f 623f 783d 3100`. São 7 WORD no total, então `LLLL=0110`. O registro inteiro é `0B7C 0020 8001 612f 623f 783d 3100`.

## Questões em aberto

- A disposição física do `relative-ref` vazio (0 byte). Ainda não foi definida porque um registro sem Payload não casa com a regra do "mínimo de 1 WORD de Payload".
