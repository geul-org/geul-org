---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR 是在 Payload descriptor 中记录 shape 与 packed format，并以 packed 方式存储小于 WORD 的元素的张量 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR 是在 Payload descriptor 中记录 shape 与 packed format，并以 packed 方式存储小于 WORD 的元素的张量 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000002` ADHOC，Codec 编号 `0x00000601`，系列 NUMERIC。

## 布局 {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 编号        2 WORD  0x00000601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload 其余      [packed payload octet stream, low-bit-first]
```

## 解释 {#해석}

- rank 是 descriptor 的 4bit 值，所以结构上只能表示 `0..15`。每个 dimension 是非负的 big-endian uint32。逻辑顺序为 C-contiguous row-major。
- 如同 ONNX 的逻辑 tensor 规则，rank 0 的 shape `[]` 是只有 1 个元素的 scalar，只要有任一 dimension 为 0，元素数即为 0。除此之外元素数是所有 dimension 之积。
- packed-format 固定了 int2/int4、FP4/FP6、特定 FP8 variant 等元素的 encoding 与 bit 宽度。
- 将 payload octet sequence 记为 `p[0], p[1], ...`，并视为 little-bit-endian 整数 `P = Σ(p[j] << (8j))`，则宽度为 `w` 的逻辑元素 `i` 为 `(P >> (i × w)) & ((1 << w) - 1)`。即从第一个元素起放入最低位的 bit。
- 在 WORD 中，`p[0]` 作为第一个 WORD 的高位 octet，`p[1]` 作为低位 octet，依此类推。最后一个已用 octet 中未使用的高位 tail bit 必须为 0，payload octet 数为奇数时，最后一个 WORD 中未使用的低位 octet 必须整体为 `00`。

## 有效性 {#유효성}

- 应用所支持 format 的 bit 宽度后，无 overflow 地计算出的 shape 的 dimension 之积必须与 payload 元素数相符。
- 所需 payload bit 之后的 high tail bit 或 octet padding 只要有一个为 1，即予以拒绝。descriptor、shape、payload 必须完整地容纳在记录 Length 之内。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- shape、rank 0 scalar、zero dimension 的逻辑含义遵循 [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html)。将 sub-byte 元素从低位 bit 开始放置的规则，遵循官方 [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) 的 int2/int4 packing 与 [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) 的 little bit-endian packing。
- 4bit rank、uint32 dimension、version/packed-format field、将 octet 组成 big-endian WORD 的方式、GEUL TAG/Length 是 GEUL 特有的 descriptor。它们不是 ONNX、[Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html)、DLPack 本身的 wire·memory serialization。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 2 WORD、Codec 编号 2 WORD、Payload 的 WORD 数之和。14 WORD 以下使用直接长度，15 WORD 以上使用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](../../record.md)）。
- descriptor 为 1 WORD，shape 为 `2 × rank` WORD，其余是 packed payload。
- 若逻辑元素数为 `N`、元素宽度为 `w`，则 payload octet 数为 `ceil(N × w / 8)`，payload WORD 数为 `ceil(payload octet 数 / 2)`。

## 示例 {#예시}

- 若是 rank 为 2 的 profile，则 descriptor 之后的 4 WORD 是 shape，其后是 low-bit-first 的 payload octet sequence。元素宽度与实际是否允许，由确定的 format profile 判断。
- 4bit 元素 `[1, 2, 3]` 的 payload octet sequence 是 `21 03`，payload WORD 是 `2103`。第一个元素位于第一个 octet 的低 nibble，最后一个 octet 中未使用的高 nibble 为 0。

## 未决问题 {#열린-문제}

- version 与 packed-format registry 的取值，以及在可表示的 rank `0..15` 中要支持的 profile 范围，尚未确定。
