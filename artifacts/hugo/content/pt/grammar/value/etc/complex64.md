---
title: "COMPLEX64"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 é um formato fixo de 7 WORD do Issuer ADHOC que contém um número complexo com dois componentes binary32, parte real e parte imaginária."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 é o Value que representa um número complexo por dois componentes IEEE 754 binary32 na ordem `(real, imag)`. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x0700`, família NUMERIC.

## Layout

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  total de 7 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Interpretação e validade

- Cada componente são bits de interchange binary32 em ordem de WORD big-endian.
- Preservam-se tal como estão os padrões de bits, inclusive o payload de NaN e o zero com sinal, e não há ABI padding.
- O Payload tem exatamente 4 WORD. Preservam-se todos os padrões de bits de interchange dos dois componentes binary32.

## Base normativa e status do formato

- O significado de que `complex64` é formado por um componente real de 32 bits e um componente imaginário de 32 bits segue o [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), e a ordem real-first é igual ao complex raw-data mapping do [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial. O padrão de bits de cada componente segue o [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- O raw data do ONNX é little-endian de largura fixa, mas este formato usa o framing de WORD big-endian do GEUL e, por isso, não é a própria wire serialization do ONNX TensorProto.

## Comprimento

- O total é exatamente 7 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 4 WORD de Payload, e usa o comprimento direto `LLLL=0110`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 4 WORD, rejeita-se.

## Exemplo

- O Payload `3f80 0000 4000 0000` é `1.0 + 2.0i`.
