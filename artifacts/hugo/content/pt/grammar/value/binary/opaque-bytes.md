---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES é um formato Issuer do GEUL que contém uma sequência arbitrária de bytes, sem definir por si o significado nem o formato."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES é uma sequência arbitrária de bytes cujo significado e formato este próprio formato não define. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0000` GEUL, números de formato `0xC000` e `0xC001` (número par e ímpar de bytes), família BINARY. O número de bytes é determinado pelo bit menos significativo do número de formato e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](/pt/grammar/value/)).

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Issuer            1 WORD  0x0000 (GEUL)
Número de formato 1 WORD  0xC000/0xC001
Payload WORD 1st ... Nth   bytes / zero padding final
```

## Interpretação e validade

- Do Payload leem-se, em sequência, tantos bytes quantos indica o número de bytes. Dentro da WORD, o byte superior vem primeiro.
- O número de WORDs do Payload é `ceil(número de bytes/2)`. Se for um código ímpar e o byte inferior da última WORD não for `00`, rejeita-se.
- Se o código par/ímpar, o número de WORDs do Payload e o zero padding não coincidirem, rejeita-se.

## Status do formato

- O par de códigos par/ímpar, a disposição do payload e o zero padding da última WORD não citam uma norma industrial externa: são um framing próprio do GEUL.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver), 1 WORD de Issuer, 1 WORD de número de formato e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Registro e TAG WORD](/pt/grammar/record/)).
- 0 byte escreve-se como um registro de 3 WORD (TAG, Issuer, número de formato) sem Payload, com o número de formato par (`0xC000`).

## Exemplo

Os bytes `ab cd ef` são 3 bytes (ímpar), então o número de formato é `0xC001` e o Payload é `abcd ef00`. São 5 WORD no total, então `LLLL=0100`.

```
0A7C 0000 C001 abcd ef00
```
