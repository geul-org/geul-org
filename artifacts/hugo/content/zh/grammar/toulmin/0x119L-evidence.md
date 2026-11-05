---
title: "EVIDENCE (0x119L)"
weight: 281
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EVIDENCE 是 TOULMIN Edge Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EVIDENCE 是 TOULMIN Edge Codec。含义：判定的证据。位置、期望值、实际值（Fact）。

| 项目 | 值 |
|---|---|
| 名称 | `EVIDENCE`（规格文档 BIND `EVIDENCE`） |
| TAG ID | `0x119L` |
| Codec ID | `0x00001190` |
| 规格文档 | `0x00000000/codecs/0x00001190/`（DECLARE 对象 `1190`） |
| 章节 | 8 `1000`（Edge TOULMIN），章节内偏移 C = 25 |
| Kind | Edge · 系列：TOULMIN，分组：结果 |
| TAG WORD | `0001 0001 1001 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 判定的证据。位置、期望值、实际值（Fact）。布局未定 |
| Hugo 侧 | `edge/toulmin/_index.md` |

## 布局 {#레이아웃}

只分配了代码，尚无布局（[TOULMIN](_index.md#열린-문제)）。

- 判定结果放在与判定对象不同的文档中（[TOULMIN](_index.md#판정-결과)）。

## Codec 文档 {#코덱-문서}

布局尚未确定。Codec 文档只设有 DECLARE（对象 `1190`）。FIELD 待布局确定后再设。

## 相关页面 {#관련-페이지}

- [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001190/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000119000000000
BODY
#1 DECLARE 0x1190
#2 BIND #1 "EVIDENCE"
```
