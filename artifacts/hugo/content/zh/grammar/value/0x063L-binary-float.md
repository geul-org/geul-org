---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT 是表示 IEEE 754 binary interchange scalar 的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `BINARY-FLOAT`（规格文档 BIND `BINARY-FLOAT`） |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| 规格文档 | `0x00000000/codecs/0x00000630/`（DECLARE 目标 `0630`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 3 |
| Kind | Value · 系列：NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | Payload 为 1/2/4/8 WORD 的 IEEE 754 binary16/32/64/128 scalar |
| Hugo 页面 | `value/numeric/binary-float.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | 剩余原始值（`0xFFFF`） |  |  |

BINARY-FLOAT 是表示 IEEE 754 binary interchange scalar 的 Value。Value 直接码 `0x063L`，系列为 NUMERIC。Payload 为 1/2/4/8 WORD 时，分别是 binary16/32/64/128。原样保留 interchange 位串，不允许其他 Payload 大小。

## 布局 {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st  (高位 WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (低位 WORD)   IEEE Binary Interchange Nth
```

## 解释 {#해석}

- 将 Payload WORD 按 big-endian 顺序连接，读作对应宽度的 IEEE 754 binary interchange 位串。
- 保留包括 NaN payload 和 signed zero 在内的 interchange 位模式。
- 解码器不得把 NaN 替换为任意某个规范 NaN，也不得抹去 signed zero 的符号。
- 舍入方式和算术行为不由这种序列化格式规定。

## 长度 {#길이}

总计是 TAG 1 WORD、Length 扩展 TAG（若有）与 Payload 的 WORD 数之和（[记录与 TAG WORD](../record.md)）。

| 格式 | Payload | Length 码 | Length 扩展 TAG | 总计 Length |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | 无 | 2 WORD |
| binary32 | 2 WORD | `0010` | 无 | 3 WORD |
| binary64 | 4 WORD | `0100` | 无 | 5 WORD |
| binary128 | 8 WORD | `1000` | 无 | 9 WORD |

binary128 同样处于 1~14 WORD 的直接范围内，因此不使用 Length 扩展 TAG。

## 有效性 {#유효성}

- Payload 恰好是 1、2、4、8 WORD 之一。
- 各 Payload 大小必须与上表的 Length 表示完全吻合。
- 不允许改变宽度的重新编码，也不允许在 Payload 前后加 padding WORD。

## 示例 {#예시}

| 格式 | TAG | Length 扩展 TAG | Payload 示例 | 判定 |
|---|---|---|---|---|
| binary16 | `0631` | 无 | `0000` | 规范 |
| binary32 | `0632` | 无 | `0000 0000` | 规范 |
| binary64 | `0634` | 无 | `0000 0000 0000 0000` | 规范 |
| binary128 | `0638` | 无 | 8 WORD 位串 | 规范 |
| 任意 | 与 Length 所示大小不一致 | 任意 | 任意 | invalid |

## 标准依据 {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/)：采用 binary16、binary32、binary64、binary128 interchange encoding。GEUL 只在该位串之上加上 TAG 和 16 位 WORD big-endian framing。

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000630/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
