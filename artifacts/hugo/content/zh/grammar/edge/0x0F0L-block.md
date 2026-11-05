---
title: "BLOCK (0x0F0L)"
weight: 240
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "BLOCK 是执行 Edge 中“语句”分组的 Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLOCK 是执行 Edge 中“语句”分组的 Codec。含义：有序语句组。

| 项目 | 值 |
|---|---|
| 名称 | `BLOCK`（规格文档 BIND `BLOCK`） |
| TAG ID | `0x0F0L` |
| Codec ID | `0x00000F00` |
| 规格文档 | `0x00000000/codecs/0x00000F00/`（DECLARE 目标 `0F00`） |
| 章节 | 7 `0111`（Edge 执行），章节内偏移 C = 16 |
| Kind | Edge · 系列：执行，分组：语句 |
| TAG WORD | `0000 1111 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 有序语句组。语句数、语句 × 语句数 |
| Hugo 侧 | `edge/_index.md` |

## 组成部分 {#구성요소}

语句数、语句 × 语句数。

- 组成部分用本文档的 LOCAL ID（REF）指向。REF `0` 表示无。表达式位置放表达式 Edge 或符号（[Edge](_index.md#실행-edge)）。
- 运算符代码、类型表示、Payload 布局尚未确定（[Edge](_index.md#실행-edge) 未决问题）。

## Codec 文档 {#코덱-문서}

尚未确定布局。Codec 文档只放 DECLARE（目标 `0F00`）。FIELD 在布局确定后再放。

## 相关页面 {#관련-페이지}

- [Edge — 执行 Edge](_index.md#실행-edge), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000F00/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F0000000000
BODY
#1 DECLARE 0x0F00
#2 BIND #1 "BLOCK"
```
