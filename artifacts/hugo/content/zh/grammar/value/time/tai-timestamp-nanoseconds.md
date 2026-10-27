---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS 是承载自 1970-01-01T00:00:00 TAI 起的 signed nanosecond 数的 Value（BIPM Issuer 格式 0x4001）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS 是自同一个 TAI epoch `1970-01-01T00:00:00 TAI` 起的 signed nanosecond 数。这种累计 count 表示不是 BIPM 标准 wire format，而是把 TAI 时间尺度映射到固定宽度 signed int64 的 GEUL 专有 profile。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0060` BIPM，格式编号 `0x4001`。系列 TIME。

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  总计 7 WORD
Issuer            1 WORD  0x0060 (BIPM)
格式编号          1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解读与有效性

- 把整个 Payload 4 WORD 读作 big-endian WORD 顺序的 64 位二进制补码 signed 计数。
- 有效范围是 `-2^63`~`2^63-1`ns。负数是 GEUL 所定 epoch 之前的 TAI instant。
- 即使是很小的值也始终使用 4 WORD。不存储 UTC offset 或 leap-second table。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD 与 Payload 4 WORD 之和，恰好 7 WORD，使用直接长度 `LLLL=0110`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例

- GEUL TAI epoch 是 Payload `0000 0000 0000 0000`，总计 7 WORD，`LLLL=0110`。
- epoch 之后 1ns 是 Payload `0000 0000 0000 0001`。
- epoch 之前 1ns 是 Payload `ffff ffff ffff ffff`。

## 标准依据与格式地位

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) 规定了 SI second 和 International Atomic Time（TAI）时间尺度。
- BIPM 没有定义自 `1970-01-01 TAI` epoch 起的 signed int64 累计 nanosecond 及其 wire encoding。epoch、按单位的 count、signed int64 与 GEUL big-endian WORD 布局，是 GEUL 专有映射。
- 选择固定宽度 int64 是为了与其他 TIME count profile 保持交换一致性，并不意味着原样复现了 BIPM 格式。
