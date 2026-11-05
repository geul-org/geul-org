---
title: "COMPLEX64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 — Value, представляющее комплексное число двумя компонентами IEEE 754 binary32 в порядке (real, imag)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 — Value, представляющее комплексное число двумя компонентами IEEE 754 binary32 в порядке `(real, imag)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x00000700`, семейство NUMERIC.

## Раскладка {#레이아웃}

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  всего 9 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Номер Codec       2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Интерпретация и действительность {#해석과-유효성}

- Каждая компонента — interchange bits binary32 в порядке big-endian WORD.
- Битовый образ, включая NaN payload и знаковый ноль, сохраняется без изменений; выравнивающего заполнения ABI нет.
- Payload составляет ровно 4 WORD. Сохраняются все interchange bit pattern обеих компонент binary32.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Смысл `complex64` как 32-битной вещественной и 32-битной мнимой компонент следует [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), а порядок «сначала real» совпадает с complex raw-data mapping в официальной [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3). Битовый образ каждой компоненты следует [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Raw data в ONNX — little-endian фиксированной ширины, а этот формат использует big-endian framing WORD в GEUL, поэтому он не является wire-сериализацией ONNX TensorProto как таковой.

## Длина {#길이}

- Общая длина — ровно 9 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 4 WORD; используется прямая длина `LLLL=1000`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.

## Пример {#예시}

- Payload `3F80 0000 4000 0000` — это `1.0 + 2.0i`.
