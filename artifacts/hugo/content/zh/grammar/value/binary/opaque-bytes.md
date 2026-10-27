---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES 是承载自身不规定含义和格式的任意字节序列的 GEUL Issuer 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES 是本格式自身不规定含义和格式的任意字节序列。Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0000` GEUL，格式编号 `0xC000`·`0xC001`（偶数·奇数字节），系列为 BINARY。字节数由格式编号的最低位和 Payload WORD 数决定。是 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](/zh/grammar/value/)）。

## 布局

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            1 WORD  0x0000 (GEUL)
格式编号          1 WORD  0xC000/0xC001
Payload WORD 1st ... Nth   字节 / 末尾 zero padding
```

## 解读与有效性

- 从 Payload 中按字节数依次读取 byte。WORD 内高 byte 在前。
- Payload WORD 数是 `ceil(字节数/2)`。奇数码而最后一个 WORD 的低 byte 不是 `00` 则拒绝。
- 偶数·奇数码、Payload WORD 数、zero padding 相互不一致则拒绝。

## 格式地位

- 奇偶码对、payload 排列、最后一个 WORD 的 zero padding 不是引用外部产业标准，而是 GEUL 专有 framing。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 1 WORD、格式编号 1 WORD、Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](/zh/grammar/record/)）。
- 0 byte 在偶数格式编号（`0xC000`）上，写成没有 Payload 的 3 WORD 记录（TAG、Issuer、格式编号）。

## 示例

byte `ab cd ef` 是 3 byte（奇数），所以格式编号为 `0xC001`，Payload 为 `abcd ef00`。总计 5 WORD，所以 `LLLL=0100`。

```
0A7C 0000 C001 abcd ef00
```
