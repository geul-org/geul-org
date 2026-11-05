---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL 是指向 geul.org 以 CC0 签发的实体的声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `GEUL`（5Q 分组。各代码的名称见下方成员表） |
| TAG ID | `0x00AL~0x00EL` |
| 章节 | 0 `0000`（Reference 实体），章节内偏移 C = 10~14 |
| Kind | Reference · 分类：声明 |
| Hugo 侧 | `reference/geul.md` |

## 成员 {#구성원}

本页合并讲述一套 5Q 体系的五个代码。量化由章节内偏移 `C % 5` 决定（[Reference](_index.md#quantifier)）。每个代码各有一份 Codec 文档。五份 Codec 文档的字段相同，只有 DECLARE 目标和名称（BIND）不同。

| TAG ID | 名称 | 量化 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | 剩余原始值（`0xFFFF`） |  |  |

GEUL 是指向 geul.org 以 CC0 签发的实体的声明 Reference。它是编号本身不承载含义的顺序 ID。在比特中承载含义的标识符由另一个 Codec [GEUL-SIDX](0x00FL-geul-sidx.md)（`0x00FL~0x013L`）负责。

## 布局 {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[Length 扩展 TAG]
GEUL ID           最短宽度的 unsigned big-endian
```

- 小编号分配给高频实体。能放进 1 WORD 的 ID，总长为 2 WORD。
- ID 分配和注册表由 geul.org 管理。注册表中只放来自 CC0 来源的内容。
- 为 Variable 时，是该类别的匿名变量（[Reference](_index.md) Variable）。

## 示例 {#예시}

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## 未决问题 {#열린-문제}

- GEUL ID 的分配规则和注册表的公开格式。

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[GEUL-SIDX](0x00FL-geul-sidx.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x000000A0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

以上是 `GEUL-IDENTIFIED`（`0x00AL`）的 Codec 文档。其他成员（`GEUL-GENERIC`、`GEUL-FREE-CHOICE`、`GEUL-UNIVERSAL`、`GEUL-VARIABLE`）的 Codec 文档，只有 DOC-ID 的 Codec ID、DECLARE 目标、`#1` 上绑定的名称（BIND）不同。
