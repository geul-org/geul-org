---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "声明文档所应用的 profile。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `PROFILE`（规格文档 BIND `PROFILE`） |
| TAG ID | `0x1C6L` |
| Codec ID | `0x00001C60` |
| 规格文档 | `0x00000000/codecs/0x00001C60/`（DECLARE 对象 `1C60`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 6 |
| Kind | Meta · 类：定义 |
| TAG WORD | `0001 1100 0110 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 所应用的 profile |
| Hugo 侧 | `meta/declaration/profile.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | 记录 | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

声明文档所应用的 profile。同样的记录按 profile 所规定的 Codec 文档来解释（例：若为 `tangeul-1.0`，则是 [TOULMIN](../toulmin/_index.md)）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[Length 扩展 TAG]
Payload           UTF8-TEXT Value "<名称>-<major>.<minor>"
```

- Codec：Meta `0x1C6L`，定义类
- Payload：内置 Value（[UTF8-TEXT](../value/0x072L-utf8-text.md)）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- major 不同的 profile 拒绝。允许 minor 的差异（仅限新增的变更）。
- 没有 profile 时，仅凭 GEUL 基本语法和直接码规格来读取。

## 示例 {#예시}

- `tangeul-1.0`：`0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## 未决问题 {#열린-문제}

- profile 名称注册表（geul.org）与命名规则。
- profile 是用文档 ID 指向（IMPORT），还是以文本放置。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001C60/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
