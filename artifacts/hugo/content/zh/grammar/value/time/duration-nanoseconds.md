---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS 是承载没有 epoch 的 signed int64 nanosecond 经过时间的 Value（GEUL Issuer 格式 0x4000）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS 是没有 epoch 的 signed nanosecond 经过时间。它不是 instant，也不是日历上的月·年期间。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0000` GEUL，格式编号 `0x4000`。系列 TIME。
- 使用与 Arrow `Duration(NANOSECOND)` 相同的固定宽度 signed int64 物理类型。

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  总计 7 WORD
Issuer            1 WORD  0x0000 (GEUL)
格式编号          1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解读与有效性

- 把整个 Payload 4 WORD 读作 big-endian WORD 顺序的 64 位二进制补码 signed 计数。
- 有效范围是 `-2^63`~`2^63-1`ns。符号是经过的方向，不指向特定 epoch 的 instant。
- 即使是很小的值也始终使用 4 WORD。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD 与 Payload 4 WORD 之和，恰好 7 WORD，使用直接长度 `LLLL=0110`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例

- 0ns 是 Payload `0000 0000 0000 0000`，总计 7 WORD，`LLLL=0110`。
- 1ns 是 Payload `0000 0000 0000 0001`。
- -1ns 是 Payload `ffff ffff ffff ffff`。

## 标准依据

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) 指定 `Schema.fbs` 为 Arrow 标准数据类型的 authoritative source。
- 在 Arrow 的 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) 中，`Duration` 是与日历无关的绝对经过时间，支持 NANOSECOND 单位，且始终表示为 8-byte signed integer。GEUL 只在此基础上增加 TAG 和 big-endian 16 位 WORD 分帧。
