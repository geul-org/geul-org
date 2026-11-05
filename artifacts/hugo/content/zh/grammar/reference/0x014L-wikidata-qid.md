---
title: "WIKIDATA-QID (0x014L~0x018L)"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID 是指向 Wikidata 项目（Item）的声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `WIKIDATA-QID`（5Q 分组。各代码的名称见下方成员表） |
| TAG ID | `0x014L~0x018L` |
| 章节 | 0 `0000`（Reference 实体），章节内偏移 C = 20~24 |
| Kind | Reference · 分类：声明 |
| Hugo 侧 | `reference/wikidata-qid.md` |

## 成员 {#구성원}

本页合并讲述一套 5Q 体系的五个代码。量化由章节内偏移 `C % 5` 决定（[Reference](_index.md#quantifier)）。每个代码各有一份 Codec 文档。五份 Codec 文档的字段相同，只有 DECLARE 目标和名称（BIND）不同。

| TAG ID | 名称 | 量化 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x014L` | `WIKIDATA-QID-IDENTIFIED` | Identified | `0x00000140` | `0x00000000/codecs/0x00000140/` | `0000 0001 0100 LLLL` |
| `0x015L` | `WIKIDATA-QID-GENERIC` | Generic | `0x00000150` | `0x00000000/codecs/0x00000150/` | `0000 0001 0101 LLLL` |
| `0x016L` | `WIKIDATA-QID-FREE-CHOICE` | Free-choice | `0x00000160` | `0x00000000/codecs/0x00000160/` | `0000 0001 0110 LLLL` |
| `0x017L` | `WIKIDATA-QID-UNIVERSAL` | Universal | `0x00000170` | `0x00000000/codecs/0x00000170/` | `0000 0001 0111 LLLL` |
| `0x018L` | `WIKIDATA-QID-VARIABLE` | Variable | `0x00000180` | `0x00000000/codecs/0x00000180/` | `0000 0001 1000 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `qid` | #2 | 剩余原始值（`0xFFFF`） |  |  |

WIKIDATA-QID 是指向 Wikidata 项目（Item）的声明 Reference。去掉 Q 标识符中的 `Q`，把剩下的数字部分写成无符号整数。

## 布局 {#레이아웃}

```
TAG WORD          0000 0001 0100 LLLL      Codec 0x014L~0x018L (Identified 0x014L)
[Length 扩展 TAG]
QID               最短宽度的 unsigned big-endian
```

- QID 用最短宽度书写。`Q1`~`Q65535` 总长为 2 WORD，更大的为 3 WORD。
- Wikidata 的数据是 CC0。
- 为 Variable 时，是该项目所指类别的匿名变量（[Reference](_index.md) Variable）。

## 示例 {#예시}

| 项目 | WORD sequence |
|---|---|
| `Q5` (human) | `0141 0005` |
| `Q76` (Barack Obama) | `0141 004C` |
| `Q884` (South Korea) | `0141 0374` |
| `Q317521` (Elon Musk) | `0142 0004 D851` |
| `Q30461` (president), Variable | `0181 76FD` |

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[WIKIDATA-PID](0x019L-wikidata-pid.md)、[TRIPLE](../edge/0x0AAL-triple.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000140/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000014000000000
BODY
#1 DECLARE 0x0140
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-QID-IDENTIFIED"
#4 BIND #2 "qid"
```

以上是 `WIKIDATA-QID-IDENTIFIED`（`0x014L`）的 Codec 文档。其他成员（`WIKIDATA-QID-GENERIC`、`WIKIDATA-QID-FREE-CHOICE`、`WIKIDATA-QID-UNIVERSAL`、`WIKIDATA-QID-VARIABLE`）的 Codec 文档，只有 DOC-ID 的 Codec ID、DECLARE 目标、`#1` 上绑定的名称（BIND）不同。
