---
title: "COMPLEX64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 é um Value que representa um número complexo por dois componentes IEEE 754 binary32, na ordem (real, imag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 é um Value que representa um número complexo por dois componentes IEEE 754 binary32, na ordem `(real, imag)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x00000700`, família NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total de 9 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Interpretação e validade {#해석과-유효성}

- Cada componente é formado pelos interchange bits de um binary32 na ordem de WORD big-endian.
- O bit pattern, incluindo o NaN payload e o zero com sinal, é preservado como está, e não há ABI padding.
- O Payload tem exatamente 4 WORD. Preservam-se todos os interchange bit patterns dos dois componentes binary32.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- O sentido de que `complex64` se compõe de um componente real de 32 bits e um componente imaginário de 32 bits segue o [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), e a ordem real-first coincide com o complex raw-data mapping do [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial. O bit pattern de cada componente segue o [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- O raw data do ONNX é fixed-width little-endian, mas este formato usa o enquadramento em WORD big-endian do GEUL; portanto, não é a própria wire serialization do ONNX TensorProto.

## Comprimento {#길이}

- O total é exatamente 9 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 4 WORD, e usa-se o comprimento direto `LLLL=1000`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 4 WORD, rejeita-se.

## Exemplo {#예시}

- O Payload `3F80 0000 4000 0000` é `1.0 + 2.0i`.
