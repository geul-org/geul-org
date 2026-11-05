---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS 是没有 epoch 的 signed nanosecond 经过时间。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS 是没有 epoch 的 signed nanosecond 经过时间。它不是 instant，也不是日历上的月·年期间。

| 项目 | 值 |
|---|---|
| 名称 | `DURATION-NANOSECONDS`（规格文档 BIND `DURATION-NANOSECONDS`） |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| 规格文档 | `0x00000000/codecs/0x00000810/`（DECLARE 对象 `0810`） |
| 章节 | 4 `0100`（Value），章节内偏移 C = 1 |
| Kind | Value · 系列：TIME |
| TAG WORD | `0000 1000 0001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 没有 epoch 的 signed nanosecond 经过时间 |
| Hugo 路径 | `value/time/duration-nanoseconds.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | 原始值 4 WORD |  |  |

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x081L`。系列 TIME。
- 使用与 Arrow `Duration(NANOSECOND)` 相同的定宽 signed int64 物理类型。

```
TAG WORD          0x0814 (0000 1000 0001 0100)  总计 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 4 WORD 整体按 big-endian WORD 顺序读作 64 位补码 signed count。
- 有效范围是 `-2^63`~`2^63-1`ns。符号表示经过的方向，不指向特定 epoch 的 instant。
- 即使是很小的值也始终使用 4 WORD。

## 长度 {#길이}

- 总长为 TAG 1 WORD 与 Payload 4 WORD 之和，恰好 5 WORD，使用直接长度 `LLLL=0100`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 4 WORD 时拒绝。

## 示例 {#예시}

- 0ns 的 Payload 为 `0000 0000 0000 0000`，总计 5 WORD，`LLLL=0100`。整体为 `0814 0000 0000 0000 0000`。
- 1ns 的 Payload 为 `0000 0000 0000 0001`。
- -1ns 的 Payload 为 `FFFF FFFF FFFF FFFF`。

## 标准依据 {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) 指定 `Schema.fbs` 为 Arrow 标准数据类型的 authoritative source。
- 在 Arrow 的 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) 中，`Duration` 是与日历无关的绝对经过时间，支持 NANOSECOND 单位，且始终以 8-byte signed integer 表示。GEUL 只在其上增加 TAG 和 big-endian 16 位 WORD framing。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000810/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
