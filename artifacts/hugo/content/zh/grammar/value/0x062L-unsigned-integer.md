---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER 是表示无符号整数值的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `UNSIGNED-INTEGER`（规格文档 BIND `UNSIGNED-INTEGER`） |
| TAG ID | `0x062L` |
| Codec ID | `0x00000620` |
| 规格文档 | `0x00000000/codecs/0x00000620/`（DECLARE 目标 `0620`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 2 |
| Kind | Value · 系列：NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 最小 WORD 的 big-endian unsigned magnitude 整数 |
| Hugo 页面 | `value/numeric/unsigned-integer.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | 剩余原始值（`0xFFFF`） |  |  |

UNSIGNED-INTEGER 是表示无符号整数值的 Value。Value 直接码 `0x062L`，系列为 NUMERIC。Payload 整体按 big-endian WORD 顺序读作任意精度的 unsigned magnitude。Payload 至少 1 WORD，且只允许最小 WORD 的规范表示。

## 布局 {#레이아웃}

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st  (高位 WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (低位 WORD)   Unsigned Magnitude Nth
```

## 解释 {#해석}

- 第一个 Payload WORD 为最高位，最后一个 WORD 为最低位。
- Payload 为 N WORD 时，读作一个 `16N` bit 的 unsigned magnitude。
- 该宽度不是声明的存储宽度，也没有 bit width descriptor。

## 规范表示 {#정규-표현}

- 0 是 Payload 1 WORD `0000`。
- Payload 为 2 WORD 以上时，若第一个 WORD 为 `0000`，去掉后值不变，因此是非规范。
- 解码器必须拒绝带有多余前导 zero WORD 的表示。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG（若有）与 Payload 的 WORD 数之和。14 WORD 以下使用直接长度，15 WORD 以上使用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[记录与 TAG WORD](../record.md)）。
- 不保留 UINT8·UINT16·UINT32 之类的声明宽度，只保留数值。

## 示例 {#예시}

| 值 | Payload WORD | 判定 |
|---:|---|---|
| 0 | `0000` | 规范 |
| 1 | `0001` | 规范 |
| 65535 | `FFFF` | 规范 |
| 65536 | `0001 0000` | 规范 |
| 1 | `0000 0001` | 非规范：多余的前导 `0000` |
| 7 WORD Payload | TAG `0627`（直接长度 `LLLL=0111`，总计 8 WORD）之后的 7 WORD | 规范 |
| 7 WORD Payload | 扩展长度 TAG 与扩展值 `0009` 之后的 7 WORD | 非规范：14 WORD 以下使用直接长度 |

## 格式地位 {#형식-지위}

- 把任意精度 unsigned magnitude 规范化为最小 16 位 WORD 序列并与 GEUL TAG 绑定的这种表示，是 GEUL 专有的 scalar profile。
- 与 UINT8/16/32/64 之类的固定宽度外部类型互换时，需要范围检查和显式的宽度转换。

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000620/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
