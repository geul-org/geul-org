---
title: "DENSE-BINARY16-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR — одномерный вектор Value, в котором элементы binary16 идут подряд без descriptor (формат Issuer ADHOC `0x0506`)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR хранит interchange-битовые шаблоны IEEE 754 binary16 подряд, без descriptor.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0506`. Семейство NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] если всего 15 WORD и более
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## Правила интерпретации

- Число элементов равно числу WORD в Payload. Битовые шаблоны, включая NaN payload и signed zero, сохраняются как есть.
- Между элементами и в конце нет ABI padding.

## Допустимость

- Payload содержит не менее 1 WORD. Формат без descriptor не допускает пустой vector.
- Размер Payload кратен ширине элемента 1 WORD.

## Стандартная основа и статус формата

- Interchange-формат элементов binary16 соответствует [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Одномерная непрерывная последовательность без descriptor, GEUL TAG/Length и раскладка 16-битных big-endian WORD — собственный формат GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) предполагает native-endian, поэтому этот Payload не является wire serialization ни DLPack, ни Arrow, ни ONNX.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть), Issuer 1 WORD, номер формата 1 WORD и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; Length extension TAG тоже входит в общее число ([Length](/ru/grammar/record/)).

## Пример

- Payload `3c00 8000` — binary16 `1.0` и `-0`; всего запись из 5 WORD.
