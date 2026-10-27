---
title: "SIGNED-INTEGER"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER 是以最小 WORD 二进制补码承载有符号整数的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-INTEGER 是表示有符号整数值的 Value。Value 直接码 `0x01`，系列为 NUMERIC。把整个 Payload 读作 big-endian WORD 顺序的任意精度二进制补码整数。Payload 至少 1 WORD，且只允许最小 WORD 规范表示。

## 布局

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x01
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st  (高位 WORD)   Integer 1st
...
Payload WORD Nth  (低位 WORD)   Integer Nth
```

## 解读

- 第一个 Payload WORD 的最高位是整个整数的符号位。
- 把所有 Payload WORD 读作一个连续的二进制补码位串。第一个 WORD 是最高位，最后一个 WORD 是最低位。
- Payload 为 N WORD 时，解读宽度为 `16N` bit。这个宽度不是声明的存储宽度，而是由规范表示确定的值的表示宽度。
- 没有 Byte Count 或 bit width descriptor。

## 规范表示

- 0 是 Payload 1 WORD `0000`。
- 禁止不改变值的前导符号扩展 WORD。
- Payload 为 2 WORD 以上时，以下情形为非规范。
  - 第一个 WORD 为 `0000`，且下一个 WORD 的最高位为 0
  - 第一个 WORD 为 `ffff`，且下一个 WORD 的最高位为 1
- 保持正数符号的前导 `0000`，在下一个 WORD 的最高位为 1 时允许。
- 保持负数符号的前导 `ffff`，在下一个 WORD 的最高位为 0 时允许。
- 解码器必须拒绝非规范表示。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](/zh/grammar/record/)）。
- 不保留 INT8·INT16·INT32 这类声明宽度，只保留数值。`-32768`~`32767` 是 1 WORD，超出范围则按需增加 WORD。没有单独的 SIGNED-INT8 格式。

## 示例

| 值 | Payload WORD | 判定 |
|---:|---|---|
| 0 | `0000` | 规范 |
| 1 | `0001` | 规范 |
| 32767 | `7fff` | 规范 |
| 32768 | `0000 8000` | 规范：保持正数符号需要 `0000` |
| -1 | `ffff` | 规范 |
| -32768 | `8000` | 规范 |
| -32769 | `ffff 7fff` | 规范：保持负数符号需要 `ffff` |
| 1 | `0000 0001` | 非规范：不必要的前导 `0000` |
| -1 | `ffff ffff` | 非规范：不必要的前导 `ffff` |

## 格式地位

- 二进制补码是广泛使用的惯例，但把任意精度值规范化为最小 16 位 WORD 序列并与 GEUL TAG 绑定的这种表示，是 GEUL 专有的 scalar profile。
- 与 INT8/16/32/64 这类固定宽度的外部类型交换时，需要范围检查和显式的宽度转换。
