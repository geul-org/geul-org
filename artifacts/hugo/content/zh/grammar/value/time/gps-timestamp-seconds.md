---
title: "GPS-TIMESTAMP-SECONDS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-SECONDS 是承载自 GPS epoch 1980-01-06T00:00:00 GPS 起的 signed second 数的 Value（GPS Issuer 格式 0x4000）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-SECONDS 是自 GPS epoch `1980-01-06T00:00:00 GPS` 起的 signed second 数。不按 GPS week 编号拆分，也不按 broadcast field 的 week rollover 宽度截断。

这种累计 count 表示不是 IS-GPS-200 broadcast wire format，而是把 GPS 时间尺度映射到固定宽度 signed int64 的 GEUL 专有 profile。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0063` GPS，格式编号 `0x4000`。系列 TIME。

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  总计 7 WORD
Issuer            1 WORD  0x0063 (GPS)
格式编号          1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 解读与有效性

- 把整个 Payload 4 WORD 读作 big-endian WORD 顺序的 64 位二进制补码 signed 计数。
- 有效范围是 `-2^63`~`2^63-1` 秒。负数是 GPS epoch 之前的 GPS-time instant。
- count 是从 epoch 起连续的值。不应用 broadcast week-number field 的 truncation 或 rollover。
- 即使是很小的值也始终使用 4 WORD。不承载 UTC 转换参数。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD 与 Payload 4 WORD 之和，恰好 7 WORD，使用直接长度 `LLLL=0110`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例

- GPS epoch 是 Payload `0000 0000 0000 0000`，总计 7 WORD，`LLLL=0110`。
- epoch 之后 1 秒是 Payload `0000 0000 0000 0001`。
- epoch 之前 1 秒是 Payload `ffff ffff ffff ffff`。

## 标准依据与格式地位

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) 是 GPS 接口规范的官方发布处。
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) 规定 GPS time 是连续时间尺度，week 0 从 1980-01-06 午夜开始，并定义了 GPS week number 和 time-of-week/Z-count broadcast field。
- IS-GPS-200 没有定义现行的自 epoch 起累计 signed int64 wire representation。不应用 rollover 的连续 count，以及 signed int64 与 GEUL big-endian WORD 布局，是 GEUL 专有映射。
