---
title: "DENSE-U16-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U16-VECTOR — одномерный вектор Value, в котором элементы big-endian uint16 идут подряд без descriptor (формат Issuer ADHOC `0x0501`)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U16-VECTOR — однородный одномерный Value: элементы big-endian uint16 хранятся подряд без descriptor.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0501`. Семейство NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] если всего 15 WORD и более
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0501
Payload: [uint16 1st: 1 WORD] ... [uint16 Nth: 1 WORD]
```

## Правила интерпретации

- Каждый WORD читается как независимое беззнаковое 16-битное целое. Число элементов равно числу WORD в Payload.
- Между элементами и в конце нет ABI padding.

## Допустимость

- Payload содержит не менее 1 WORD. Формат без descriptor не допускает пустой vector.
- Размер Payload кратен ширине элемента 1 WORD.

## Стандартная основа и статус формата

- Беззнаковая трактовка unsigned integer dtype и ширина 16 бит согласованы с промышленными dtype из [tensor element type в ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) и [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Одномерная непрерывная последовательность без descriptor, GEUL TAG/Length и раскладка big-endian WORD — собственный формат GEUL. DLPack считает dtype native-endian, поэтому этот Payload не является wire serialization ни DLPack, ни ONNX.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть), Issuer 1 WORD, номер формата 1 WORD и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; Length extension TAG тоже входит в общее число ([Length](/ru/grammar/record/)).

## Пример

- Payload `0000 ffff` — элементы `[0, 65535]`; всего запись из 5 WORD с прямой длиной `LLLL=0100`.
