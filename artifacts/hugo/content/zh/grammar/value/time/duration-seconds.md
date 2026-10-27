---
title: "DURATION-SECONDS"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS 是承载没有 epoch 的 signed int64 以秒为单位的经过时间的 Value（Codec 0x23）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-SECONDS 是没有 epoch 的 signed 以秒为单位的经过时间。它不是 instant，也不是日历上的月·年期间。

## 布局

- 码：Value 直接码 `0x23`。系列 TIME。
- 使用与 Arrow `Duration(SECOND)` 相同的固定宽度 signed int64 物理类型。

```
TAG WORD          0x0A23 (0000 1010 0010 0011)  总计 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 解读与有效性

- 把整个 Payload 4 WORD 读作 big-endian WORD 顺序的 64 位二进制补码 signed 计数。
- 有效范围是 `-2^63`~`2^63-1` 秒。符号是经过的方向，不指向特定 epoch 的 instant。
- 即使是很小的值也始终使用 4 WORD。

## 长度

- 总计是 TAG 1 WORD 与 Payload 4 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例

- 0 秒是 Payload `0000 0000 0000 0000`，总计 5 WORD，`LLLL=0100`。
- 1 秒是 Payload `0000 0000 0000 0001`。
- -1 秒是 Payload `ffff ffff ffff ffff`。

## 标准依据

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) 指定 `Schema.fbs` 为 Arrow 标准数据类型的 authoritative source。
- 在 Arrow 的 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) 中，`Duration` 是与日历无关的绝对经过时间，支持 SECOND 单位，且始终表示为 8-byte signed integer。GEUL 只在此基础上增加 TAG 和 big-endian 16 位 WORD 分帧。
