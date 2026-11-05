---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 是以 (x, y, z, w) 顺序的 IEEE 754 binary32 四个分量表示 quaternion 的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 是以 `(x, y, z, w)` 顺序的 IEEE 754 binary32 四个分量表示 quaternion 的 Value。Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000002` ADHOC，Codec 编号 `0x00000704`，系列 NUMERIC。

## 布局 {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  总计 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 编号        2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## 解释与有效性 {#해석과-유효성}

- 每个分量是 big-endian WORD 顺序的 binary32 interchange bits。
- frame、handedness、unit norm、`q/-q` 等价性属于外部上下文，不包含在此格式的含义中。
- 保留 NaN payload 和 signed zero bit pattern，没有 ABI padding。
- Payload 恰好是 8 WORD。此格式不强制 unit norm 或 `q/-q` 规范化。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- `x, y, z, w` 顺序与 Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) 的 quaternion 分量顺序相同，每个分量是 [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/)。
- glTF node rotation 要求 W 为 scalar 的 unit quaternion。此格式是不强制 unit norm 或 rotation 含义的一般 quaternion，所以除非外部 profile 追加该条件，否则不能视为与 glTF rotation 相同。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD、Payload 8 WORD 之和，恰好 13 WORD，使用直接长度 `LLLL=1100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例 {#예시}

- 分量 `(0.0, 0.0, 0.0, 1.0)` 是按顺序存储四个 bit pattern 的有效值。
