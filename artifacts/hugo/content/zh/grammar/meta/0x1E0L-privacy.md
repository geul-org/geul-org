---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "记录文档的个人信息等级。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `PRIVACY`（规格文档 BIND `PRIVACY`） |
| TAG ID | `0x1E0L` |
| Codec ID | `0x00001E00` |
| 规格文档 | `0x00000000/codecs/0x00001E00/`（DECLARE 对象 `1E00`） |
| 章节 | 15 `1111`（Meta），章节内偏移 C = 0 |
| Kind | Meta · 类：策略 |
| TAG WORD | `0001 1110 0000 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 个人信息等级 |
| Hugo 侧 | `meta/policy/privacy.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | 原始值 1 WORD |  |  |

记录文档的个人信息等级。

## 布局 {#레이아웃}

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[Length 扩展 TAG]
等级              1 WORD
```

- Codec：Meta `0x1E0L`，策略类
- Payload：原始值（等级 1 WORD）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 不改变解释，只规定处理方式。

## 未决问题 {#열린-문제}

- 等级代码表（与个人信息保护法分类的对应）。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001E00/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
