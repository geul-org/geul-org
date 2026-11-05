---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS 是没有 epoch 的 signed 秒单位经过时间。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `DURATION-SECONDS`（规格文档 BIND `DURATION-SECONDS`） |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| 规格文档 | `0x00000000/codecs/0x000006D0/`（DECLARE 目标 `06D0`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 13 |
| Kind | Value · 系列：TIME |
| TAG WORD | `0000 0110 1101 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 没有 epoch 的 signed SI-second 经过时间 |
| Hugo 页面 | `value/time/duration-seconds.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | 原始值 4 WORD |  |  |

DURATION-SECONDS 是没有 epoch 的 signed 秒单位经过时间。它不是 instant，也不是日历上的月·年期间。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x06DL`。系列 TIME。
- 使用与 Arrow `Duration(SECOND)` 相同的固定宽度 signed int64 物理类型。

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  总计 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 4 WORD 整体读作 big-endian WORD 顺序的 64 位二进制补码 signed count。
- 有效范围为 `-2^63`~`2^63-1` 秒。符号表示经过的方向，不指向特定 epoch 的 instant。
- 即使数值很小也始终使用 4 WORD。

## 长度 {#길이}

- 总计是 TAG 1 WORD 与 Payload 4 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 则拒绝。

## 示例 {#예시}

- 0 秒的 Payload 为 `0000 0000 0000 0000`，总计 5 WORD，`LLLL=0100`。
- 1 秒的 Payload 为 `0000 0000 0000 0001`。
- -1 秒的 Payload 为 `FFFF FFFF FFFF FFFF`。

## 标准依据 {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) 指定 `Schema.fbs` 为 Arrow 标准数据类型的权威来源。
- 在 Arrow 的权威 [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) 中，`Duration` 是与日历无关的绝对经过时间，支持 SECOND 单位，且始终以 8 字节 signed integer 表示。GEUL 只在此之上加上 TAG 和 big-endian 16 位 WORD framing。

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x000006D0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
