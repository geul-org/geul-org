---
title: "DENSE-I16-VECTOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I16-VECTOR 是不带 descriptor、连续承载 big-endian int16 元素的一维向量 Value（ADHOC Issuer 格式 0x0500）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I16-VECTOR 是不带 descriptor、连续存放 big-endian int16 元素的同质一维 Value。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x0500`。系列 NUMERIC。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x0500
Payload: [int16 1st: 1 WORD] ... [int16 Nth: 1 WORD]
```

## 解读规则

- 把每个 WORD 读作独立的 16 位二进制补码整数。元素数是 Payload WORD 数。
- 元素之间和末尾没有 ABI padding。

## 有效性

- Payload 必须至少 1 WORD。没有 descriptor 的本格式不允许空 vector。
- Payload 大小必须是元素宽度 1 WORD 的整数倍。

## 标准依据与格式地位

- signed integer dtype 的 signedness 和 16 位宽度，与 [ONNX IR 的 tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) 及 [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) 的产业 dtype 保持一致。
- 二进制补码解读、没有 descriptor 的一维连续序列、GEUL TAG/Length 与 big-endian WORD 布局是 GEUL 专有格式。DLPack 假定 dtype 为 native-endian，所以此 Payload 不是 DLPack 或 ONNX 的 wire serialization。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 1 WORD、格式编号 1 WORD 与 Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](/zh/grammar/record/)）。

## 示例

- Payload `ffff 0002` 是元素 `[-1, 2]`，是直接长度 `LLLL=0100` 的总计 5 WORD 记录。
