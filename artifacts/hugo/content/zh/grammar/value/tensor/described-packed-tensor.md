---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR 是在 packed format·rank·shape descriptor 之后，以 low-bit-first 填入 sub-WORD 元素的 ADHOC Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR 是在 Payload descriptor 中写明 shape 和 packed format，并以 packed 方式存放比 WORD 更小的元素的张量 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x0601`，系列为 NUMERIC。

## 布局

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload 其余      [packed payload octet stream, low-bit-first]
```

## 解读

- rank 是 descriptor 的 4bit 值，所以在结构上只能表示 `0..15`。每个 dimension 是非负 big-endian uint32。逻辑顺序为 C-contiguous row-major。
- 与 ONNX 的逻辑 tensor 规则一样，rank 0 shape `[]` 是只有 1 个元素的 scalar，只要有一个 dimension 为 0，元素数就是 0。其余情况下元素数是所有 dimension 的乘积。
- packed-format 像 int2/int4、FP4/FP6、特定 FP8 variant 那样，固定元素 encoding 和 bit 宽度。
- 设 payload octet sequence 为 `p[0], p[1], ...`，视为 little-bit-endian 整数 `P = Σ(p[j] << (8j))`，则宽度为 `w` 的逻辑元素 `i` 是 `(P >> (i × w)) & ((1 << w) - 1)`。也就是说，从第一个元素起放在最低位。
- 装入 WORD 时，把 `p[0]` 放在第一个 WORD 的高 octet，`p[1]` 放在低 octet，依此类推。最后一个已用 octet 中未使用的高位 tail bit 必须为 0，且 payload octet 数为奇数时，最后一个 WORD 中未使用的低 octet 必须全部为 `00`。

## 有效性

- 应用所支持 format 的 bit 宽度后，无溢出地计算出的 shape 的 dimension 乘积必须与 payload 元素数相符。
- 所需 payload bit 之后的 high tail bit 或 octet padding 只要有一个为 1 就拒绝。descriptor、shape、payload 必须完整地放入记录 Length 之内。

## 标准依据与格式地位

- shape、rank 0 scalar、zero dimension 的逻辑含义遵循 [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html)。把 sub-byte 元素从低位 bit 开始放置的规则，遵循官方 [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) 的 int2/int4 packing 以及 [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) 的 little bit-endian packing。
- 4bit rank、uint32 dimension、version/packed-format field、把 octet 打包成 big-endian WORD 的方式、GEUL TAG/Length 是 GEUL 专有 descriptor。它们不是 ONNX、[Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html)、DLPack 自身的 wire·memory serialization。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 1 WORD、格式编号 1 WORD、Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](/zh/grammar/record/)）。
- descriptor 是 1 WORD，shape 是 `2 × rank` WORD，其余是 packed payload。
- 逻辑元素数为 `N`、元素宽度为 `w` 时，payload octet 数是 `ceil(N × w / 8)`，payload WORD 数是 `ceil(payload octet 数 / 2)`。

## 示例

- 如果是 rank 为 2 的 profile，则 descriptor 之后的 4 WORD 是 shape，其后是 low-bit-first payload octet sequence。元素宽度和实际是否允许，由确定的 format profile 判断。
- 4bit 元素 `[1, 2, 3]` 的 payload octet sequence 是 `21 03`，payload WORD 是 `2103`。第一个元素在第一个 octet 的低 nibble，最后一个 octet 中未使用的高 nibble 为 0。

## 未决问题

- version 和 packed-format registry 的值，以及在可表示的 rank `0..15` 中支持哪个 profile 范围，尚未确定。
