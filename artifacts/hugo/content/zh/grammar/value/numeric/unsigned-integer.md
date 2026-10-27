---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER 是以最小 WORD big-endian magnitude 承载无符号整数的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER 是表示无符号整数值的 Value。Value 直接码 `0x02`，系列为 NUMERIC。把整个 Payload 读作 big-endian WORD 顺序的任意精度 unsigned magnitude。Payload 至少 1 WORD，且只允许最小 WORD 规范表示。

## 布局

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st  (高位 WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (低位 WORD)   Unsigned Magnitude Nth
```

## 解读

- 第一个 Payload WORD 是最高位，最后一个 WORD 是最低位。
- Payload 为 N WORD 时，读作一个 `16N` bit 的 unsigned magnitude。
- 这个宽度不是声明的存储宽度，也没有 bit width descriptor。

## 规范表示

- 0 是 Payload 1 WORD `0000`。
- Payload 为 2 WORD 以上时，如果第一个 WORD 是 `0000`，去掉后值不变，所以是非规范。
- 解码器必须拒绝带有不必要前导 zero WORD 的表示。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](/zh/grammar/record/)）。
- 不保留 UINT8·UINT16·UINT32 这类声明宽度，只保留数值。

## 示例

| 值 | Payload WORD | 判定 |
|---:|---|---|
| 0 | `0000` | 规范 |
| 1 | `0001` | 规范 |
| 65535 | `ffff` | 规范 |
| 65536 | `0001 0000` | 规范 |
| 1 | `0000 0001` | 非规范：不必要的前导 `0000` |
| 7 WORD Payload | TAG `0b82`（直接长度 `LLLL=0111`，总计 8 WORD）之后的 7 WORD | 规范 |
| 7 WORD Payload | 扩展长度 TAG 和扩展值 `0009` 之后的 7 WORD | 非规范：14 WORD 以下用直接长度 |

## 格式地位

- 把任意精度 unsigned magnitude 规范化为最小 16 位 WORD 序列并与 GEUL TAG 绑定的这种表示，是 GEUL 专有的 scalar profile。
- 与 UINT8/16/32/64 这类固定宽度的外部类型交换时，需要范围检查和显式的宽度转换。
