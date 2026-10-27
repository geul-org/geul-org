---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR — формат Issuer ADHOC, в котором после descriptor с element format, rank и shape идут элементы в C-contiguous порядке row-major."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR — это тензорный Value: shape и element format записаны в descriptor Payload, а сам Payload хранится в C-contiguous порядке row-major. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0600`, семейство NUMERIC.

## Раскладка

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] если всего 15 WORD и более
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload остаток   [dense payload]
```

## Интерпретация

- rank — 4-битное значение descriptor, поэтому структурно представимы только `0..15`. Каждый dimension — неотрицательный big-endian uint32.
- Как и в логических правилах tensor в ONNX, shape `[]` с rank 0 — это scalar из одного элемента, а если хотя бы один dimension равен 0, число элементов равно 0. В остальных случаях число элементов — произведение всех dimension.
- Payload читается по element format из descriptor в C-contiguous порядке row-major. Вычисленное логическое число элементов должно совпадать с числом элементов в Payload после descriptor.

## Допустимость

- Когда заданы поддерживаемые version и element format, границы Payload восстанавливаются по ширине элемента и сверяются с произведением shape, вычисленным без overflow.
- Descriptor, все dimension и Payload должны целиком помещаться в Length записи; произвольного ABI padding нет.

## Основание в стандартах и статус формата

- Правило, что shape — список неотрицательных dimension, а число значений равно произведению dimension, и смысл scalar с rank 0 и нулевого dimension следуют [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). C-contiguous логический порядок row-major согласован с порядком [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- 4-битный rank, uint32 dimension, поля version/element-format, GEUL TAG/Length и big-endian WORD Payload — собственный descriptor GEUL. Это не wire- и не memory-сериализация [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), ONNX TensorProto или [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть), Issuer 1 WORD, номер формата 1 WORD и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`/`1111`, и extension TAG тоже входит в общее число ([Запись и TAG WORD](/ru/grammar/record/)).
- Descriptor занимает 1 WORD, shape — `2 × rank` WORD, остальное — Payload.

## Пример

- Для profile с rank 2 после descriptor идут 4 WORD — два uint32 dimension, а всё, что за ними, — Payload row-major. Для проверки допустимости и числа элементов нужен утверждённый profile version и format.

## Открытые вопросы

- Значения реестров version и element-format, а также диапазон поддерживаемых profile среди представимых rank `0..15` пока не определены.
