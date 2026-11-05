---
title: "DENSE-U16-VECTOR"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U16-VECTOR хранит подряд элементы big-endian uint16 без descriptor; это однородное одномерное Value."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U16-VECTOR хранит подряд элементы big-endian uint16 без descriptor; это однородное одномерное Value.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x00000501`. Семейство NUMERIC.

```
TAG WORD            0000 1001 1101 LLLL      Codec 0x09DL
[Length расш. TAG]  если всего 15 WORD и более
Issuer              2 WORD  0x00000002 (ADHOC)
Номер Codec         2 WORD  0x00000501
Payload: [uint16 1st: 1 WORD] ... [uint16 Nth: 1 WORD]
```

## Правила интерпретации {#해석-규칙}

- Каждый WORD читается как независимое беззнаковое 16-битное целое. Число элементов равно числу WORD в Payload.
- Нет ABI-заполнения между элементами и в конце.

## Действительность {#유효성}

- Payload должен составлять не менее 1 WORD. Этот формат без descriptor не допускает пустой vector.
- Размер Payload должен быть кратен ширине элемента 1 WORD.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Беззнаковая интерпретация и 16-битная ширина dtype целого без знака соответствуют промышленным dtype из [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) и [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Одномерная непрерывная последовательность без descriptor, TAG/Length GEUL и размещение в big-endian WORD — собственный формат GEUL. DLPack предполагает для dtype native-endian, поэтому этот Payload не является wire-сериализацией DLPack или ONNX.

## Длина {#길이}

- Общая длина — число WORD: TAG 1 WORD, расширяющий TAG Length (если есть), Issuer 2 WORD, номер Codec 2 WORD и Payload. До 14 WORD включительно используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; расширяющий TAG тоже входит в общее число ([Length](../../record.md)).

## Пример {#예시}

- Payload `0000 FFFF` — это элементы `[0, 65535]`, запись общей длиной 7 WORD с прямой длиной `LLLL=0110`.
