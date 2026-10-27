---
title: "COMPLEX64"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 是用实部·虚部 binary32 两个分量承载复数的固定 7 WORD ADHOC Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 是用 `(real, imag)` 顺序的两个 IEEE 754 binary32 分量表示复数的 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x0700`，系列为 NUMERIC。

## 布局

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  总计 7 WORD
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x0700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## 解读与有效性

- 每个分量是 big-endian WORD 顺序的 binary32 interchange bits。
- 原样保留包括 NaN payload 和 signed zero 在内的 bit pattern，没有 ABI padding。
- Payload 恰好是 4 WORD。保留两个 binary32 分量的所有 interchange bit pattern。

## 标准依据与格式地位

- `complex64` 由 32bit real 分量和 32bit imaginary 分量构成，这一含义遵循 [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html)，real-first 顺序与官方 [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) 的 complex raw-data mapping 相同。每个分量的 bit pattern 遵循 [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/)。
- ONNX raw data 是 fixed-width little-endian，而本格式使用 GEUL big-endian WORD framing，所以它本身不是 ONNX TensorProto wire serialization。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 4 WORD 之和，恰好 7 WORD，使用直接长度 `LLLL=0110`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例

- Payload `3f80 0000 4000 0000` 是 `1.0 + 2.0i`。
