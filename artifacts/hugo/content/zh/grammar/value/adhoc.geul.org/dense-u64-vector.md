---
title: "DENSE-U64-VECTOR"
weight: 1014
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U64-VECTOR 是不带 descriptor、连续存储 big-endian uint64 元素的同质一维 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U64-VECTOR 是不带 descriptor、连续存储 big-endian uint64 元素的同质一维 Value。

## 布局 {#레이아웃}

- 码：Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000002` ADHOC，Codec 编号 `0x00000505`。系列 NUMERIC。

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 编号        2 WORD  0x00000505
Payload: [uint64 1st: 4 WORD] ... [uint64 Nth: 4 WORD]
```

## 解释规则 {#해석-규칙}

- 将连续的 4 WORD 从高位 WORD 起结合，读作 unsigned 64 位整数。
- 元素数是 Payload WORD 数的 1/4，没有 ABI padding。

## 有效性 {#유효성}

- Payload 必须至少 4 WORD，且是 4 WORD 的整数倍。没有 descriptor 的此格式不允许空 vector。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- unsigned integer dtype 的 unsigned 解释与 64 位宽度对齐 [ONNX IR 的 tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) 及 [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) 的行业 dtype。
- 无 descriptor 的一维连续序列、GEUL TAG/Length 以及 big-endian WORD 排布是 GEUL 特有的格式。DLPack 假定 dtype 为 native-endian，所以此 Payload 不是 DLPack 或 ONNX 的 wire serialization。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 2 WORD、Codec 编号 2 WORD 与 Payload 的 WORD 数之和。14 WORD 以下使用直接长度，15 WORD 以上使用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](../../record.md)）。

## 示例 {#예시}

- Payload `0000 0000 0000 0001` 是元素 `[1]`，是总计 9 WORD 的记录。
