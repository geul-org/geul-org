---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR — формат Issuer ADHOC, в котором после descriptor с packed format, rank и shape идут sub-WORD элементы, упакованные по принципу low-bit-first."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR — это тензорный Value: shape и packed format записаны в descriptor Payload, а элементы, меньшие WORD, хранятся упакованно. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0601`, семейство NUMERIC.

## Раскладка

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] если всего 15 WORD и более
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload остаток   [packed payload octet stream, low-bit-first]
```

## Интерпретация

- rank — 4-битное значение descriptor, поэтому структурно представимы только `0..15`. Каждый dimension — неотрицательный big-endian uint32. Логический порядок — C-contiguous row-major.
- Как и в логических правилах tensor в ONNX, shape `[]` с rank 0 — это scalar из одного элемента, а если хотя бы один dimension равен 0, число элементов равно 0. В остальных случаях число элементов — произведение всех dimension.
- packed-format фиксирует кодирование элемента и ширину в bit, как у int2/int4, FP4/FP6 и отдельных вариантов FP8.
- Пусть последовательность octet Payload — `p[0], p[1], ...`, а целое little-bit-endian — `P = Σ(p[j] << (8j))`. Тогда логический элемент `i` шириной `w` равен `(P >> (i × w)) & ((1 << w) - 1)`. То есть первый элемент кладётся в самые младшие биты.
- В WORD `p[0]` ставится старшим octet первого WORD, `p[1]` — младшим octet. Неиспользуемые старшие tail bit последнего использованного octet должны быть 0, а если число octet Payload нечётное, весь неиспользуемый младший octet последнего WORD должен быть `00`.

## Допустимость

- При применении ширины bit поддерживаемого format произведение dimension shape, вычисленное без overflow, должно совпадать с числом элементов Payload.
- Если хоть один high tail bit или octet padding после нужных bit Payload равен 1, значение отклоняется. Descriptor, shape и Payload должны целиком помещаться в Length записи.

## Основание в стандартах и статус формата

- Логический смысл shape, scalar с rank 0 и нулевого dimension следует [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Правило размещения sub-byte элементов с младших bit следует упаковке int2/int4 в официальной [схеме ONNX TensorProto](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) и little bit-endian упаковке в [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- 4-битный rank, uint32 dimension, поля version/packed-format, способ объединения octet в big-endian WORD и GEUL TAG/Length — собственный descriptor GEUL. Это не wire- и не memory-сериализация самих ONNX, [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) и DLPack.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть), Issuer 1 WORD, номер формата 1 WORD и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`/`1111`, и extension TAG тоже входит в общее число ([Запись и TAG WORD](/ru/grammar/record/)).
- Descriptor занимает 1 WORD, shape — `2 × rank` WORD, остальное — packed Payload.
- Если число логических элементов равно `N`, а ширина элемента — `w`, то число octet Payload равно `ceil(N × w / 8)`, а число WORD Payload — `ceil(число octet Payload / 2)`.

## Примеры

- Для profile с rank 2 после descriptor идут 4 WORD shape, а за ними — последовательность octet Payload в порядке low-bit-first. Ширина элемента и допустимость определяются утверждённым format profile.
- Для 4-битных элементов `[1, 2, 3]` последовательность octet Payload — `21 03`, а WORD Payload — `2103`. Первый элемент лежит в младшем nibble первого octet, а неиспользуемый старший nibble последнего octet равен 0.

## Открытые вопросы

- Значения реестров version и packed-format, а также диапазон поддерживаемых profile среди представимых rank `0..15` пока не определены.
