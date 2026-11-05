---
title: "REPLACES (0x1D7L)"
weight: 471
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "记录被改写的目标版本的内容哈希（git amend、rebase）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `REPLACES`（规格文档 BIND `REPLACES`） |
| TAG ID | `0x1D7L` |
| Codec ID | `0x00001D70` |
| 规格文档 | `0x00000000/codecs/0x00001D70/`（DECLARE 对象 `1D70`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 23 |
| Kind | Meta · 类：谱系 |
| TAG WORD | `0001 1101 0111 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 被改写的目标版本的内容哈希（git amend、rebase）。不删除原版本。 |
| Hugo 侧 | `meta/lineage/replaces.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | 记录 | `07C0` SHA-256-DIGEST |  |

记录被改写的目标版本的内容哈希（git amend、rebase）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 0111 LLLL      Codec 0x1D7L
[Length 扩展 TAG]
Payload           一个 SHA-256-DIGEST Value (16 WORD)
```

- Codec：Meta `0x1D7L`，谱系类
- Payload：内置 Value（[SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)）
- 数量：可有多个

## 解释与有效性 {#해석과-유효성}

- 不删除原版本（保留旧法）。
- 摘要格式以 Value 内置，为更换哈希算法留有余地。目前内容哈希只有 SHA-256。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001D70/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D7000000000
BODY
#1 DECLARE 0x1D70
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "REPLACES"
#4 BIND #2 "digest"
```
