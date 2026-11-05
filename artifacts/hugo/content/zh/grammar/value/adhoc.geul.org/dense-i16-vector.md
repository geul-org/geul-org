---
title: "DENSE-I16-VECTOR"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I16-VECTOR 是不带 descriptor、连续存储 big-endian int16 元素的同质一维 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I16-VECTOR 是不带 descriptor、连续存储 big-endian int16 元素的同质一维 Value。

## 布局 {#레이아웃}

- 码：Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000002` ADHOC，Codec 编号 `0x00000500`。系列 NUMERIC。

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 编号        2 WORD  0x00000500
Payload: [int16 1st: 1 WORD] ... [int16 Nth: 1 WORD]
```

## 解释规则 {#해석-규칙}

- 将每个 WORD 读作独立的 16 位二进制补码整数。元素数是 Payload 的 WORD 数。
- 元素之间和末尾没有 ABI padding。

## 有效性 {#유효성}

- Payload 必须至少 1 WORD。没有 descriptor 的此格式不允许空 vector。
- Payload 大小必须是元素宽度 1 WORD 的整数倍。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- signed integer dtype 的 signedness 与 16 位宽度对齐 [ONNX IR 的 tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) 及 [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) 的行业 dtype。
- 二进制补码解释、无 descriptor 的一维连续序列、GEUL TAG/Length 以及 big-endian WORD 排布是 GEUL 特有的格式。DLPack 假定 dtype 为 native-endian，所以此 Payload 不是 DLPack 或 ONNX 的 wire serialization。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 2 WORD、Codec 编号 2 WORD 与 Payload 的 WORD 数之和。14 WORD 以下使用直接长度，15 WORD 以上使用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](../../record.md)）。

## 示例 {#예시}

- Payload `FFFF 0002` 是元素 `[-1, 2]`，是直接长度 `LLLL=0110`、总计 7 WORD 的记录。
