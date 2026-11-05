---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1023
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS 是自 GPS epoch 1980-01-06T00:00:00 GPS 起的 signed nanosecond 数。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS 是自 GPS epoch `1980-01-06T00:00:00 GPS` 起的 signed nanosecond 数。不按 GPS week 编号拆分，也不按 broadcast field 的 week rollover 宽度截断。

这种累计 count 表示不是 IS-GPS-200 broadcast wire format，而是将 GPS 时间标度映射到定宽 signed int64 的 GEUL 特有 profile。

## 布局 {#레이아웃}

- 码：Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000016` GPS，Codec 编号 `0x00004001`。系列 TIME。

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  总计 9 WORD
Issuer            2 WORD  0x00000016 (GPS)
Codec 编号        2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 4 WORD 整体读作 big-endian WORD 顺序的 64 位二进制补码 signed count。
- 有效范围是 `-2^63`~`2^63-1`ns。负数是 GPS epoch 之前的 GPS-time instant。
- count 是自 epoch 起连续的值。不应用 broadcast week-number field 的 truncation 或 rollover。
- 较小的值也始终使用 4 WORD。不包含 UTC 转换参数。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD 与 Payload 4 WORD 之和，恰好 9 WORD，使用直接长度 `LLLL=1000`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例 {#예시}

- GPS epoch 为 Payload `0000 0000 0000 0000`，总计 9 WORD，`LLLL=1000`。
- epoch 之后 1ns 为 Payload `0000 0000 0000 0001`。
- epoch 之前 1ns 为 Payload `FFFF FFFF FFFF FFFF`。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation)是 GPS 接口规格的官方发布处。
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf)规定 GPS time 是连续时间标度，week 0 始于 1980-01-06 午夜，并定义了 GPS week number 与 time-of-week/Z-count broadcast field。
- IS-GPS-200 没有定义自 epoch 起的累计 nanosecond signed int64 wire representation。以 nanosecond 为单位、无 rollover 的连续 count、signed int64 以及 GEUL big-endian WORD 排布是 GEUL 特有的映射。
