---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "记录文档的公开范围。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `ACCESS`（规格文档 BIND `ACCESS`） |
| TAG ID | `0x1DFL` |
| Codec ID | `0x00001DF0` |
| 规格文档 | `0x00000000/codecs/0x00001DF0/`（DECLARE 对象 `1DF0`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 31 |
| Kind | Meta · 类：策略 |
| TAG WORD | `0001 1101 1111 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 公开范围 |
| Hugo 侧 | `meta/policy/access.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | 原始值 1 WORD |  | `0x0000` public, `0x0001` internal, `0x0002` confidential |

记录文档的公开范围。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[Length 扩展 TAG]
等级              1 WORD (0 公开, 1 内部, 2 对外保密, 其余 Reserved)
```

- Codec：Meta `0x1DFL`，策略类
- Payload：原始值（等级 1 WORD）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 对外保密的文档不公布（[Issuer](../issuer.md)）。
- 不改变解释，只规定处理方式。

## 未决问题 {#열린-문제}

- 等级代码表。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001DF0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
