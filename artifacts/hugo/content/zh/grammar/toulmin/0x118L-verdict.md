---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT 是 TOULMIN Edge Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT 是 TOULMIN Edge Codec。含义：节点·记录的判定结果。结果（Pass、Review、Fail）、判定值、Activated、Excluded、Level。

| 项目 | 值 |
|---|---|
| 名称 | `VERDICT`（规格文档 BIND `VERDICT`） |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| 规格文档 | `0x00000000/codecs/0x00001180/`（DECLARE 对象 `1180`） |
| 章节 | 8 `1000`（Edge TOULMIN），章节内偏移 C = 24 |
| Kind | Edge · 系列：TOULMIN，分组：结果 |
| TAG WORD | `0001 0001 1000 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 节点·记录的判定结果。结果（Pass、Review、Fail）、判定值、Activated、Excluded、Level。布局未定 |
| Hugo 侧 | `edge/toulmin/_index.md` |

## 布局 {#레이아웃}

只分配了代码，尚无布局（[TOULMIN](_index.md#열린-문제)）。

- 整个文档的判定由 Meta [VERDICT](../meta/0x1E9L-verdict.md)（`0x1E9L`）负责。两者的 Kind 不同，是各自独立的 Codec。
- 判定结果放在与判定对象不同的文档中（[TOULMIN](_index.md#판정-결과)）。

## Codec 文档 {#코덱-문서}

布局尚未确定。Codec 文档只设有 DECLARE（对象 `1180`）。FIELD 待布局确定后再设。

## 相关页面 {#관련-페이지}

- [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001180/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
