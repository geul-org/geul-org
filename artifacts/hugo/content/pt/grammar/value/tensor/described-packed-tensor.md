---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR é um formato Issuer do ADHOC que contém, depois de um descriptor de packed format, rank e shape, elementos sub-WORD preenchidos em low-bit-first."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR é o Value de tensor que escreve o shape e o packed format no descriptor do Payload e guarda de forma packed elementos menores que uma WORD. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x0601`, família NUMERIC.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload restante  [packed payload octet stream, low-bit-first]
```

## Interpretação

- Como o rank é um valor de 4 bits do descriptor, estruturalmente só se representa `0..15`. Cada dimension é um uint32 big-endian não negativo. A ordem lógica é C-contiguous row-major.
- Como na regra de tensor lógico do ONNX, o shape `[]` de rank 0 é um scalar de 1 elemento, e se qualquer dimension for 0, o número de elementos é 0. Nos demais casos, o número de elementos é o produto de todas as dimensions.
- O packed-format fixa a codificação do elemento e a largura em bits, como int2/int4, FP4/FP6 e algumas variantes de FP8.
- Chamando a sequência de octetos do payload de `p[0], p[1], ...` e vendo-a como o inteiro little-bit-endian `P = Σ(p[j] << (8j))`, o elemento lógico `i` de largura `w` é `(P >> (i × w)) & ((1 << w) - 1)`. Isto é, o primeiro elemento entra nos bits mais baixos.
- Na WORD, `p[0]` vai como octeto superior da primeira WORD e `p[1]` como octeto inferior, e assim por diante. Os bits de cauda superiores não usados do último octeto usado devem ser 0 e, se o número de octetos do payload for ímpar, todo o octeto inferior não usado da última WORD deve ser `00`.

## Validade

- Aplicada a largura em bits do format suportado, o produto das dimensions do shape calculado sem overflow deve coincidir com o número de elementos do payload.
- Rejeita-se se algum bit de cauda superior ou algum padding de octeto depois dos bits de payload necessários for 1. O descriptor, o shape e o payload devem caber por inteiro no Length do registro.

## Base normativa e status do formato

- O significado lógico do shape, do scalar de rank 0 e da dimension zero segue o [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). A regra de pôr os elementos sub-byte a partir dos bits mais baixos segue o int2/int4 packing do [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial e o little bit-endian packing do [`DLDataType` do DLPack](https://dmlc.github.io/dlpack/latest/c_api.html).
- O rank de 4 bits, a dimension uint32, os campos version/packed-format, o modo de agrupar octetos em WORD big-endian e a TAG/Length do GEUL são um descriptor próprio do GEUL. Não são a wire serialization nem a memory serialization do ONNX, do [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) nem do DLPack.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver), 1 WORD de Issuer, 1 WORD de número de formato e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Registro e TAG WORD](/pt/grammar/record/)).
- O descriptor tem 1 WORD, o shape tem `2 × rank` WORD e o restante é o payload packed.
- Se o número lógico de elementos é `N` e a largura do elemento é `w`, o número de octetos do payload é `ceil(N × w / 8)` e o número de WORDs do payload é `ceil(número de octetos do payload / 2)`.

## Exemplo

- Num profile de rank 2, as 4 WORD depois do descriptor são o shape, e o que vem depois é a sequência de octetos do payload low-bit-first. A largura do elemento e se é realmente permitido julgam-se por um format profile definido.
- A sequência de octetos do payload dos elementos de 4 bits `[1, 2, 3]` é `21 03` e a WORD do payload é `2103`. O primeiro elemento está no nibble inferior do primeiro octeto, e o nibble superior não usado do último octeto é 0.

## Questões em aberto

- Ainda não se definiram os valores do registry de version e packed-format, nem a faixa de profiles a suportar entre os ranks representáveis `0..15`.
