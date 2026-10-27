---
title: "DENSE-BINARY64-VECTOR"
weight: 1010
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY64-VECTOR 是不带 descriptor、连续承载 binary64 元素的一维向量 Value（ADHOC Issuer 格式 0x0509）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY64-VECTOR 是不带 descriptor、连续存放 IEEE 754 binary64 interchange bit pattern。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x0509`。系列 NUMERIC。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x0509
Payload: [binary64 bits 1st: 4 WORD] ... [binary64 bits Nth: 4 WORD]
```

## 解读规则

- 连续的 4 WORD 是一个元素，从高位 WORD 起读取。原样保留包括 NaN payload 和 signed zero 在内的 bit pattern。
- 元素数是 Payload WORD 数的 1/4，没有 ABI padding。

## 有效性

- Payload 必须至少 4 WORD，且是 4 WORD 的整数倍。没有 descriptor 的本格式不允许空 vector。

## 标准依据与格式地位

- binary64 元素的 interchange format 遵循 [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/)。
- 没有 descriptor 的一维连续序列、GEUL TAG/Length 与 16 位 big-endian WORD 布局是 GEUL 专有格式。[DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) 假定 native-endian，所以此 Payload 不是 DLPack、Arrow、ONNX 的 wire serialization。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 1 WORD、格式编号 1 WORD 与 Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](/zh/grammar/record/)）。

## 示例

- Payload `3ff0 0000 0000 0000` 是 binary64 `[1.0]`，是总计 7 WORD 记录。
