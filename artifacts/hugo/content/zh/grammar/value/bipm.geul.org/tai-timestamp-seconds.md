---
title: "TAI-TIMESTAMP-SECONDS"
weight: 1022
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-SECONDS 是自 1970-01-01T00:00:00 TAI 起的 signed SI-second 数。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-SECONDS 是自 `1970-01-01T00:00:00 TAI` 起的 signed SI-second 数。这种累计 count 表示不是 BIPM 标准 wire format，而是将 TAI 时间标度映射到定宽 signed int64 的 GEUL 特有 profile。

## 布局 {#레이아웃}

- 码：Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000013` BIPM，Codec 编号 `0x00004000`。系列 TIME。

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  总计 9 WORD
Issuer            2 WORD  0x00000013 (BIPM)
Codec 编号        2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed SI Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed SI Seconds
Payload WORD 3rd (bits 31..16)     Signed SI Seconds
Payload WORD 4th (bits 15..0)      Signed SI Seconds low 16bit
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 4 WORD 整体读作 big-endian WORD 顺序的 64 位二进制补码 signed count。
- 有效范围是 `-2^63`~`2^63-1` 秒。负数是 GEUL 所定 epoch 之前的 TAI instant。
- 较小的值也始终使用 4 WORD。不存储 UTC offset 或 leap-second table。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Issuer 2 WORD、Codec 编号 2 WORD 与 Payload 4 WORD 之和，恰好 9 WORD，使用直接长度 `LLLL=1000`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例 {#예시}

- GEUL TAI epoch 为 Payload `0000 0000 0000 0000`，总计 9 WORD，`LLLL=1000`。
- epoch 之后 1 秒为 Payload `0000 0000 0000 0001`。
- epoch 之前 1 秒为 Payload `FFFF FFFF FFFF FFFF`。

## 标准依据与形式地位 {#표준-근거와-형식-지위}

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10)规定了 SI second 与 International Atomic Time(TAI) 时间标度。
- BIPM 没有定义自 `1970-01-01 TAI` epoch 起的 signed int64 累计 count 及其 wire encoding。epoch、signed int64 以及 GEUL big-endian WORD 排布是 GEUL 特有的映射。
- 选择定宽 int64 是为了与其他 TIME count profile 保持交换一致性，并不意味着原样复现了 BIPM 格式。
