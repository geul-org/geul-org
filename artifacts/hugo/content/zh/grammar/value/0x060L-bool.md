---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL 是表示逻辑值 false 和 true 的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `BOOL`（规格文档 BIND `BOOL`） |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| 规格文档 | `0x00000000/codecs/0x00000600/`（DECLARE 目标 `0600`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 0 |
| Kind | Value · 系列：NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 固定 1 WORD 的 false 或 true |
| Hugo 页面 | `value/numeric/bool.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | 原始值 1 WORD |  | `0x0000` false, `0x0001` true |

BOOL 是表示逻辑值 false 和 true 的 Value。Value 直接码 `0x060L`，系列为 NUMERIC。它与承载数字 0 和 1 的 SIGNED-INTEGER·UNSIGNED-INTEGER 是不同的类型。

## 布局 {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  总计 2 WORD
Payload           1 WORD  Boolean Code
```

## 解释与有效性 {#해석과-유효성}

- Payload `0000` 是 false，`0001` 是 true。
- 没有 padding 或 descriptor。
- Payload 恰好是 `0000` 或 `0001`。其他 16 位值一律作为 invalid 拒绝。
- 其他 Length 表示一律作为 invalid 拒绝。

## 长度 {#길이}

- 总计是 TAG 1 WORD 与 Payload 1 WORD 之和，恰好 2 WORD，使用直接长度 `LLLL=0001`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 1 WORD 则拒绝。

## 示例 {#예시}

| 完整记录（TAG + Payload） | Payload | 判定 |
|---|---|---|
| `0601 0000` | `0000` | false，规范 |
| `0601 0001` | `0001` | true，规范 |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| Length 不是 `0001` 的 TAG + `0000` 或 `0001` | `0000` 或 `0001` | invalid |

## 格式地位 {#형식-지위}

- 把 `0000`/`0001` 的 16 位 code word 与 GEUL TAG 绑定的这种表示，是 GEUL 专有的 scalar profile。
- 逻辑值本身是通用的，但不主张存在与这种 1 WORD 表示对应的单一工业标准。

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000600/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
