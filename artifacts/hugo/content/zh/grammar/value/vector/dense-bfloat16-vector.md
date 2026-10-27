---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR 是不带 descriptor、连续承载 BF16 元素的一维向量 Value（ADHOC Issuer 格式 0x0507）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR 不带 descriptor，连续存放 bfloat16 16 位元素 bit pattern。它与 binary16 是不同的格式。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x0507`。系列 NUMERIC。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x0507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## 解读规则

- 元素数是 Payload WORD 数。原样保留包括 NaN payload 和 signed zero 在内的 bit pattern。
- 元素之间和末尾没有 ABI padding。

## 有效性

- Payload 必须至少 1 WORD。没有 descriptor 的本格式不允许空 vector。
- Payload 大小必须是元素宽度 1 WORD 的整数倍。

## 标准依据与格式地位

- bfloat16 作为单独的 16 位 dtype，以及与 binary16 的区别，与 [ONNX IR 的 tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) 及 [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html) 保持一致。
- 没有 descriptor 的一维 bit-pattern 连续序列、GEUL TAG/Length 与 16 位 big-endian WORD 布局是 GEUL 专有格式。DLPack 假定 native-endian，所以此 Payload 不是 DLPack、Arrow、ONNX 的 wire serialization。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 1 WORD、格式编号 1 WORD 与 Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](/zh/grammar/record/)）。

## 示例

- Payload `3f80 8000` 是 BF16 `1.0` 和 `-0`，是总计 5 WORD 记录。
