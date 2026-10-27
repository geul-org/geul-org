---
title: "DENSE-U32-VECTOR"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U32-VECTOR — одномерный вектор Value, в котором элементы big-endian uint32 идут подряд без descriptor (формат Issuer ADHOC `0x0503`)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U32-VECTOR — однородный одномерный Value: элементы big-endian uint32 хранятся подряд без descriptor.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0503`. Семейство NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] если всего 15 WORD и более
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0503
Payload: [uint32 1st: 2 WORD] ... [uint32 Nth: 2 WORD]
```

## Правила интерпретации

- Подряд идущие 2 WORD, начиная со старшего, объединяются и читаются как беззнаковое 32-битное целое.
- Число элементов равно 1/2 числа WORD в Payload; ABI padding нет.

## Допустимость

- Payload содержит не менее 2 WORD, и его размер кратен 2 WORD. Формат без descriptor не допускает пустой vector.

## Стандартная основа и статус формата

- Беззнаковая трактовка unsigned integer dtype и ширина 32 бит согласованы с промышленными dtype из [tensor element type в ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) и [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Одномерная непрерывная последовательность без descriptor, GEUL TAG/Length и раскладка big-endian WORD — собственный формат GEUL. DLPack считает dtype native-endian, поэтому этот Payload не является wire serialization ни DLPack, ни ONNX.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть), Issuer 1 WORD, номер формата 1 WORD и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; Length extension TAG тоже входит в общее число ([Length](/ru/grammar/record/)).

## Пример

- Payload `0000 0000 ffff ffff` — элементы `[0, 4294967295]`; всего запись из 7 WORD.
