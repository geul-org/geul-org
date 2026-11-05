---
title: "VERB (0x0A9L)"
weight: 169
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB 是动词陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB 是动词陈述 Edge。缩写形式是 [VERB-SHORT](0x0A8L-verb-short.md)（`0x0A8L`）（[Edge](_index.md#서술-edge)）。

| 项目 | 值 |
|---|---|
| 名称 | `VERB`（规格文档 BIND `VERB`） |
| TAG ID | `0x0A9L` |
| Codec ID | `0x00000A90` |
| 规格文档 | `0x00000000/codecs/0x00000A90/`（DECLARE 目标 `0A90`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 9 |
| Kind | Edge · 系列：陈述，分组：命题 |
| TAG WORD | `0000 1010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 动词陈述 |
| Hugo 侧 | `edge/_index.md` |

## 布局 {#레이아웃}

布局尚未确定。遵循 Edge 通用布局（TAG、[Length 扩展 TAG]、Edge Id、组成部分）（[Edge](_index.md#레이아웃)）。

## Codec 文档 {#코덱-문서}

布局尚未确定。Codec 文档只放 DECLARE（目标 `0A90`）。FIELD 待布局确定后再放。

## 相关页面 {#관련-페이지}

- [VERB-SHORT](0x0A8L-verb-short.md)、[Edge](_index.md)、[TRIPLE](0x0AAL-triple.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000A90/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A9000000000
BODY
#1 DECLARE 0x0A90
#2 BIND #1 "VERB"
```
