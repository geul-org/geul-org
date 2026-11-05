---
title: "COMPLEX128"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 是以 (real, imag) 顺序的 IEEE 754 binary64 两个分量表示复数的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 是以 `(real, imag)` 顺序的 IEEE 754 binary64 两个分量表示复数的 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000002` ADHOC，Codec 编号 `0x00000701`，系列 NUMERIC。

## 布局 {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  总计 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 编号        2 WORD  0x00000701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## 解释与有效性 {#해석과-유효성}

- 每个分量是 big-endian WORD 顺序的 binary64 interchange bits。
- 包括 NaN payload 和 signed zero 在内的 bit pattern 原样保留，没有 ABI padding。
- Payload 恰好是 8 WORD。保留两个 binary64 分量的所有 interchange bit pattern。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- `complex128` 由 64bit real 分量与 64bit imaginary 分量构成，这一含义遵循 [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html)，real-first 顺序与官方 [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) 的 complex raw-data mapping 相同。每个分量的 bit pattern 遵循 [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)。
- ONNX raw data 是 fixed-width little-endian，而此格式使用 GEUL big-endian WORD framing，所以它本身不是 ONNX TensorProto wire serialization。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 8 WORD 之和，恰好 13 WORD，使用直接长度 `LLLL=1100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例 {#예시}

- Payload 的两个 binary64 为 `1.0, -0.0`，则是实部 1.0、虚部 -0.0 的值。
