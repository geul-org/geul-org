---
title: "COMPLEX128"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 — формат Issuer ADHOC фиксированной длины 11 WORD для комплексного числа из двух компонентов binary64: действительной и мнимой частей."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 — Value, представляющий комплексное число двумя компонентами IEEE 754 binary64 в порядке `(real, imag)`. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0701`, семейство NUMERIC.

## Раскладка

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  всего 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## Интерпретация и допустимость

- Каждый компонент — interchange-биты binary64 в порядке big-endian WORD.
- Битовые шаблоны сохраняются как есть, включая NaN payload и signed zero; ABI padding нет.
- Payload содержит ровно 8 WORD. Сохраняются все interchange-битовые шаблоны обоих компонентов binary64.

## Стандартная основа и статус формата

- Смысл `complex128` как 64-битной действительной и 64-битной мнимой компонент соответствует [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), а порядок «сначала real» совпадает с отображением complex raw-data в официальной [схеме ONNX TensorProto](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3). Битовый шаблон каждого компонента соответствует [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Raw data в ONNX — little-endian фиксированной ширины, а этот формат использует big-endian WORD framing GEUL, поэтому он не является самой wire serialization ONNX TensorProto.

## Длина

- Всего ровно 11 WORD: TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 8 WORD; используется прямая длина `LLLL=1010`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 8 WORD, запись отвергается.

## Пример

- Если два binary64 в Payload равны `1.0, -0.0`, то это значение с действительной частью 1.0 и мнимой частью -0.0.
