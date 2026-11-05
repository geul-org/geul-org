---
title: "DENSE-U64-VECTOR"
weight: 1014
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U64-VECTOR хранит подряд элементы big-endian uint64 без descriptor; это однородное одномерное Value."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U64-VECTOR хранит подряд элементы big-endian uint64 без descriptor; это однородное одномерное Value.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x00000505`. Семейство NUMERIC.

```
TAG WORD            0000 1001 1101 LLLL      Codec 0x09DL
[Length расш. TAG]  если всего 15 WORD и более
Issuer              2 WORD  0x00000002 (ADHOC)
Номер Codec         2 WORD  0x00000505
Payload: [uint64 1st: 4 WORD] ... [uint64 Nth: 4 WORD]
```

## Правила интерпретации {#해석-규칙}

- 4 идущих подряд WORD объединяются начиная со старшего и читаются как беззнаковое 64-битное целое.
- Число элементов равно 1/4 числа WORD в Payload; ABI-заполнения нет.

## Действительность {#유효성}

- Payload должен составлять не менее 4 WORD и быть кратен 4 WORD. Этот формат без descriptor не допускает пустой vector.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Беззнаковая интерпретация и 64-битная ширина dtype целого без знака соответствуют промышленным dtype из [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) и [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Одномерная непрерывная последовательность без descriptor, TAG/Length GEUL и размещение в big-endian WORD — собственный формат GEUL. DLPack предполагает для dtype native-endian, поэтому этот Payload не является wire-сериализацией DLPack или ONNX.

## Длина {#길이}

- Общая длина — число WORD: TAG 1 WORD, расширяющий TAG Length (если есть), Issuer 2 WORD, номер Codec 2 WORD и Payload. До 14 WORD включительно используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; расширяющий TAG тоже входит в общее число ([Length](../../record.md)).

## Пример {#예시}

- Payload `0000 0000 0000 0001` — это элементы `[1]`, запись общей длиной 9 WORD.
