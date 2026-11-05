---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR é um Value de tensor que registra o shape e o element format no descriptor do Payload e armazena um payload C-contiguous row-major."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR é um Value de tensor que registra o shape e o element format no descriptor do Payload e armazena um payload C-contiguous row-major. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x00000600`, família NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG estendida de Length] quando o total for de 15 WORD ou mais
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x00000600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Resto do Payload  [dense payload]
```

## Interpretação {#해석}

- O rank é um valor de 4 bits do descriptor; portanto, estruturalmente só se expressa `0..15`. Cada dimension é um uint32 big-endian não negativo.
- Como na regra de tensor lógico do ONNX, o shape `[]` de rank 0 é um scalar de 1 elemento, e se qualquer dimension for 0, o número de elementos é 0. Nos demais casos, o número de elementos é o produto de todas as dimensions.
- O payload é lido com o element format do descriptor, na ordem C-contiguous row-major. O número lógico de elementos calculado deve ser igual ao número de elementos do payload após o descriptor.

## Validade {#유효성}

- Uma vez fixados a version e o element format suportados, recupera-se o limite do payload com a largura desse elemento e verifica-se se coincide com o produto do shape, calculado sem overflow.
- O descriptor, todas as dimensions e o payload devem caber por inteiro no Length do registro, e não há ABI padding arbitrário.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- A regra de que o shape é uma lista de dimensions não negativas e de que o número de valores é igual ao produto das dimensions, bem como o sentido do scalar de rank 0 e da dimension zero, seguem a [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). A ordem lógica C-contiguous row-major coincide com a da [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- O rank de 4 bits, a dimension uint32, os campos version/element-format, a TAG/Length do GEUL e o payload em WORD big-endian são um descriptor próprio do GEUL. Não são a serialização de wire ou de memória do [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), do ONNX TensorProto nem da [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Comprimento {#길이}

- O total é o número de WORD somando TAG 1 WORD, a TAG estendida de Length (se houver), Issuer 2 WORD, número do Codec 2 WORD e o Payload. Até 14 WORD usa-se o comprimento direto; a partir de 15 WORD usa-se o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Registro e TAG WORD](../../record.md)).
- O descriptor ocupa 1 WORD, o shape ocupa `2 × rank` WORD e o restante é o payload.

## Exemplo {#예시}

- Num profile de rank 2, os 4 WORD após o descriptor são as duas dimensions uint32, e tudo o que vem depois é o payload row-major. Para saber se é permitido de fato e para verificar o número de elementos, é necessário um profile de version e format já estabelecido.

## Problemas em aberto {#열린-문제}

- Os valores do registry de version e element-format, e a faixa de profiles a suportar dentro do rank representável `0..15`, ainda não foram definidos.
