---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR 是在 element format·rank·shape descriptor 之后承载 C-contiguous row-major 元素的 ADHOC Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR 是在 Payload descriptor 中写明 shape 和 element format，并存放 C-contiguous row-major payload 的张量 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x0600`，系列为 NUMERIC。

## 布局

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload 其余      [dense payload]
```

## 解读

- rank 是 descriptor 的 4bit 值，所以在结构上只能表示 `0..15`。每个 dimension 是非负 big-endian uint32。
- 与 ONNX 的逻辑 tensor 规则一样，rank 0 shape `[]` 是只有 1 个元素的 scalar，只要有一个 dimension 为 0，元素数就是 0。其余情况下元素数是所有 dimension 的乘积。
- payload 按 descriptor 的 element format 读取，顺序为 C-contiguous row-major。计算出的逻辑元素数必须与 descriptor 之后 payload 的元素数相同。

## 有效性

- 一旦确定了支持的 version 和 element format，就用该元素宽度恢复 payload 边界，并验证其与无溢出地计算出的 shape 乘积是否相符。
- descriptor、所有 dimension、payload 必须完整地放入记录 Length 之内，不存在任意的 ABI padding。

## 标准依据与格式地位

- shape 是非负 dimension 列表且值的个数等于 dimension 乘积的规则，以及 rank 0 scalar 和 zero dimension 的含义，遵循 [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html)。C-contiguous row-major 逻辑顺序与 [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html) 的顺序一致。
- 4bit rank、uint32 dimension、version/element-format field、GEUL TAG/Length、big-endian WORD payload 是 GEUL 专有 descriptor。它们不是 [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html)、ONNX TensorProto、[DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html) 的 wire·memory serialization。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 1 WORD、格式编号 1 WORD、Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](/zh/grammar/record/)）。
- descriptor 是 1 WORD，shape 是 `2 × rank` WORD，其余是 payload。

## 示例

- 如果是 rank 为 2 的 profile，则 descriptor 之后的 4 WORD 是两个 uint32 dimension，其后的全部是 row-major payload。实际是否允许以及元素数验证，需要确定的 version·format profile。

## 未决问题

- version 和 element-format registry 的值，以及在可表示的 rank `0..15` 中支持哪个 profile 范围，尚未确定。
