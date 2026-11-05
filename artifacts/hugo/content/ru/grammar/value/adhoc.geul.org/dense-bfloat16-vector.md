---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR хранит подряд 16-битные битовые образы элементов bfloat16 без descriptor."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR хранит подряд 16-битные битовые образы элементов bfloat16 без descriptor. Это формат, отличный от binary16.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x00000507`. Семейство NUMERIC.

```
TAG WORD            0000 1001 1101 LLLL      Codec 0x09DL
[Length расш. TAG]  если всего 15 WORD и более
Issuer              2 WORD  0x00000002 (ADHOC)
Номер Codec         2 WORD  0x00000507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## Правила интерпретации {#해석-규칙}

- Число элементов равно числу WORD в Payload. Битовый образ, включая NaN payload и знаковый ноль, сохраняется без изменений.
- Нет ABI-заполнения между элементами и в конце.

## Действительность {#유효성}

- Payload должен составлять не менее 1 WORD. Этот формат без descriptor не допускает пустой vector.
- Размер Payload должен быть кратен ширине элемента 1 WORD.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Отдельный 16-битный dtype bfloat16 и его отличие от binary16 соответствуют [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) и [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Одномерная непрерывная последовательность без descriptor, TAG/Length GEUL и размещение в 16-битных big-endian WORD — собственный формат GEUL. DLPack предполагает native-endian, поэтому этот Payload не является wire-сериализацией DLPack, Arrow или ONNX.

## Длина {#길이}

- Общая длина — число WORD: TAG 1 WORD, расширяющий TAG Length (если есть), Issuer 2 WORD, номер Codec 2 WORD и Payload. До 14 WORD включительно используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; расширяющий TAG тоже входит в общее число ([Length](../../record.md)).

## Пример {#예시}

- Payload `3F80 8000` — это BF16 `1.0` и `-0`, запись общей длиной 7 WORD.
