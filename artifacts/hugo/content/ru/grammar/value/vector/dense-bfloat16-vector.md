---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR — одномерный вектор Value, в котором элементы bfloat16 идут подряд без descriptor (формат Issuer ADHOC `0x0507`)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR хранит 16-битные битовые шаблоны элементов bfloat16 подряд, без descriptor. Это формат, отличный от binary16.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0507`. Семейство NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] если всего 15 WORD и более
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## Правила интерпретации

- Число элементов равно числу WORD в Payload. Битовые шаблоны, включая NaN payload и signed zero, сохраняются как есть.
- Между элементами и в конце нет ABI padding.

## Допустимость

- Payload содержит не менее 1 WORD. Формат без descriptor не допускает пустой vector.
- Размер Payload кратен ширине элемента 1 WORD.

## Стандартная основа и статус формата

- Отдельный 16-битный dtype bfloat16 и его отличие от binary16 согласованы с [tensor element type в ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) и [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Одномерная непрерывная последовательность битовых шаблонов без descriptor, GEUL TAG/Length и раскладка 16-битных big-endian WORD — собственный формат GEUL. DLPack предполагает native-endian, поэтому этот Payload не является wire serialization ни DLPack, ни Arrow, ни ONNX.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть), Issuer 1 WORD, номер формата 1 WORD и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; Length extension TAG тоже входит в общее число ([Length](/ru/grammar/record/)).

## Пример

- Payload `3f80 8000` — BF16 `1.0` и `-0`; всего запись из 5 WORD.
