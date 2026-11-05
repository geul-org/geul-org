---
title: "DENSE-BINARY32-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY32-VECTOR хранит подряд interchange bit pattern IEEE 754 binary32 без descriptor."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY32-VECTOR хранит подряд interchange bit pattern IEEE 754 binary32 без descriptor.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x00000508`. Семейство NUMERIC.

```
TAG WORD            0000 1001 1101 LLLL      Codec 0x09DL
[Length расш. TAG]  если всего 15 WORD и более
Issuer              2 WORD  0x00000002 (ADHOC)
Номер Codec         2 WORD  0x00000508
Payload: [binary32 bits 1st: 2 WORD] ... [binary32 bits Nth: 2 WORD]
```

## Правила интерпретации {#해석-규칙}

- Два идущих подряд WORD образуют один элемент и читаются начиная со старшего WORD. Битовый образ, включая NaN payload и знаковый ноль, сохраняется без изменений.
- Число элементов равно 1/2 числа WORD в Payload; ABI-заполнения нет.

## Действительность {#유효성}

- Payload должен составлять не менее 2 WORD и быть кратен 2 WORD. Этот формат без descriptor не допускает пустой vector.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Interchange format элементов binary32 следует [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Одномерная непрерывная последовательность без descriptor, TAG/Length GEUL и размещение в 16-битных big-endian WORD — собственный формат GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) предполагает native-endian, поэтому этот Payload не является wire-сериализацией DLPack, Arrow или ONNX.

## Длина {#길이}

- Общая длина — число WORD: TAG 1 WORD, расширяющий TAG Length (если есть), Issuer 2 WORD, номер Codec 2 WORD и Payload. До 14 WORD включительно используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; расширяющий TAG тоже входит в общее число ([Length](../../record.md)).

## Пример {#예시}

- Payload `3F80 0000 8000 0000` — это binary32 `[1.0, -0]`, запись общей длиной 9 WORD.
