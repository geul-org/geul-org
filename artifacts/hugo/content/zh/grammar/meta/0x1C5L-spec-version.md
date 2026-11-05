---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "声明文档所遵循的 GEUL 规范版本。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `SPEC-VERSION`（规格文档 BIND `SPEC-VERSION`） |
| TAG ID | `0x1C5L` |
| Codec ID | `0x00001C50` |
| 规格文档 | `0x00000000/codecs/0x00001C50/`（DECLARE 对象 `1C50`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 5 |
| Kind | Meta · 类：定义 |
| TAG WORD | `0001 1100 0101 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 所遵循的 GEUL 规范版本。Payload 本身就是最短宽度的 unsigned 整数。v1 为 `0x0001`（记录 `0x1C51 0x0001`） |
| Hugo 侧 | `meta/declaration/spec-version.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | 剩余原始值（`0xFFFF`） |  |  |

声明文档所遵循的 GEUL 规范版本。其余记录如何解读，由该值决定。

## 布局 {#레이아웃}

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[Length 扩展 TAG]
Payload           规范版本。v1 = 0x0001
```

- Codec：Meta `0x1C5L`，定义类
- Payload：原始值（最短宽度的 unsigned 整数）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 不依赖 Value 代码。为了让任何版本的解码器都能读取，不使用内置 Value，只放整数。
- 遇到不认识的版本，解码器拒绝或发出警告。
- 若没有，解码器按其所知的版本读取。公布的文档要写明。

## 示例 {#예시}

- `0x1C51 0x0001`：GEUL v1

## 未决问题 {#열린-문제}

- 与 Codec 手册文档版本的对应（[规格文档](../codec-spec.md)）。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001C50/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
