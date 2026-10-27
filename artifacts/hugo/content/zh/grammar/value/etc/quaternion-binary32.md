---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 是用 (x, y, z, w) 顺序的 binary32 四个分量承载 quaternion 的固定 11 WORD ADHOC Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 是用 `(x, y, z, w)` 顺序的四个 IEEE 754 binary32 分量表示 quaternion 的 Value。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x0704`，系列为 NUMERIC。

## 布局

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  总计 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## 解读与有效性

- 每个分量是 big-endian WORD 顺序的 binary32 interchange bits。
- frame、handedness、unit norm、`q/-q` 等价性属于外部上下文，不包含在本格式的含义中。
- 保留 NaN payload 和 signed zero 的 bit pattern，没有 ABI padding。
- Payload 恰好是 8 WORD。本格式不强制 unit norm 或 `q/-q` 规范化。

## 标准依据与格式地位

- `x, y, z, w` 顺序与 Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) 的 quaternion 分量顺序相同，每个分量是 [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/)。
- glTF node rotation 要求 W 为 scalar 的 unit quaternion。本格式是不强制 unit norm 或 rotation 含义的一般 quaternion，所以除非外部 profile 另外增加该条件，否则不能认为它与 glTF rotation 相同。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD、Payload 8 WORD 之和，恰好 11 WORD，使用直接长度 `LLLL=1010`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 8 WORD 则拒绝。

## 示例

- 分量 `(0.0, 0.0, 0.0, 1.0)` 是按顺序存放四个 bit pattern 的有效值。
