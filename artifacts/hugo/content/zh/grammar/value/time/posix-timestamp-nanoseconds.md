---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS 是承载自 Unix epoch 起的 signed int64 nanosecond 数的 Value（IEEE Issuer 格式 0x4000）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS 是自 Unix epoch `1970-01-01T00:00:00Z` 起的 signed nanosecond 数。与 POSIX 的 seconds-since-the-Epoch 一样，把每一天都看作恰好 86,400 秒，不计闰秒。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0040` IEEE，格式编号 `0x4000`。系列 TIME。
- 为了产业数据交换，使用与 Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` 相同的固定宽度 signed int64 物理类型。

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  总计 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
格式编号          1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解读与有效性

- 把整个 Payload 4 WORD 读作 big-endian WORD 顺序的 64 位二进制补码 signed 计数。
- 有效范围是 `-2^63`~`2^63-1`ns，instant 范围是 `1677-09-21 00:12:43.145224192Z`~`2262-04-11 23:47:16.854775807Z`。
- 即使是很小的值也始终使用 4 WORD。不得缩减为最小 WORD 整数表示。
- 不承载 timezone、原来的 UTC offset、闰秒 label、leap-second table。

## 长度

- 总计是 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD 与 Payload 4 WORD 之和，恰好 7 WORD，使用直接长度 `LLLL=0110`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例

- epoch 是 Payload `0000 0000 0000 0000`，总计 7 WORD，`LLLL=0110`。
- epoch 之后 1ns 是 Payload `0000 0000 0000 0001`。
- epoch 之前 1ns 是 Payload `ffff ffff ffff ffff`。

## 标准依据

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) 定义了 `time_t tv_sec` 和 `long tv_nsec` 成员，以及 `0 <= tv_nsec < 10^9`。`time_t` 的具体宽度和表示取决于实现环境，没有定义把两个成员合并的累计 nanosecond signed int64 wire format。
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) 把一天看作恰好 86,400 秒。
- [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) 的 `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` 把自 Unix epoch 起的 nanosecond 存放在单个 `int64` 中。GEUL 只在这个物理类型上增加 TAG 和 big-endian 16 位 WORD 分帧。
