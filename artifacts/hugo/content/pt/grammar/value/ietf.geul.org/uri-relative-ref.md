---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF é um Value que guarda a sequência de bytes ASCII da gramática relative-ref do RFC 3986."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF é um Value que guarda a sequência de bytes ASCII da gramática `relative-ref` do RFC 3986. O base URI e o resultado resolvido não entram no Payload.

## Layout {#레이아웃}

- Código: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, número do Codec `0x00008000` (número par de bytes) e `0x00008001` (número ímpar de bytes). Família TEXT.
- O número de bytes é determinado pelo bit menos significativo do número do Codec e pelo número de WORD do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](../_index.md)).

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG estendida de Length] quando o total for de 15 WORD ou mais
Issuer            2 WORD  0x00000007 (IETF)
Número do Codec   2 WORD  0x00008000/0x00008001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## Interpretação e validade {#해석과-유효성}

- A sequência de bytes deve obedecer à gramática `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` do RFC 3986.
- Os terminais da gramática de URI são caracteres US-ASCII. Os caracteres ASCII permitidos armazenam-se como estão e, ao fazer o percent-encoding de um octeto, usa-se a forma `pct-encoded = "%" HEXDIG HEXDIG`. Não se devem colocar diretamente caracteres não ASCII como literal byte.
- Como `relative-part` pode ser `path-empty`, uma sequência de bytes vazia também é um `relative-ref` gramaticalmente válido.
- O base URI, o resolution context e o resultado da resolução são contexto externo a este formato.
- Dentro de um WORD, o byte superior vem primeiro. Se o número de bytes for ímpar (código ímpar), o byte inferior não usado do último WORD deve ser `00`.
- O número de WORD do Payload é `ceil(número de bytes/2)`. Se o código for ímpar e o byte inferior do último WORD não for `00`, rejeita-se.

## Base normativa {#표준-근거}

- A sintaxe de `relative-ref`, dos caracteres de URI e do percent-encoding segue o [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- O par de códigos par/ímpar, o zero padding, a TAG/Length do GEUL e a disposição em WORD de 16 bits são regras de framing deste formato. O base URI e o resultado da interpretação da referência são contexto do RFC, mas não entram no Payload.

## Comprimento {#길이}

- O total é o número de WORD somando TAG 1 WORD, a TAG estendida de Length (se houver), Issuer 2 WORD, número do Codec 2 WORD e o Payload. Até 14 WORD usa-se o comprimento direto; a partir de 15 WORD usa-se o comprimento estendido `1110`·`1111`, e a TAG estendida também conta no total ([Length](../../record.md)).
- 0 byte é semanticamente permitido como `relative-ref` vazio e não tem WORD de Payload. Sua disposição física é o problema em aberto abaixo.

## Exemplo {#예시}

- `a/b?x=1` tem 7 bytes (ímpar); portanto, o número do Codec é `0x00008001` e o Payload é `612F 623F 783D 3100`. Como o total é de 9 WORD, `LLLL=1000`. O conjunto é `09D8 0000 0007 0000 8001 612F 623F 783D 3100`.

## Problemas em aberto {#열린-문제}

- A disposição física do `relative-ref` vazio (0 byte). Um registro sem Payload não se concilia com a regra de «Payload mínimo de 1 WORD», e ainda não foi definido.
