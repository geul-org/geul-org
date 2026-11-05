---
title: "WIKIDATA-PID (0x019L~0x01DL)"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID 是指向 Wikidata 属性（Property）的声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `WIKIDATA-PID`（5Q 分组。各代码的名称见下方成员表） |
| TAG ID | `0x019L~0x01DL` |
| 章节 | 0 `0000`（Reference 实体），章节内偏移 C = 25~29 |
| Kind | Reference · 分类：声明 |
| Hugo 侧 | `reference/wikidata-pid.md` |

## 成员 {#구성원}

本页合并讲述一套 5Q 体系的五个代码。量化由章节内偏移 `C % 5` 决定（[Reference](_index.md#quantifier)）。每个代码各有一份 Codec 文档。五份 Codec 文档的字段相同，只有 DECLARE 目标和名称（BIND）不同。

| TAG ID | 名称 | 量化 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x019L` | `WIKIDATA-PID-IDENTIFIED` | Identified | `0x00000190` | `0x00000000/codecs/0x00000190/` | `0000 0001 1001 LLLL` |
| `0x01AL` | `WIKIDATA-PID-GENERIC` | Generic | `0x000001A0` | `0x00000000/codecs/0x000001A0/` | `0000 0001 1010 LLLL` |
| `0x01BL` | `WIKIDATA-PID-FREE-CHOICE` | Free-choice | `0x000001B0` | `0x00000000/codecs/0x000001B0/` | `0000 0001 1011 LLLL` |
| `0x01CL` | `WIKIDATA-PID-UNIVERSAL` | Universal | `0x000001C0` | `0x00000000/codecs/0x000001C0/` | `0000 0001 1100 LLLL` |
| `0x01DL` | `WIKIDATA-PID-VARIABLE` | Variable | `0x000001D0` | `0x00000000/codecs/0x000001D0/` | `0000 0001 1101 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `pid` | #2 | 剩余原始值（`0xFFFF`） |  |  |

WIKIDATA-PID 是指向 Wikidata 属性（Property）的声明 Reference。去掉 P 标识符中的 `P`，把剩下的数字部分写成无符号整数。

## 布局 {#레이아웃}

```
TAG WORD          0000 0001 1001 LLLL      Codec 0x019L~0x01DL (Identified 0x019L)
[Length 扩展 TAG]
PID               最短宽度的 unsigned big-endian
```

- PID 用最短宽度书写。目前的属性编号能放进 1 WORD，总长为 2 WORD；超过 65535 时自然扩展为 3 WORD。
- 主要用在 [TRIPLE](../edge/0x0AAL-triple.md) 的 Predicate、[QUALIFIER](../edge/0x0ABL-qualifier.md) 的 Property 位置。

## 示例 {#예시}

| 属性 | WORD sequence |
|---|---|
| `P31` (instance of) | `0191 001F` |
| `P279` (subclass of) | `0191 0117` |
| `P569` (date of birth) | `0191 0239` |

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[WIKIDATA-QID](0x014L-wikidata-qid.md)、[TRIPLE](../edge/0x0AAL-triple.md)、[QUALIFIER](../edge/0x0ABL-qualifier.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000190/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000019000000000
BODY
#1 DECLARE 0x0190
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-PID-IDENTIFIED"
#4 BIND #2 "pid"
```

以上是 `WIKIDATA-PID-IDENTIFIED`（`0x019L`）的 Codec 文档。其他成员（`WIKIDATA-PID-GENERIC`、`WIKIDATA-PID-FREE-CHOICE`、`WIKIDATA-PID-UNIVERSAL`、`WIKIDATA-PID-VARIABLE`）的 Codec 文档，只有 DOC-ID 的 Codec ID、DECLARE 目标、`#1` 上绑定的名称（BIND）不同。
