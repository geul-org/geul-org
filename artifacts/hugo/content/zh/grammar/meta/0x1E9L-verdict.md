---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "记录整个文档的判定结果。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `VERDICT`（规格文档 BIND `VERDICT`） |
| TAG ID | `0x1E9L` |
| Codec ID | `0x00001E90` |
| 规格文档 | `0x00000000/codecs/0x00001E90/`（DECLARE 对象 `1E90`） |
| 章节 | 15 `1111`（Meta），章节内偏移 C = 9 |
| Kind | Meta · 类：验证 |
| TAG WORD | `0001 1110 1001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 整个文档的判定结果。Pass、Review、Fail。节点、记录级的见 [TOULMIN](../toulmin/_index.md) `VERDICT`（Edge `0x118L`） |
| Hugo 侧 | `meta/verification/verdict.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | 原始值 1 WORD |  | `0x0000` pass, `0x0001` review, `0x0002` fail |

记录整个文档的判定结果。节点、记录级的判定由 [TOULMIN](../toulmin/_index.md) `VERDICT`（Edge `0x118L`）负责。

## 布局 {#레이아웃}

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[Length 扩展 TAG]
判定              1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec：Meta `0x1E9L`，验证类
- Payload：原始值（判定 1 WORD）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 属于验证类，因此不计入内容哈希。
- 对其他文档的判定，放在不同于判定对象的另一个文档的 BODY 中。

## 未决问题 {#열린-문제}

- 是否一并记录判定主体与依据。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001E90/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
