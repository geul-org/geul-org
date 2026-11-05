---
title: "OPAQUE-BYTES (0x07EL·0x07FL)"
weight: 126
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES 是含义和格式不由本格式自身规定的任意字节序列。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES 是含义和格式不由本格式自身规定的任意字节序列。Value 直接码 `0x07EL`（偶数字节）·`0x07FL`（奇数字节），系列 BINARY。字节数由 Codec 的最低位和 Payload WORD 数决定。即 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](_index.md)）。

| 项目 | 值 |
|---|---|
| 名称 | `OPAQUE-BYTES`（奇偶分组。各代码的名称见下方成员表） |
| TAG ID | `0x07EL`·`0x07FL` |
| 章节 | 3 `0011`（Value），章节内偏移 C = 30~31 |
| Kind | Value · 系列：BINARY |
| 索引说明 | 含义·格式不明的字节序列。偶数·奇数字节 |
| Hugo 路径 | `value/binary/opaque-bytes.md` |

## 成员 {#구성원}

本页同时处理奇偶一对的两个代码。偶数代码的值字节数为偶数，奇数代码的值字节数为奇数（[记录与 TAG WORD](../record.md#가변-길이-바이트열)）。Codec 文档每个代码一份。两份 Codec 文档的字段相同，只有 DECLARE 对象和名称（BIND）不同。

| TAG ID | 名称 | 字节数 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x07EL` | `OPAQUE-BYTES-EVEN` | 偶数 | `0x000007E0` | `0x00000000/codecs/0x000007E0/` | `0000 0111 1110 LLLL` |
| `0x07FL` | `OPAQUE-BYTES-ODD` | 奇数 | `0x000007F0` | `0x00000000/codecs/0x000007F0/` | `0000 0111 1111 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 剩余原始值（`0xFFFF`） |  |  |

## 布局 {#레이아웃}

```
TAG WORD          0000 0111 111P LLLL      Codec 0x07EL/0x07FL
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth   字节 / 最后 zero padding
```

## 解释与有效性 {#해석과-유효성}

- 从 Payload 依次读取字节数个 byte。WORD 内高位 byte 在前。
- Payload WORD 数为 `ceil(字节数/2)`。若为奇数代码而最后一个 WORD 的低位 byte 不是 `00`，则拒绝。
- 偶数·奇数代码、Payload WORD 数、zero padding 互相不一致时拒绝。

## 格式地位 {#형식-지위}

- 奇偶代码对（`0x07EL` 偶数，`0x07FL` 奇数）、payload 排布、最后 WORD 的 zero padding 并非引用外部工业标准，而是 GEUL 特有的 framing。

## 长度 {#길이}

- 总长为 TAG 1 WORD、Length 扩展 TAG（如有）与 Payload 的 WORD 数之和。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](../record.md)）。
- 0 byte 写成偶数代码（`0x07EL`）的 1 WORD 记录（仅 TAG WORD）（[Value](_index.md)）。

## 示例 {#예시}

byte `AB CD EF` 为 3 byte（奇数），因此是 `OPAQUE-BYTES-ODD`（`0x07FL`），Payload 为 `ABCD EF00`。总计 3 WORD，因此 `LLLL=0010`。

```
07F2 ABCD EF00
```

空字节序列是 `07E0`（`OPAQUE-BYTES-EVEN`，仅 TAG WORD）1 WORD。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x000007E0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007E000000000
BODY
#1 DECLARE 0x07E0
#2 FIELD #1 rest
#3 BIND #1 "OPAQUE-BYTES-EVEN"
#4 BIND #2 "bytes"
```

以上是 `OPAQUE-BYTES-EVEN`（`0x07EL`）的 Codec 文档。其他成员（`OPAQUE-BYTES-ODD`）的 Codec 文档只在 DOC-ID 的 Codec ID、DECLARE 对象、`#1` 绑定的名称（BIND）上不同。
