---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR é um Value de tensor que registra o shape e o packed format no descriptor do Payload e armazena em formato packed elementos menores que um WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR é um Value de tensor que registra o shape e o packed format no descriptor do Payload e armazena em formato packed elementos menores que um WORD. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x00000601`, família NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG estendida de Length] quando o total for de 15 WORD ou mais
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x00000601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Resto do Payload  [packed payload octet stream, low-bit-first]
```

## Interpretação {#해석}

- O rank é um valor de 4 bits do descriptor; portanto, estruturalmente só se expressa `0..15`. Cada dimension é um uint32 big-endian não negativo. A ordem lógica é C-contiguous row-major.
- Como na regra de tensor lógico do ONNX, o shape `[]` de rank 0 é um scalar de 1 elemento, e se qualquer dimension for 0, o número de elementos é 0. Nos demais casos, o número de elementos é o produto de todas as dimensions.
- O packed-format fixa o encoding do elemento e a largura em bits, como int2/int4, FP4/FP6 e certas variantes de FP8.
- Chame a sequência de octetos do payload de `p[0], p[1], ...` e considere o inteiro little-bit-endian `P = Σ(p[j] << (8j))`. O elemento lógico `i` de largura `w` é então `(P >> (i × w)) & ((1 << w) - 1)`. Ou seja, coloca-se a partir do primeiro elemento, começando pelo bit mais baixo.
- Nos WORD, `p[0]` vai no octeto superior do primeiro WORD, `p[1]` no octeto inferior, e assim por diante. Os bits tail superiores não usados do último octeto usado devem ser 0 e, se o número de octetos do payload for ímpar, todo o octeto inferior não usado do último WORD deve ser `00`.

## Validade {#유효성}

- Aplicada a largura em bits do format suportado, o número de elementos do payload deve coincidir com o produto das dimensions do shape, calculado sem overflow.
- Rejeita-se se qualquer high tail bit ou octet padding após os bits de payload necessários for 1. O descriptor, o shape e o payload devem caber por inteiro no Length do registro.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- O sentido lógico do shape, do scalar de rank 0 e da dimension zero segue a [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). A regra de dispor os elementos sub-byte a partir do bit mais baixo segue o int2/int4 packing do [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial e o little bit-endian packing do [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- O rank de 4 bits, a dimension uint32, os campos version/packed-format, o modo de agrupar octetos em WORD big-endian e a TAG/Length do GEUL são um descriptor próprio do GEUL. Não são a serialização de wire ou de memória do ONNX, do [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) nem do DLPack.

## Comprimento {#길이}

- O total é o número de WORD somando TAG 1 WORD, a TAG estendida de Length (se houver), Issuer 2 WORD, número do Codec 2 WORD e o Payload. Até 14 WORD usa-se o comprimento direto; a partir de 15 WORD usa-se o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Registro e TAG WORD](../../record.md)).
- O descriptor ocupa 1 WORD, o shape ocupa `2 × rank` WORD e o restante é o packed payload.
- Se o número lógico de elementos for `N` e a largura do elemento for `w`, o número de octetos do payload é `ceil(N × w / 8)` e o número de WORD do payload é `ceil(número de octetos do payload / 2)`.

## Exemplo {#예시}

- Num profile de rank 2, os 4 WORD após o descriptor são o shape, e o que vem depois é a sequência de octetos do payload low-bit-first. A largura do elemento e a permissão de fato são decididas por um format profile já estabelecido.
- Para os elementos de 4 bits `[1, 2, 3]`, a sequência de octetos do payload é `21 03` e o WORD do payload é `2103`. O primeiro elemento está no nibble baixo do primeiro octeto, e o nibble alto não usado do último octeto é 0.

## Problemas em aberto {#열린-문제}

- Os valores do registry de version e packed-format, e a faixa de profiles a suportar dentro do rank representável `0..15`, ainda não foram definidos.
