---
title: "DENSE-I32-VECTOR"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I32-VECTOR — одномерный вектор Value, в котором элементы big-endian int32 идут подряд без descriptor (формат Issuer ADHOC `0x0502`)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I32-VECTOR — однородный одномерный Value: элементы big-endian int32 хранятся подряд без descriptor.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0502`. Семейство NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] если всего 15 WORD и более
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0502
Payload: [int32 1st: 2 WORD] ... [int32 Nth: 2 WORD]
```

## Правила интерпретации

- Подряд идущие 2 WORD, начиная со старшего, объединяются и читаются как 32-битное целое в дополнительном коде.
- Число элементов равно 1/2 числа WORD в Payload; ABI padding нет.

## Допустимость

- Payload содержит не менее 2 WORD, и его размер кратен 2 WORD. Формат без descriptor не допускает пустой vector.

## Стандартная основа и статус формата

- Знаковость signed integer dtype и ширина 32 бит согласованы с промышленными dtype из [tensor element type в ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) и [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Трактовка в дополнительном коде, одномерная непрерывная последовательность без descriptor, GEUL TAG/Length и раскладка big-endian WORD — собственный формат GEUL. DLPack считает dtype native-endian, поэтому этот Payload не является wire serialization ни DLPack, ни ONNX.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть), Issuer 1 WORD, номер формата 1 WORD и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; Length extension TAG тоже входит в общее число ([Length](/ru/grammar/record/)).

## Пример

- Payload `ffff ffff 0000 0002` — элементы `[-1, 2]`; всего запись из 7 WORD.
