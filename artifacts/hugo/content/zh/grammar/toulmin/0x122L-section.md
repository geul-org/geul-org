---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION 是 TOULMIN 文档的原文·分段记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION 是 TOULMIN 文档的原文·分段记录。含义：章节开始。

| 项目 | 值 |
|---|---|
| 名称 | `SECTION`（规格文档 BIND `SECTION`） |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| 规格文档 | `0x00000000/codecs/0x00001220/`（DECLARE 对象 `1220`） |
| 章节 | 9 `1001`（Edge TOULMIN 形式），章节内偏移 C = 2 |
| Kind | Edge · 系列：TOULMIN 形式，布局：ID, 章节代码 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 章节开始 |
| Hugo 侧 | `edge/toulmin/source.md` |

## 布局 {#레이아웃}

章节的开始。章节代码为 1 WORD。

```
ID
章节代码         1 WORD
```

| 代码 | 章节 | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | 条件式规则 |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- 不使用 `0`。章节按此代码顺序声明。
- 章节标题是紧跟在 SECTION 之后的 [PROSE](0x125L-prose.md)。

- ID 是 Edge Id，REF 是此文档记录的 Edge Id（[TOULMIN](_index.md#공통-필드) 公共字段）。没有 Issuer 和 Codec 编号栏，TAG 之后直接是 Payload。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1220`）。字段声明与 TOULMIN Codec 规格文档一并确定（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [SOURCE 与分段](_index.md#source와-구획), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001220/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
