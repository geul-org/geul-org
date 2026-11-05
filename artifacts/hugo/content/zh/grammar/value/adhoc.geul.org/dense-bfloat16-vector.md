---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR 不带 descriptor，连续存储 bfloat16 16 位元素的 bit pattern。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR 不带 descriptor，连续存储 bfloat16 16 位元素的 bit pattern。它与 binary16 是不同的格式。

## 布局 {#레이아웃}

- 码：Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000002` ADHOC，Codec 编号 `0x00000507`。系列 NUMERIC。

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 编号        2 WORD  0x00000507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## 解释规则 {#해석-규칙}

- 元素数是 Payload 的 WORD 数。包括 NaN payload 和 signed zero 在内的 bit pattern 原样保留。
- 元素之间和末尾没有 ABI padding。

## 有效性 {#유효성}

- Payload 必须至少 1 WORD。没有 descriptor 的此格式不允许空 vector。
- Payload 大小必须是元素宽度 1 WORD 的整数倍。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- bfloat16 这一独立的 16 位 dtype 及其与 binary16 的区分，对齐 [ONNX IR 的 tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) 和 [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html)。
- 无 descriptor 的一维 bit-pattern 连续序列、GEUL TAG/Length 以及 16 位 big-endian WORD 排布是 GEUL 特有的格式。DLPack 假定 native-endian，所以此 Payload 不是 DLPack、Arrow、ONNX 的 wire serialization。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 2 WORD、Codec 编号 2 WORD 与 Payload 的 WORD 数之和。14 WORD 以下使用直接长度，15 WORD 以上使用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](../../record.md)）。

## 示例 {#예시}

- Payload `3F80 8000` 是 BF16 `1.0` 与 `-0`，是总计 7 WORD 的记录。
