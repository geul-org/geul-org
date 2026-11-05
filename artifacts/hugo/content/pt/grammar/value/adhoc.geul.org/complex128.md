---
title: "COMPLEX128"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 é um Value que representa um número complexo por dois componentes IEEE 754 binary64, na ordem (real, imag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 é um Value que representa um número complexo por dois componentes IEEE 754 binary64, na ordem `(real, imag)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, número do Codec `0x00000701`, família NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total de 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Número do Codec   2 WORD  0x00000701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## Interpretação e validade {#해석과-유효성}

- Cada componente é formado pelos interchange bits de um binary64 na ordem de WORD big-endian.
- O bit pattern, incluindo o NaN payload e o zero com sinal, é preservado como está, e não há ABI padding.
- O Payload tem exatamente 8 WORD. Preservam-se todos os interchange bit patterns dos dois componentes binary64.

## Base normativa e estatuto formal {#표준-근거와-형식-지위}

- O sentido de que `complex128` se compõe de um componente real de 64 bits e um componente imaginário de 64 bits segue o [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), e a ordem real-first coincide com o complex raw-data mapping do [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) oficial. O bit pattern de cada componente segue o [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- O raw data do ONNX é fixed-width little-endian, mas este formato usa o enquadramento em WORD big-endian do GEUL; portanto, não é a própria wire serialization do ONNX TensorProto.

## Comprimento {#길이}

- O total é exatamente 13 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 8 WORD, e usa-se o comprimento direto `LLLL=1100`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 8 WORD, rejeita-se.

## Exemplo {#예시}

- Se os dois binary64 do Payload forem `1.0, -0.0`, o valor tem parte real 1.0 e parte imaginária -0.0.
