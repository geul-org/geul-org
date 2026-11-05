---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR 是在 Payload descriptor 中记录 shape 与 element format，并存储 C-contiguous row-major payload 的张量 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR 是在 Payload descriptor 中记录 shape 与 element format，并存储 C-contiguous row-major payload 的张量 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000002` ADHOC，Codec 编号 `0x00000600`，系列 NUMERIC。

## 布局 {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 编号        2 WORD  0x00000600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload 其余      [dense payload]
```

## 解释 {#해석}

- rank 是 descriptor 的 4bit 值，所以结构上只能表示 `0..15`。每个 dimension 是非负的 big-endian uint32。
- 如同 ONNX 的逻辑 tensor 规则，rank 0 的 shape `[]` 是只有 1 个元素的 scalar，只要有任一 dimension 为 0，元素数即为 0。除此之外元素数是所有 dimension 之积。
- payload 按 descriptor 的 element format 读取，顺序为 C-contiguous row-major。计算出的逻辑元素数必须与 descriptor 之后 payload 的元素数相同。

## 有效性 {#유효성}

- 一旦确定了所支持的 version 与 element format，就以其元素宽度恢复 payload 边界，并验证其与无 overflow 地计算出的 shape 之积相符。
- descriptor、所有 dimension 和 payload 必须完整地容纳在记录 Length 之内，不存在任意的 ABI padding。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- shape 是非负 dimension 列表、值的个数等于 dimension 之积的规则，以及 rank 0 scalar 与 zero dimension 的含义，遵循 [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html)。C-contiguous row-major 逻辑顺序与 [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html) 的顺序一致。
- 4bit rank、uint32 dimension、version/element-format field、GEUL TAG/Length、big-endian WORD payload 是 GEUL 特有的 descriptor。它们不是 [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html)、ONNX TensorProto、[DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html) 的 wire·memory serialization。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 2 WORD、Codec 编号 2 WORD、Payload 的 WORD 数之和。14 WORD 以下使用直接长度，15 WORD 以上使用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](../../record.md)）。
- descriptor 为 1 WORD，shape 为 `2 × rank` WORD，其余是 payload。

## 示例 {#예시}

- 若是 rank 为 2 的 profile，则 descriptor 之后的 4 WORD 是两个 uint32 dimension，其后全部是 row-major payload。实际是否允许以及元素数的验证，需要确定的 version·format profile。

## 未决问题 {#열린-문제}

- version 与 element-format registry 的取值，以及在可表示的 rank `0..15` 中要支持的 profile 范围，尚未确定。
