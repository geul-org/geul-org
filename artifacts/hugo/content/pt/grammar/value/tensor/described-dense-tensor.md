---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR é um formato Issuer do ADHOC que contém, depois de um descriptor de element format, rank e shape, os elementos C-contiguous row-major."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR é o Value de tensor que escreve o shape e o element format no descriptor do Payload e guarda um payload C-contiguous row-major. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x0600`, família NUMERIC.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload restante  [dense payload]
```

## Interpretação

- Como o rank é um valor de 4 bits do descriptor, estruturalmente só se representa `0..15`. Cada dimension é um uint32 big-endian não negativo.
- Como na regra de tensor lógico do ONNX, o shape `[]` de rank 0 é um scalar de 1 elemento, e se qualquer dimension for 0, o número de elementos é 0. Nos demais casos, o número de elementos é o produto de todas as dimensions.
- O payload lê-se no element format do descriptor, em ordem C-contiguous row-major. O número lógico de elementos calculado deve ser igual ao número de elementos do payload depois do descriptor.

## Validade

- Uma vez definidos a version e o element format suportados, recupera-se a fronteira do payload pela largura desse elemento e verifica-se se coincide com o produto do shape calculado sem overflow.
- O descriptor, todas as dimensions e o payload devem caber por inteiro no Length do registro, e não há ABI padding arbitrário.

## Base normativa e status do formato

- A regra de que o shape é uma lista de dimensions não negativas e o número de valores é igual ao produto das dimensions, bem como o significado do scalar de rank 0 e da dimension zero, seguem o [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). A ordem lógica C-contiguous row-major ajusta-se à ordem da [canonical fixed-shape tensor extension do Apache Arrow](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- O rank de 4 bits, a dimension uint32, os campos version/element-format, a TAG/Length do GEUL e o payload em WORD big-endian são um descriptor próprio do GEUL. Não são a wire serialization nem a memory serialization do [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), do ONNX TensorProto nem do [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver), 1 WORD de Issuer, 1 WORD de número de formato e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Registro e TAG WORD](/pt/grammar/record/)).
- O descriptor tem 1 WORD, o shape tem `2 × rank` WORD e o restante é o payload.

## Exemplo

- Num profile de rank 2, as 4 WORD depois do descriptor são as duas dimensions uint32, e tudo o que vem depois é o payload row-major. Para saber se é realmente permitido e para verificar o número de elementos, é necessário um profile definido de version e format.

## Questões em aberto

- Ainda não se definiram os valores do registry de version e element-format, nem a faixa de profiles a suportar entre os ranks representáveis `0..15`.
