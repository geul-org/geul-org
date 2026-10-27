---
title: "COMPLEX128"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 é um formato fixo de 11 WORD do Issuer ADHOC que contém um número complexo com dois componentes binary64, parte real e parte imaginária."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 é o Value que representa um número complexo por dois componentes IEEE 754 binary64 na ordem `(real, imag)`. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0001` ADHOC, número de formato `0x0701`, família NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total de 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Número de formato 1 WORD  0x0701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## Interpretação e validade

- Cada componente são bits de interchange binary64 em ordem de WORD big-endian.
- Preservam-se tal como estão os padrões de bits, inclusive o payload de NaN e o zero com sinal, e não há ABI padding.
- O Payload tem exatamente 8 WORD. Preservam-se todos os padrões de bits de interchange dos dois componentes binary64.

## Base normativa e status do formato

- O significado de que `complex128` é formado por um componente real de 64 bits e um componente imaginário de 64 bits segue o [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), e a ordem real-first é igual ao complex raw-data mapping do [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial. O padrão de bits de cada componente segue o [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- O raw data do ONNX é little-endian de largura fixa, mas este formato usa o framing de WORD big-endian do GEUL e, por isso, não é a própria wire serialization do ONNX TensorProto.

## Comprimento

- O total é exatamente 11 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 8 WORD de Payload, e usa o comprimento direto `LLLL=1010`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 8 WORD, rejeita-se.

## Exemplo

- Se os dois binary64 do Payload forem `1.0, -0.0`, é o valor com parte real 1.0 e parte imaginária -0.0.
