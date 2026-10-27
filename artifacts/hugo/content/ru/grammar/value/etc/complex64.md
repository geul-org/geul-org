---
title: "COMPLEX64"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 — формат Issuer ADHOC фиксированной длины 7 WORD для комплексного числа из двух компонентов binary32: действительной и мнимой частей."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 — Value, представляющий комплексное число двумя компонентами IEEE 754 binary32 в порядке `(real, imag)`. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0700`, семейство NUMERIC.

## Раскладка

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  всего 7 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## Интерпретация и допустимость

- Каждый компонент — interchange-биты binary32 в порядке big-endian WORD.
- Битовые шаблоны сохраняются как есть, включая NaN payload и signed zero; ABI padding нет.
- Payload содержит ровно 4 WORD. Сохраняются все interchange-битовые шаблоны обоих компонентов binary32.

## Стандартная основа и статус формата

- Смысл `complex64` как 32-битной действительной и 32-битной мнимой компонент соответствует [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), а порядок «сначала real» совпадает с отображением complex raw-data в официальной [схеме ONNX TensorProto](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3). Битовый шаблон каждого компонента соответствует [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Raw data в ONNX — little-endian фиксированной ширины, а этот формат использует big-endian WORD framing GEUL, поэтому он не является самой wire serialization ONNX TensorProto.

## Длина

- Всего ровно 7 WORD: TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 4 WORD; используется прямая длина `LLLL=0110`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, запись отвергается.

## Пример

- Payload `3f80 0000 4000 0000` — это `1.0 + 2.0i`.
