---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN 是 TOULMIN Edge Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN 是 TOULMIN Edge Codec。含义：优先级链 `A > B > C`。逐对 SUPERSEDES 的缩写。

| 项目 | 值 |
|---|---|
| 名称 | `SUPERSEDE-CHAIN`（规格文档 BIND `SUPERSEDE-CHAIN`） |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| 规格文档 | `0x00000000/codecs/0x000010A0/`（DECLARE 对象 `10A0`） |
| 章节 | 8 `1000`（Edge TOULMIN），章节内偏移 C = 10 |
| Kind | Edge · 系列：TOULMIN，分组：关系 |
| TAG WORD | `0001 0000 1010 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 优先级链 `A > B > C`。逐对 SUPERSEDES 的缩写。布局未定 |
| Hugo 侧 | `edge/toulmin/_index.md` |

## 布局 {#레이아웃}

只分配了代码，尚无布局（[TOULMIN](_index.md#열린-문제)）。

- 目前每一对写一条 [SUPERSEDES](0x109L-supersedes.md)。这样是否足以表达链，是未决问题。

## Codec 文档 {#코덱-문서}

布局尚未确定。Codec 文档只设有 DECLARE（对象 `10A0`）。FIELD 待布局确定后再设。

## 相关页面 {#관련-페이지}

- [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x000010A0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
