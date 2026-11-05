---
title: "POSIX-TIMESTAMP-SECONDS (0x06CL)"
weight: 108
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS 是自 Unix epoch 1970-01-01T00:00:00Z 起的 signed 秒数。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `POSIX-TIMESTAMP-SECONDS`（规格文档 BIND `POSIX-TIMESTAMP-SECONDS`） |
| TAG ID | `0x06CL` |
| Codec ID | `0x000006C0` |
| 规格文档 | `0x00000000/codecs/0x000006C0/`（DECLARE 目标 `06C0`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 12 |
| Kind | Value · 系列：TIME |
| TAG WORD | `0000 0110 1100 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 自 Unix/POSIX epoch 起的 signed 秒计数 |
| Hugo 页面 | `value/time/posix-timestamp-seconds.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | 原始值 4 WORD |  |  |

POSIX-TIMESTAMP-SECONDS 是自 Unix epoch `1970-01-01T00:00:00Z` 起的 signed 秒数。与 POSIX 的 seconds-since-the-Epoch 一样，把每一天都精确地视为 86,400 秒，不计闰秒。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x06CL`。系列 TIME。
- 为了工业数据交换，使用与 Arrow `timestamp[s]` 相同的固定宽度 signed int64 物理类型。

```
TAG WORD          0x06C4 (0000 0110 1100 0100)  总计 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 4 WORD 整体读作 big-endian WORD 顺序的 64 位二进制补码 signed count。
- 有效范围为 `-2^63`~`2^63-1` 秒。负数是 epoch 之前的 instant。
- 即使数值很小也始终使用 4 WORD。不得缩减为最小 WORD 整数表示。
- 不承载 timezone、原始 UTC offset、闰秒 label、leap-second table。

## 长度 {#길이}

- 总计是 TAG 1 WORD 与 Payload 4 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例 {#예시}

- epoch 的 Payload 为 `0000 0000 0000 0000`，总计 5 WORD，`LLLL=0100`。
- epoch 之后 1 秒的 Payload 为 `0000 0000 0000 0001`。
- epoch 之前 1 秒的 Payload 为 `FFFF FFFF FFFF FFFF`。

## 标准依据 {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) 只定义了 `time_t tv_sec` 与 `long tv_nsec` 成员，并未定义把累计秒数序列化为 signed int64 的 wire format。`time_t` 的具体宽度和表示取决于实现环境，与 GEUL Payload 表示不同。
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) 定义了 epoch 之后的秒数与日历的对应以及每天 86,400 秒的规则。
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) 与权威的 [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) 将 timestamp 定义为自固定 epoch 起的 64 位 signed integer，支持 SECOND 单位，且不计闰秒。GEUL 只在该物理类型上加上 TAG 和 big-endian 16 位 WORD framing。

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x000006C0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006C000000000
BODY
#1 DECLARE 0x06C0
#2 FIELD #1 0x0004
#3 BIND #1 "POSIX-TIMESTAMP-SECONDS"
#4 BIND #2 "seconds"
```
