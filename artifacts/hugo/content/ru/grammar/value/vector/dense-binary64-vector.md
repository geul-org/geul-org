---
title: "DENSE-BINARY64-VECTOR"
weight: 1010
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY64-VECTOR — одномерный вектор Value, в котором элементы binary64 идут подряд без descriptor (формат Issuer ADHOC `0x0509`)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY64-VECTOR хранит interchange-битовые шаблоны IEEE 754 binary64 подряд, без descriptor.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0509`. Семейство NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] если всего 15 WORD и более
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0509
Payload: [binary64 bits 1st: 4 WORD] ... [binary64 bits Nth: 4 WORD]
```

## Правила интерпретации

- Подряд идущие 4 WORD образуют один элемент и читаются, начиная со старшего WORD. Битовые шаблоны, включая NaN payload и signed zero, сохраняются как есть.
- Число элементов равно 1/4 числа WORD в Payload; ABI padding нет.

## Допустимость

- Payload содержит не менее 4 WORD, и его размер кратен 4 WORD. Формат без descriptor не допускает пустой vector.

## Стандартная основа и статус формата

- Interchange-формат элементов binary64 соответствует [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Одномерная непрерывная последовательность без descriptor, GEUL TAG/Length и раскладка 16-битных big-endian WORD — собственный формат GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) предполагает native-endian, поэтому этот Payload не является wire serialization ни DLPack, ни Arrow, ни ONNX.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть), Issuer 1 WORD, номер формата 1 WORD и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; Length extension TAG тоже входит в общее число ([Length](/ru/grammar/record/)).

## Пример

- Payload `3ff0 0000 0000 0000` — binary64 `[1.0]`; всего запись из 7 WORD.
