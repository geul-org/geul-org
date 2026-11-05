---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR — тензорное Value: shape и packed format записываются в descriptor Payload, а элементы меньше WORD хранятся в упакованном виде."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR — тензорное Value: shape и packed format записываются в descriptor Payload, а элементы меньше WORD хранятся в упакованном виде. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x00000601`, семейство NUMERIC.

## Раскладка {#레이아웃}

```
TAG WORD            0000 1001 1101 LLLL      Codec 0x09DL
[Length расш. TAG]  если всего 15 WORD и более
Issuer              2 WORD  0x00000002 (ADHOC)
Номер Codec         2 WORD  0x00000601
Payload WORD 1st    [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next        [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload, остаток    [packed payload octet stream, low-bit-first]
```

## Интерпретация {#해석}

- rank — 4-битное значение descriptor, поэтому структурно выразимы только `0..15`. Каждый dimension — неотрицательное big-endian uint32. Логический порядок — C-contiguous row-major.
- Как и в логических правилах tensor в ONNX, shape `[]` с rank 0 — это scalar из одного элемента, а если хотя бы один dimension равен 0, число элементов равно 0. В остальных случаях число элементов — произведение всех dimension.
- packed-format фиксирует кодирование элемента и ширину в битах, как у int2/int4, FP4/FP6 и отдельных вариантов FP8.
- Пусть последовательность octet payload — `p[0], p[1], ...`, а little-bit-endian целое — `P = Σ(p[j] << (8j))`; тогда логический элемент `i` шириной `w` равен `(P >> (i × w)) & ((1 << w) - 1)`. То есть с первого элемента значения кладутся начиная с самых младших битов.
- В WORD `p[0]` помещается в старший octet первого WORD, `p[1]` — в младший octet и так далее. Неиспользуемые старшие tail bit последнего используемого octet должны быть равны 0, а если число octet payload нечётно, весь неиспользуемый младший octet последнего WORD должен быть `00`.

## Действительность {#유효성}

- Произведение dimension shape, вычисленное без overflow с учётом битовой ширины поддерживаемого format, должно совпадать с числом элементов payload.
- Если хотя бы один high tail bit за пределами нужных бит payload или octet-заполнение равен 1, значение отклоняется. Descriptor, shape и payload должны полностью умещаться в Length записи.

## Стандартные основания и формальный статус {#표준-근거와-형식-지위}

- Логический смысл shape, scalar с rank 0 и нулевого dimension следует [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Правило размещения sub-byte элементов начиная с младших бит следует int2/int4 packing в официальной [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) и little bit-endian packing в [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- 4-битный rank, uint32 dimension, поля version/packed-format, способ объединения octet в big-endian WORD и TAG/Length GEUL — собственный descriptor GEUL. Это не wire- и не memory-сериализация ONNX, [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) или самого DLPack.

## Длина {#길이}

- Общая длина — число WORD: TAG 1 WORD, расширяющий TAG Length (если есть), Issuer 2 WORD, номер Codec 2 WORD и Payload. До 14 WORD включительно используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; расширяющий TAG тоже входит в общее число ([Запись и TAG WORD](../../record.md)).
- Descriptor занимает 1 WORD, shape — `2 × rank` WORD, остальное — packed payload.
- Если число логических элементов равно `N`, а ширина элемента `w`, то число octet payload равно `ceil(N × w / 8)`, а число WORD payload — `ceil(число octet payload / 2)`.

## Пример {#예시}

- В profile с rank 2 четыре WORD после descriptor — это shape, а дальше идёт последовательность octet payload в порядке low-bit-first. Ширина элемента и допустимость определяются утверждённым format profile.
- Последовательность octet payload для 4-битных элементов `[1, 2, 3]` — `21 03`, а WORD payload — `2103`. Первый элемент находится в младшем nibble первого octet, а неиспользуемый старший nibble последнего octet равен 0.

## Открытые проблемы {#열린-문제}

- Значения registry для version и packed-format, а также диапазон поддерживаемых profile среди выразимых rank `0..15` пока не определены.
