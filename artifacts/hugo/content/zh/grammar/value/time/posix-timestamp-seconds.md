---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS 是承载自 Unix epoch 起的 signed int64 秒数的 Value（Codec 0x22）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS 是自 Unix epoch `1970-01-01T00:00:00Z` 起的 signed 秒数。与 POSIX 的 seconds-since-the-Epoch 一样，把每一天都看作恰好 86,400 秒，不计闰秒。

## 布局

- 码：Value 直接码 `0x22`。系列 TIME。
- 为了产业数据交换，使用与 Arrow `timestamp[s]` 相同的固定宽度 signed int64 物理类型。

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  总计 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 解读与有效性

- 把整个 Payload 4 WORD 读作 big-endian WORD 顺序的 64 位二进制补码 signed 计数。
- 有效范围是 `-2^63`~`2^63-1` 秒。负数是 epoch 之前的 instant。
- 即使是很小的值也始终使用 4 WORD。不得缩减为最小 WORD 整数表示。
- 不承载 timezone、原来的 UTC offset、闰秒 label、leap-second table。

## 长度

- 总计是 TAG 1 WORD 与 Payload 4 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例

- epoch 是 Payload `0000 0000 0000 0000`，总计 5 WORD，`LLLL=0100`。
- epoch 之后 1 秒是 Payload `0000 0000 0000 0001`。
- epoch 之前 1 秒是 Payload `ffff ffff ffff ffff`。

## 标准依据

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) 只定义了 `time_t tv_sec` 和 `long tv_nsec` 成员，没有定义把累计秒数序列化为 signed int64 的 wire format。`time_t` 的具体宽度和表示取决于实现环境，与 GEUL Payload 表示不同。
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) 定义了 epoch 之后秒数与日历的对应以及一天 86,400 秒的规则。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) 和 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) 把 timestamp 定义为自固定 epoch 起的 64 位 signed integer，支持 SECOND 单位，且不计闰秒。GEUL 只在这个物理类型上增加 TAG 和 big-endian 16 位 WORD 分帧。
