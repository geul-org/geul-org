---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR — тензорное Value: shape и element format записываются в descriptor Payload, а затем следует payload в C-contiguous row-major порядке."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR — тензорное Value: shape и element format записываются в descriptor Payload, а затем следует payload в C-contiguous row-major порядке. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x00000600`, семейство NUMERIC.

## Раскладка {#레이아웃}

```
TAG WORD            0000 1001 1101 LLLL      Codec 0x09DL
[Length расш. TAG]  если всего 15 WORD и более
Issuer              2 WORD  0x00000002 (ADHOC)
Номер Codec         2 WORD  0x00000600
Payload WORD 1st    [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next        [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload, остаток    [dense payload]
```

## Интерпретация {#해석}

- rank — 4-битное значение descriptor, поэтому структурно выразимы только `0..15`. Каждый dimension — неотрицательное big-endian uint32.
- Как и в логических правилах tensor в ONNX, shape `[]` с rank 0 — это scalar из одного элемента, а если хотя бы один dimension равен 0, число элементов равно 0. В остальных случаях число элементов — произведение всех dimension.
- payload читается в element format из descriptor в C-contiguous row-major порядке. Вычисленное логическое число элементов должно совпадать с числом элементов payload после descriptor.

## Действительность {#유효성}

- Когда поддерживаемые version и element format определены, границы payload восстанавливаются по ширине элемента и сверяются с произведением shape, вычисленным без overflow.
- Descriptor, все dimension и payload должны полностью умещаться в Length записи; произвольного ABI-заполнения нет.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Правило, по которому shape — список неотрицательных dimension, а число значений равно произведению dimension, а также смысл scalar с rank 0 и нулевого dimension следуют [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Логический порядок C-contiguous row-major согласован с порядком [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- 4-битный rank, uint32 dimension, поля version/element-format, TAG/Length GEUL и payload в big-endian WORD — собственный descriptor GEUL. Это не wire- и не memory-сериализация [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), ONNX TensorProto или [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Длина {#길이}

- Общая длина — число WORD: TAG 1 WORD, расширяющий TAG Length (если есть), Issuer 2 WORD, номер Codec 2 WORD и Payload. До 14 WORD включительно используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; расширяющий TAG тоже входит в общее число ([Запись и TAG WORD](../../record.md)).
- Descriptor занимает 1 WORD, shape — `2 × rank` WORD, остальное — payload.

## Пример {#예시}

- В profile с rank 2 четыре WORD после descriptor — два uint32 dimension, а всё дальше — row-major payload. Для проверки допустимости и числа элементов нужен утверждённый profile version и format.

## Открытые проблемы {#열린-문제}

- Значения registry для version и element-format, а также диапазон поддерживаемых profile среди выразимых rank `0..15` пока не определены.
