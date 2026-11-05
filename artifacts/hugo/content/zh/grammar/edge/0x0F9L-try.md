---
title: "TRY (0x0F9L)"
weight: 249
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TRY 是执行 Edge 中“错误”分组的 Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRY 是执行 Edge 中“错误”分组的 Codec。含义：错误处理。

| 项目 | 值 |
|---|---|
| 名称 | `TRY`（规格文档 BIND `TRY`） |
| TAG ID | `0x0F9L` |
| Codec ID | `0x00000F90` |
| 规格文档 | `0x00000000/codecs/0x00000F90/`（DECLARE 目标 `0F90`） |
| 章节 | 7 `0111`（Edge 执行），章节内偏移 C = 25 |
| Kind | Edge · 系列：执行，分组：错误 |
| TAG WORD | `0000 1111 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 错误处理。主体 BLOCK、错误符号、处理 BLOCK、收尾 BLOCK（没有则为 0） |
| Hugo 侧 | `edge/_index.md` |

## 组成部分 {#구성요소}

主体 BLOCK、错误符号、处理 BLOCK、收尾 BLOCK（没有则为 0）。

- 组成部分用本文档的 LOCAL ID（REF）指向。REF `0` 表示无。表达式位置放表达式 Edge 或符号（[Edge](_index.md#실행-edge)）。
- 运算符代码、类型表示、Payload 布局尚未确定（[Edge](_index.md#실행-edge) 未决问题）。

## Codec 文档 {#코덱-문서}

尚未确定布局。Codec 文档只放 DECLARE（目标 `0F90`）。FIELD 在布局确定后再放。

## 相关页面 {#관련-페이지}

- [Edge — 执行 Edge](_index.md#실행-edge), [RAISE](0x0F8L-raise.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000F90/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F9000000000
BODY
#1 DECLARE 0x0F90
#2 BIND #1 "TRY"
```
