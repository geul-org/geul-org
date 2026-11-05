---
title: "WORLD (0x0B0L)"
weight: 176
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "WORLD 是书写世界观的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WORLD 是书写世界观的陈述 Edge。含义：用于表现世界观的结构。

| 项目 | 值 |
|---|---|
| 名称 | `WORLD`（规格文档 BIND `WORLD`） |
| TAG ID | `0x0B0L` |
| Codec ID | `0x00000B00` |
| 规格文档 | `0x00000000/codecs/0x00000B00/`（DECLARE 目标 `0B00`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 16 |
| Kind | Edge · 系列：陈述，分组：结构 |
| TAG WORD | `0000 1011 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 用于表现世界观的结构 |
| Hugo 侧 | `edge/_index.md` |

## 布局 {#레이아웃}

```
TAG WORD          0000 1011 0000 LLLL      Codec 0x0B0L
[Length 扩展 TAG]
Codec 专属 TAG    1 WORD。子格式
Edge Id           LOCAL Reference 记录
组成部分          由子格式规定
```

- 这是有子格式的 Codec。Codec 专属 TAG 1 WORD 指定子格式（[记录与 TAG WORD](../record.md#레코드-레이아웃)）。
- 子格式和组成部分尚未确定。

## Codec 文档 {#코덱-문서}

布局尚未确定。Codec 文档只放 DECLARE（目标 `0B00`）。FIELD 待布局确定后再放。

## 相关页面 {#관련-페이지}

- [TIMELINE](0x0B1L-timeline.md)、[SCENE](0x0B2L-scene.md)、[Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제)（带有子格式的 Codec 的声明方法）

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000B00/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B0000000000
BODY
#1 DECLARE 0x0B00
#2 BIND #1 "WORLD"
```
